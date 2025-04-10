#include "x2_inc_itemprop"
#include "x2_inc_switches"

/*Funcion usada para envenenar un arma, para posteriormente usarla contra una
criatura*/
int EnvenenarArma(object oTarget, object oActivator, int idVenom);

//Funcion usada para envenenar un ubicado o una criatura
void VenenoContacto(object oTarget, object oActivator, int idVenom);

//Funcion para envenenar pociones y bebedizos.
void EnvenenarPocion(object oTarget, object oActivator, int idVenom);

void main() {
    object oItem = GetItemActivated();
    object oActivator = GetItemActivator();
    object oTarget = GetItemActivatedTarget();
    location lLugarActivator = GetLocation(oActivator);
    location lLugar = GetItemActivatedTargetLocation();

    //Si entra una pocion envenenada...
    string sTag = GetTag(oItem);
    sTag = GetStringRight(sTag, 10);

    if (sTag == "envenenada"){
        //Obtiene nuevamente el tag de la pocion
        sTag = GetTag(oItem);
        //Y obtiene el id de la pocion cargado en el tag
        sTag = GetStringRight(sTag, 13);
        sTag = GetStringLeft(sTag, 2);
        //Aplica la pocion al efecto
        effect eVenon = EffectPoison(StringToInt(sTag));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVenon, oTarget);
        SendMessageToPC(oTarget, "¡La poción está envenenada!");
    }

    //Si no es un veneno no continua.
    if (GetStringLeft(GetTag(oItem), 15) != "Saquitodeveneno") return;

    //Obtenemos el veneno utilizado.
    int idVeneno = StringToInt(GetStringRight(GetTag(oItem), 2));

    //Venenos de herida.
    if ((idVeneno >= 1 && idVeneno <= 12) || idVeneno == 36) {
        EnvenenarArma(oTarget, oActivator, idVeneno);
    }

    //Venenos de contacto.
    if (idVeneno >= 13 && idVeneno <= 19) {
        VenenoContacto(oTarget, oActivator, idVeneno);
    }

    //Venenos de ingestion
    if (idVeneno >= 20 && idVeneno <= 25) {
        EnvenenarPocion(oTarget, oActivator, idVeneno);
    }
}

int EnvenenarArma(object oTarget, object oActivator, int idVenom){
    if (oTarget == OBJECT_INVALID || GetObjectType(oTarget) != OBJECT_TYPE_ITEM) {
        FloatingTextStrRefOnCreature(83359,oActivator);         //"Objetivo no válido"
        return FALSE;
    }

    int nType = GetBaseItemType(oTarget);
    int nHandleDC = StringToInt(Get2DAString("poison", "Handle_DC", idVenom));

    if (!IPGetIsMeleeWeapon(oTarget) &&
    !IPGetIsProjectile(oTarget)   &&
    nType != BASE_ITEM_SHURIKEN &&
    nType != BASE_ITEM_DART &&
    nType != BASE_ITEM_THROWINGAXE){
        FloatingTextStrRefOnCreature(83359,oActivator);         //"Objetivo no válido"
        return FALSE;
    }

    if (IPGetIsBludgeoningWeapon(oTarget)){
        FloatingTextStrRefOnCreature(83367,oActivator);         //"Arma no válida"
        return FALSE;
    }

    if (IPGetItemHasItemOnHitPropertySubType(oTarget, 19)) // 19 == itempoison
    {
    FloatingTextStrRefOnCreature(83407,oActivator); // El arma esta aun envenenada
        return FALSE;
    }

    //Existe una probabilidad del 5% de que el usuario quede envenenado con los venenos de contacto.
    int Porcentaje = d100(1);
    if (Porcentaje <= 5) {
        effect eVeneno = EffectPoison(idVenom);
        SendMessageToPC(oActivator, "* Empleo de venenos: Has tenido un error al utilizar el veneno y accidentalmente toca tu cuerpo *");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT ,eVeneno, oActivator);
    }

    int bHasFeat = GetHasFeat(960, oActivator);
    if (!bHasFeat){
        // * Forzamos teoricamente un ataque de oportunidad.
        AssignCommand(oActivator,ClearAllActions(TRUE));

        // Si envenenar arma esta restrigindo solo a personajes con la dote.
        if (GetModuleSwitchValue(MODULE_SWITCH_RESTRICT_USE_POISON_TO_FEAT) == TRUE){
            FloatingTextStrRefOnCreature(84420,oActivator);               //"Fallo"
            return FALSE;
        }

        int nDex = GetAbilityModifier(ABILITY_DEXTERITY,oActivator);
        int nCheck = d20(1)+nDex;
        if (nCheck < nHandleDC) {
            FloatingTextStrRefOnCreature(83368,oActivator);               //"Fallo"
            return FALSE;
        }
        else{
            FloatingTextStrRefOnCreature(83370,oActivator);               //"Acierto"
        }
    }
    else
    {
        FloatingTextStrRefOnCreature(83369,oActivator);                   //"Auto acierto"
    }
    FloatingTextStrRefOnCreature(83361,oActivator);                       //"Arma fue envenenada."
    effect eVis = EffectVisualEffect(VFX_IMP_PULSE_NATURE);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oTarget));
    itemproperty ipVenom = ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_POISON, 40);
    float nDuracion = HoursToSeconds(3);                           //Todos los venenos duran 3 horas en el arma.
    IPSafeAddItemProperty(oTarget, ipVenom, nDuracion);
    IPSafeAddItemProperty(oTarget, ItemPropertyVisualEffect(ITEM_VISUAL_ACID), nDuracion);
    SetLocalInt(oTarget, "idVeneno", idVenom);
    return TRUE;
}

