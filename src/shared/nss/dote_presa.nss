//------------------------------------------------------------------------------
//:: DOTE PRESA
//:: Creado Jose Maria NDAH (cerril)
//:: 09 de agosto de 2016
//------------------------------------------------------------------------------
//:: Guion que permite el uso de las presas.
//------------------------------------------------------------------------------

#include "pb_tiradas_inc"

int Apresable(object oTarget);
int GetModificadores(object oCreature);
int OpportunityAttack(object oTarget);
int PruebaPresa(object oAtacante, object oDefensor);
void Rellamada(object oTarget, location lPosicion);

void main()
{
    //Declarando variables
    object oPrimaria = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
    object oSecundaria = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
    object oTarget = GetSpellTargetObject();

    //Comprueba que el objetivo no sea el atacante.
    if(oTarget == OBJECT_SELF) return;

    /* Realiza la comprobacion de armas, si se lleva equipada alguna la presa
     * falla y nos devuelve un mensaje informativo.
     */
    if(oPrimaria != OBJECT_INVALID || oSecundaria != OBJECT_INVALID){
        FloatingTextStringOnCreature("Solo puedes apresar desarmado",OBJECT_SELF);
        return;
    }
    /* Realiza la comprobacion de si el blanco o el atacante estan afectados por
     * los conjuros prohibidos.
     */
    if(GetHasSpellEffect(SPELL_ELEMENTAL_SHIELD,OBJECT_SELF)
    || GetHasSpellEffect(SPELL_ELEMENTAL_SHIELD,oTarget)){
        //Si el atacante o el defensor estan bajo un escudo elemental.
        FloatingTextStringOnCreature("No es posible apresar al blanco.",OBJECT_SELF);
        return;
    }
    if(GetHasSpellEffect(SPELL_DEATH_ARMOR,OBJECT_SELF)
    || GetHasSpellEffect(SPELL_DEATH_ARMOR,oTarget)){
        //Si el atacante o el defensor estan bajo una armadura de la muerte.
        FloatingTextStringOnCreature("No es posible apresar al blanco.",OBJECT_SELF);
        return;
    }
    if(GetHasSpellEffect(SPELL_ACID_SPLASH,OBJECT_SELF)
    || GetHasSpellEffect(SPELL_ACID_SPLASH,oTarget)){
        //Si el atacante o el defensor estan bajo una vaina acida.
        FloatingTextStringOnCreature("No es posible apresar al blanco.",OBJECT_SELF);
        return;
    }

    //Revisamos que el defensor no este bajo el efecto de un aura divina.
    if(GetHasSpellEffect(SPELL_HOLY_AURA,oTarget)){
        //Si el atacante es de alineamiento maligno...
        if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_EVIL){
            FloatingTextStringOnCreature("No es posible apresar al blanco.",OBJECT_SELF);
            return;
        }
    }
    //Revisamos que el atacante no este bajo el efecto de un aura divina.
    if(GetHasSpellEffect(SPELL_HOLY_AURA,OBJECT_SELF)){
        //Si el defensor es de alineamiento maligno...
        if (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL){
            FloatingTextStringOnCreature("No es posible apresar al blanco.",OBJECT_SELF);
            return;
        }
    }
    //Revisamos que el defensor no este bajo el efecto de un aura maligna.
    if(GetHasSpellEffect(SPELL_UNHOLY_AURA,oTarget)){
        //Si el atacante es de alineamiento bueno...
        if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_GOOD){
            FloatingTextStringOnCreature("No es posible apresar al blanco.",OBJECT_SELF);
            return;
        }
    }
    //Revisamos que el atacante no este bajo el efecto de un aura maligna.
    if(GetHasSpellEffect(SPELL_UNHOLY_AURA,OBJECT_SELF)){
        //Si el defensor es de alineamiento bueno...
        if (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_GOOD){
            FloatingTextStringOnCreature("No es posible apresar al blanco.",OBJECT_SELF);
            return;
        }
    }

    //Hostiliza al blanco.
    SetIsTemporaryEnemy(OBJECT_SELF,oTarget);

    /* Realiza la comprobacion de diferencia de tamanho entre el atacante y el
     * objetivo. Si el objetivo supera en 2 o mas categorias de tamanho al
     * atacante la presa falla.
     */
    if(!Apresable(oTarget)){
        FloatingTextStringOnCreature(GetName(oTarget)+" es demasiado grande para poder ser apresado.",OBJECT_SELF);
        return;
    }

    // Si todo esta correcto iniciamos la secuencia de apresado.
    /* Si no el guion es desencadenado por presa el oponente gana un ataque de
     * oportunidad.
     */
    if(GetSpellId() == 889){
        if(OpportunityAttack(oTarget)){
            FloatingTextStringOnCreature("Has sido golpeado por "+GetName(oTarget)+", la presa ha fallado.", OBJECT_SELF);
            return;
        }
    }

    //Realizamos el ataque de toque cuerpo a cuerpo.
    if(!TouchAttackMelee(oTarget)){
        return;
    }

    //Cargamos un location en la posicion del personaje.
    location lPosicion = GetLocation(OBJECT_SELF);

    //Iniciamos la primera prueba de presa.
    Rellamada(oTarget,lPosicion);
}