//Funcion para los venenos de contacto
void VenenoContacto(object oTarget, object oActivator, int idVenom){
    //Prepara el veneno
    effect eVeneno = EffectPoison(idVenom);
    int nProbabilidad = 5;

    //Hace que el personaje mire al objetivo, para que no ponga un veneno a su espalda
    AssignCommand(oActivator, SetFacingPoint(GetPosition(oTarget)));

    //Presenta la animacion del personaje
    AssignCommand(oActivator, ActionPlayAnimation(ANIMATION_FIREFORGET_STEAL));

    //Revisa el tipo de objetivo, para que funcione de una forma u otra.
    if (GetObjectType(oTarget) == OBJECT_TYPE_DOOR ||
    GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE){
        //------------------------------------------------------------------
        //VENENO APLICADO SOBRE UBICADO
        //------------------------------------------------------------------
        //Marcador para prueba de destreza
        int iDexCheck = FALSE;
        //Si se desea aplicar el veneno en un ubicado, revisa si se tiene la dote empleo de venenos.
        int bHasFeat = GetHasFeat(960, oActivator);
        if (!bHasFeat){
            //Si no se tiene la dote se hace la prueba de destreza
            int iTirada = d20(1)+GetAbilityModifier(ABILITY_DEXTERITY);
            int nHandleDC = StringToInt(Get2DAString("poison", "Handle_DC", idVenom));
            if (iTirada < nHandleDC){
                SendMessageToPC(oActivator, "* Empleo de venenos: Fallo en la prueba de destreza *");
                iDexCheck = FALSE;
            } else {
                SendMessageToPC(oActivator, "* Empleo de venenos: Exito en la prueba de destreza, objeto envenenado *");
                iDexCheck = TRUE;
            }
        } else {
            //Si se tiene la dote se pasa la prueba automaticamente
            SendMessageToPC(oActivator, "* Empleo de venenos: Exito automático al aplicar el veneno *");
            iDexCheck = TRUE;
        }

        //Si se supera la prueba de destreza se aplica el veneno como una trampa.
        if (iDexCheck){
            SetTrapDetectable(oTarget, FALSE);
            CreateTrapOnObject(TRAP_BASE_TYPE_MINOR_GAS, oTarget, STANDARD_FACTION_HOSTILE, "", "cerr_venom_conta");
            SetTrapDetectable(oTarget, FALSE);
            SetLocalInt(oTarget, "idVeneno", idVenom);
        }
    } else {
        if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE){
            //--------------------------------------------------------------
            //VENENO APLICADO SOBRE UNA CRIATURA O PERSONAJE
            //--------------------------------------------------------------
            //Se hace al objetivo temporalmente enemigo (esto es mas de cara a los personajes de jugador)
            SetIsTemporaryEnemy(oTarget, oActivator, TRUE, 180.0);

            if(TouchAttackMelee(oTarget) > 0) {
                //Si la tirada supera la CA de destreza o bien se saca un 20 natural se consigue el toque.
                ApplyEffectToObject(DURATION_TYPE_PERMANENT ,eVeneno, oTarget);
            }
        } else {
            //Si el objetivo no es valido, se avisa al usuario y no se produce efecto alguno.
            SendMessageToPC(oActivator, "* Objetivo no válido: Solo pueden aplicarse venenos de contacto sobre mobiliario, puertas o seres vivos *");
        }
        if(GetIsInCombat(oActivator)) {
            nProbabilidad = 40;
        } else {
            nProbabilidad = 25;
        }
    }

    //Existe una probabilidad del 5% de que el usuario quede envenenado con los venenos de contacto.
    int Porcentaje = d100(1);
    if (Porcentaje > nProbabilidad) return;
    SendMessageToPC(oActivator, "* Empleo de venenos: Has tenido un error al utilizar el veneno y accidentalmente toca tu cuerpo *");
    ApplyEffectToObject(DURATION_TYPE_PERMANENT ,eVeneno, oActivator);
}

void EnvenenarPocion(object oTarget, object oActivator, int idVenom) {
    int iAplicable = 0; //Sin efecto no es un objeto valido

    //Pociones y alcoholes ya sean de paleta o creadas
    if (GetBaseItemType(oTarget) == BASE_ITEM_POTIONS) iAplicable = 1;

    int iConjuroCargado;
    itemproperty ipPropiedad=GetFirstItemProperty(oTarget);
    if(GetItemPropertyType(ipPropiedad) == ITEM_PROPERTY_CAST_SPELL){
        //Las pociones de restablecimiento y neutralizar veneno, tienen un
        //efecto especial en el veneno.
        iConjuroCargado = GetItemPropertySubType(ipPropiedad);
        switch(iConjuroCargado) {
            case IP_CONST_CASTSPELL_GREATER_RESTORATION_13:
            case IP_CONST_CASTSPELL_LESSER_RESTORATION_3:
            case IP_CONST_CASTSPELL_RESTORATION_7:
            case IP_CONST_CASTSPELL_NEUTRALIZE_POISON_5:
            case IP_CONST_CASTSPELL_HEAL_11:
                iAplicable = 2;
                break;
        }
    }

    //Pocion purificadora (Neutralizar veneno)
    if (GetTag(oTarget) == "sute_her_041_040_n") {
        iAplicable = 2;
    }

    //Pocion de alivio y Alivio potenciada (Restablecimiento menor y Restablecimiento)
    if (GetTag(oTarget) == "sute_her_066_060_n" || GetTag(oTarget) == "sute_her_066_060_p") {
        iAplicable = 2;
    }

    if (iAplicable == 0){
        SendMessageToPC(oActivator, "Este veneno solo puede lanzarse sobre pociones o bebidas alcoholicas");
    }

    if (iAplicable == 1){
        //Marcador para prueba de destreza
        int iDexCheck = FALSE;
        //Si se desea aplicar el veneno en un ubicado, revisa si se tiene la dote empleo de venenos.
        int bHasFeat = GetHasFeat(960, oActivator);
        if (!bHasFeat){
            //Si no se tiene la dote se hace la prueba de destreza
            int iTirada = d20(1)+GetAbilityModifier(ABILITY_DEXTERITY);
            int nHandleDC = StringToInt(Get2DAString("poison", "Handle_DC", idVenom));
            if (iTirada < nHandleDC){
                SendMessageToPC(oActivator, "* Empleo de venenos: Fallo en la prueba de destreza *");
                iDexCheck = FALSE;
            } else {
                SendMessageToPC(oActivator, "* Empleo de venenos: Exito en la prueba de destreza, objeto envenenado *");
                iDexCheck = TRUE;
            }
        } else {
            //Si se tiene la dote se pasa la prueba automaticamente
            SendMessageToPC(oActivator, "* Empleo de venenos: Exito automático al aplicar el veneno *");
            iDexCheck = TRUE;
        }

        //Si se supera la prueba de destreza se aplica el veneno como una trampa.
        if (iDexCheck){
            object oCreado = CreateItemOnObject(GetResRef(oTarget), oActivator, 1, IntToString(idVenom)+"_envenenada");
            SetName(oCreado, GetName(oTarget));
            SetIdentified(oCreado, TRUE);
            if (GetNumStackedItems(oTarget) > 1){
                SetItemStackSize(oTarget, GetItemStackSize(oTarget)-1);
            } else {
                DestroyObject(oTarget);
            }
            SendMessageToPC(oActivator, "Poción envenenada");
        }
    }

    if (iAplicable == 2){
        SendMessageToPC(oActivator, "La poción reacciona con el veneno convirtiendose en un líquido neutro y sin magia");
        if (GetNumStackedItems(oTarget) > 1){
            SetItemStackSize(oTarget, GetItemStackSize(oTarget)-1);
        } else {
            DestroyObject(oTarget);
        }
    }
}