// Esta funcion simula un ataque de oportunidad.
int OpportunityAttack(object oTarget){
    //Pendiente de programar.
    FloatingTextStringOnCreature("<c´þd>¡Ataque de oportunidad!</c>", OBJECT_SELF);
    object oArma = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);

    int nTirAt = d20(1);
    int nBonAt = GetBonoAtaque(oTarget, oArma, OBJECT_SELF);
    int nTotAt = nTirAt+nBonAt;
    int nResultado = GetAC(OBJECT_SELF)-nTotAt;

    string sMensaje = "<cÌwþ>Ataque de oportunidad contra "+GetName(OBJECT_SELF)+": ";
    if(nTirAt == 20){
        sMensaje += "<c þ >*exito automatico*: ";
        nResultado = TRUE;
    } else if(nTirAt == 1){
        sMensaje += "<cþA >*pifia*: ";
        nResultado = FALSE;
    } else {
        if(nResultado < 0){
            sMensaje += "<c þ >*golpeado*: ";
            nResultado = TRUE;
        } else {
            sMensaje += "<cþA >*fallo*: ";
            nResultado = FALSE;
        }
    }
    sMensaje += "<cþf >("+IntToString(nTirAt)+" + "+IntToString(nBonAt)+" = "+IntToString(nTotAt)+")";
    SendMessageToPC(OBJECT_SELF, sMensaje);
    SendMessageToPC(oTarget, sMensaje);
    return nResultado;
}

// Esta funcion devuelve TRUE si el objetivo es apresable y FALSE en caso contrario.
int Apresable(object oTarget){
    int nMySize = GetCreatureSize(OBJECT_SELF);
    int nTargetSize = GetCreatureSize(oTarget);
    int nDiferencia = nTargetSize - nMySize;
    int nRetorno = TRUE;
    if (nDiferencia >= 2) nRetorno = FALSE;
    return nRetorno;
}

// Esta funcion devuelve el modificador a la tirada de presa en funcion del
// Tamanho de la criatura.
int GetModificadores(object oCreature){
    /* A la categoria de tamanho que se nos pasa se le resta 3 que es el valor
     * de la categoria de tamanho mediana, el numero obtenido se multiplicara
     * por 4 dandonos exactamente el modificador de cada categoria de tamanho
     * que figura en el manual.
     */
     int nCreatureSize = GetCreatureSize(oCreature);
     int nRetorno = nCreatureSize - CREATURE_SIZE_MEDIUM;
     nRetorno *= 4;
     return nRetorno;
}

// Esta funcion realiza y devuelve el resultado de una prueba enfrentada de presa
int PruebaPresa(object oAtacante, object oDefensor){
    //Tiradas y bonos del atacante
    int nTirAt = d20(1);
    int nBonAt = GetAbilityModifier(ABILITY_STRENGTH, oAtacante);
    nBonAt += GetBaseAttackBonus(oAtacante);
    nBonAt += GetModificadores(oAtacante);
    //Si el atacante tiene la dote presa mejorada.
    if(GetHasFeat(1231, oAtacante)){
        nBonAt += 4;
    }
    int nTotAt = nTirAt+nBonAt;

    //Tiradas y bonos del defensor
    int nTirDf = d20(1);
    int nBonDf = GetAbilityModifier(ABILITY_STRENGTH, oDefensor);
    nBonDf += GetBaseAttackBonus(oDefensor);
    nBonDf += GetModificadores(oDefensor);
    //Si el defensor tiene la dote presa mejorada.
    if(GetHasFeat(1231, oDefensor)){
        nBonDf += 4;
    }

    /* Si el bonificador total de la habilidad escapismo del defensor es mayor
     * al bono total a la tirada de presa, se aplica el bono de escapismo a la
     * tirada
     */
    if(GetSkillRank(32, oDefensor) > nBonDf){
        //La id de escapismo es 32.
        nBonDf = GetSkillRank(32, oDefensor);
    }

    int nTotDf = nTirDf+nBonDf;

    //Calcula el resultado.
    int nResultado = nTotAt - nTotDf;

    //Texto de informacion de la tirada enfrentada.
    string sMensaje = "<cÖþþ>"+GetName(oAtacante)+" <cÌwþ>prueba de presa contra "+GetName(oDefensor)+": ";
    if(nResultado > 0){
        sMensaje += "<c þ >*apresado*: ";
    } else {
        sMensaje += "<cþA >*fallo en la presa*: ";
    }
    sMensaje += "<cþf >("+IntToString(nTirAt)+" + "+IntToString(nBonAt)+" = "+IntToString(nTotAt)+")";
    sMensaje += " contra ";
    sMensaje += "("+IntToString(nTirDf)+" + "+IntToString(nBonDf)+" = "+IntToString(nTotDf)+")";

    //Devolvemos la informacion tanto al atacante como al defensor.
    SendMessageToPC(oAtacante, sMensaje);
    SendMessageToPC(oDefensor, sMensaje);

    //Devolvemos el resultado de la prueba de presa.
    if(nResultado > 0){
        return TRUE;
    } else {
        return FALSE;
    }
}

void Rellamada(object oTarget, location lPosicion){
    effect eParalisis = ExtraordinaryEffect(EffectCutsceneParalyze());
    effect eVelocidad = ExtraordinaryEffect(EffectMovementSpeedDecrease(90));
    effect eConjuro = ExtraordinaryEffect(EffectSpellFailure(100));
    effect eFisico = ExtraordinaryEffect(EffectMissChance(100));
    location lActual = GetLocation(OBJECT_SELF);

    if(GetDistanceBetweenLocations(lPosicion, lActual) == 0.0){
        if(PruebaPresa(OBJECT_SELF, oTarget)){
            //Si la presa continua hacemos una nueva llamada.
            DelayCommand(RoundsToSeconds(1), Rellamada(oTarget,lPosicion));

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eParalisis, oTarget, RoundsToSeconds(1));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVelocidad, OBJECT_SELF, RoundsToSeconds(1));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eConjuro, OBJECT_SELF, RoundsToSeconds(1));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFisico, OBJECT_SELF, RoundsToSeconds(1));
        }
    } else {
        SendMessageToPC(OBJECT_SELF, "<cþA >"+GetName(OBJECT_SELF)+" se ha movido, la presa se rompe");
        SendMessageToPC(oTarget, "<cþA >"+GetName(OBJECT_SELF)+" se ha movido, la presa se rompe");
    }
}
