//::////////////////////////////////////////////////////////////////////////////
//:: Nombre del guion:  wrap_on_equip_it                                  //:://
//::////////////////////////////////////////////////////////////////////////////
//:: GUION ON_EQUIP_ITEM PARA EL SERVIDOR PUERTA DE BALDUR                //:://
//:: Creado por Monti                                                     //:://
//::////////////////////////////////////////////////////////////////////////////

#include "dote_comp_armas"
#include "mti_subrazas_inc"
#include "f_vampire_h"
#include "nostack_inc"
#include "pb_ip_slots_inc"
#include "mti_libreria"
#include "inc_sqlite_time"
#include "NW_I0_SPELLS"
#include "lib_dm_vfx"
#include "pb_inc_mmf"

void ApplyAutoFrenzy(object oPC, object oArmor)
{
     IPSafeAddItemProperty(oArmor, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
}

void main()
{
    object oPC = GetPCItemLastEquippedBy();
    object oObjetoEquipado = GetPCItemLastEquipped();
    string sObjetoEquipado = GetTag(oObjetoEquipado);
    int iTipoObjetoEquipado = GetBaseItemType(oObjetoEquipado);

    //MAESTRO MULTIPLES FORMAS
    MMF_EquipCheck(oPC,oObjetoEquipado);

    // No apilamiento 3.5 en caracteristicas. habilidades, salvaciones y regeneracion
    NoSkillStackOnEquip(oPC, oObjetoEquipado);
    NoAbilityStackOnEquip(oPC, oObjetoEquipado);
    NoSavingThrowStackOnEquip(oPC, oObjetoEquipado);
    NoRegStackOnEquip(oPC, oObjetoEquipado, 1);

    if(GetStringLeft(sObjetoEquipado,3) == "MMF") return;
    //Si tiene mas de tres propiedades, los objetos de oficio guardan una variable si no son mas de nivel 16 antes 15.
    if(GetLocalInt(oObjetoEquipado, "masNivel15") == 1 && GetHitDice(oPC) <= 16) //15
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oPC, 2.0);
        DelayCommand(1.0, AssignCommand(oPC, ClearAllActions()));
        AssignCommand(oPC, ActionUnequipItem(oObjetoEquipado));
        SendMessageToPC(oPC, "<cþ<<>* Este objeto es para más de nivel 16 *</c>");//15
    }

    // Si al objeto se le acabo el encantamiento y aun lo tiene por bug, se lo quitamos
    int iFinTemporizador = GetLocalInt(oObjetoEquipado, "FIN_TEMPORIZADOR");
    if(iFinTemporizador > 0)
    {
        if(iFinTemporizador < StringToInt(SQLite_GetSystemTime()))
        {
            EliminarPropiedadesTemporales(oObjetoEquipado);
            DeleteLocalInt(oObjetoEquipado, "FIN_TEMPORIZADOR");
        }
    }

    // LIMITADOR DE CA JOSE-G-C 13-6-2015
    //Si el objeto tiene mas de CA 3 como propiedad permanente, le bajamos en caso de no ser el nivel adecuado
    //funcion que puede usarse ObtenerBonificadorMejoraPermanente(mti_libreria)
    itemproperty iprop = GetFirstItemProperty(oObjetoEquipado);
    int BonoCA, BonoCHA;
    int Nivel = GetHitDice(oPC);
    if(GetLocalInt(oObjetoEquipado, "BonoCA")== 0 || GetLocalInt(oObjetoEquipado, "BonoCHA")== 0)
    {
        while (GetIsItemPropertyValid(iprop))
        {
            //Lo aplicamos solo a propiedades permanentes para evitar confundirla con temporales de clerigo
            if( (GetItemPropertyType(iprop) == ITEM_PROPERTY_AC_BONUS) && (GetItemPropertyDurationType(iprop)== DURATION_TYPE_PERMANENT ) )
            {
                if ( (Nivel <= 12) && (Nivel != 0) )//( (Nivel <= 10) && (Nivel != 0) )
                {
                    // Comprobamos si el valor de CA es mayor que el permitido al 12 antes 10
                    if (GetItemPropertyCostTableValue( iprop) > 3)//>3
                    {
                        //Comprobamos que no esta limitado en una entrada anterior
                        BonoCA = RemovePropertyAndReturnModifier(oObjetoEquipado, ITEM_PROPERTY_AC_BONUS );
                        SetLocalInt(oObjetoEquipado, "BonoCA", BonoCA);
                        IPSafeAddItemProperty(oObjetoEquipado, ItemPropertyACBonus(3));
                        //AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(3), oObjetoEquipado);
                        SendMessageToPC(oPC,"<cþ<<>* Este objeto tiene mas CA de la permitida para tu nivel, sera ajustada hasta desequipar *</c>");
                    }
                }
                else if ( (Nivel <= 16) && (Nivel != 0) )//( (Nivel <= 15) && (Nivel != 0) )
                {
                    // Comprobamos si el valor de CA es mayor que el permitido al 16 antes 15
                    if (GetItemPropertyCostTableValue( iprop) > 4)//>4
                    {
                        //Comprobamos que no esta limitado en una entrada anterior
                        BonoCA = RemovePropertyAndReturnModifier(oObjetoEquipado, ITEM_PROPERTY_AC_BONUS );
                        SetLocalInt(oObjetoEquipado, "BonoCA", BonoCA);
                        IPSafeAddItemProperty(oObjetoEquipado, ItemPropertyACBonus(4));
                        //AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(4), oObjetoEquipado);
                        SendMessageToPC(oPC,"<cþ<<>* Este objeto tiene mas CA de la permitida para tu nivel, sera ajustada hasta desequipar *</c>");
                    }
                }
            }

            //Comprobar si el objeto tiene una modificación a Caracteristica.
            if( (GetItemPropertyType(iprop) == ITEM_PROPERTY_ABILITY_BONUS) && (GetItemPropertyDurationType(iprop)== DURATION_TYPE_PERMANENT ) )
            {
                if ( (Nivel <= 12) && (Nivel != 0) )//( (Nivel <= 10) && (Nivel != 0) )
                {
                    // Comprobamos si el valor a Característica es mayor que el permitido al 12
                    if (GetItemPropertyCostTableValue(iprop) > 5)//
                    {
                        //Comprobamos que no esta limitado en una entrada anterior
                        BonoCHA = RemovePropertyAndReturnModifier(oObjetoEquipado, ITEM_PROPERTY_ABILITY_BONUS);
                        SetLocalInt(oObjetoEquipado, "BonoCHA", BonoCHA);
                        IPSafeAddItemProperty(oObjetoEquipado,ItemPropertyAbilityBonus(GetItemPropertySubType(iprop), 5));

                        SendMessageToPC(oPC,"<cþ<<>* Este objeto tiene más valor a Característica de la permitida para tu nivel, sera ajustada hasta desequipar *</c>");
                    }
                }
            }

            //Comprobar si el objeto tiene una habilidad superior a 10, la colocamos en 7.
            if( (GetItemPropertyType(iprop) == ITEM_PROPERTY_SKILL_BONUS) && (GetItemPropertyDurationType(iprop)== DURATION_TYPE_PERMANENT ) )
            {
                // Comprobamos el valor de la habilidad
                if (GetItemPropertyCostTableValue(iprop) > 7)//
                {
                    IPSafeAddItemProperty(oObjetoEquipado,ItemPropertySkillBonus(GetItemPropertySubType(iprop), 7),0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);

                    SendMessageToPC(oPC,"<cþ<<>* Este objeto tiene una habilidad superior a siete, sera reemplazada por el valor de normativa. *</c>");
                }
            }

            //Comprobar si el objeto tiene bono de ataque y lo reemplazamos por mejora. ITEM_PROPERTY_ENHANCEMENT_BONUS
            if( (GetItemPropertyType(iprop) == ITEM_PROPERTY_ATTACK_BONUS) && (GetItemPropertyDurationType(iprop)== DURATION_TYPE_PERMANENT ) )
            {
                    int bonusAB = RemovePropertyAndReturnModifier(oObjetoEquipado, ITEM_PROPERTY_ATTACK_BONUS);
                    IPSafeAddItemProperty(oObjetoEquipado,ItemPropertyEnhancementBonus(bonusAB),0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
                    SendMessageToPC(oPC,"<cþ<<>* Este objeto posee bono de ataque y sera reemplazado por mejora. *</c>");
            }

            /*if((GetItemPropertyType(iprop) == ITEM_PROPERTY_REGENERATION) && (GetItemPropertyDurationType(iprop)== DURATION_TYPE_PERMANENT ) && GetLocalInt(oPC, "dm_noreg") == 1)
            {
                int iCantidad = GetItemPropertyCostTableValue(iprop);
                SetLocalInt(oObjetoEquipado,"RegeneracionEliminada",iCantidad);
                RemoveItemProperty(oObjetoEquipado, iprop);
                SendMessageToPC(oPC,"<cþ<<>* Este objeto posee regeneración y tu PJ no puede usar regeneración y/o curaciones. *</c>");
            } */

            iprop = GetNextItemProperty(oObjetoEquipado);
        }
    }

    //Bonos armas Cavalier al equipar cuando esta montado
    effect eMasAtaque;
    if(GetLevelByClass(52, oPC) >= 1 && GetLevelByClass(52, oPC) < 5)eMasAtaque = SupernaturalEffect(EffectAttackIncrease(1));
    if(GetLevelByClass(52, oPC) >= 5 && GetLevelByClass(52, oPC) < 9)eMasAtaque = SupernaturalEffect(EffectAttackIncrease(2));
    if(GetLevelByClass(52, oPC) >= 9)eMasAtaque = SupernaturalEffect(EffectAttackIncrease(3));
    if(GetHasFeat(1412, oPC))
    {
        if(ObtenerIntPersistente(oPC, "CAB_MONTADO") > 0 )
        {
            if( iTipoObjetoEquipado == BASE_ITEM_LONGSWORD || iTipoObjetoEquipado == BASE_ITEM_SHORTSPEAR || iTipoObjetoEquipado == BASE_ITEM_SHORTSWORD )
            {
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMasAtaque, oPC);
                return;
            }
        }
        else if( iTipoObjetoEquipado == BASE_ITEM_LONGSWORD || iTipoObjetoEquipado == BASE_ITEM_SHORTSPEAR || iTipoObjetoEquipado == BASE_ITEM_SHORTSWORD )
        {
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectAttackIncrease(1)), oPC);
            return;
        }
        else ReaplicarEfectosPB(oPC, TRUE);
    }

    // DESACTIVACON DE MODOS
    // 1. Ataque poderoso
    // 2. Disparo multiple
    // 3. Combate con dos armas mayor
    // 4. Defensa con dos armas
    // 5. Carrera
    // 6. Posición de Falange
    if(GetHasSpellEffect(898, oPC))
    {
        FloatingTextStringOnCreature("<cþ<<>* Modo Ataque poderoso desactivado *</c>", oPC, FALSE);
        RemoveEffectsFromSpell(oPC, 898);
    }
    if(GetHasSpellEffect(980, oPC) || GetHasSpellEffect(981, oPC))
    {
        if (GetBaseItemType(oObjetoEquipado) != BASE_ITEM_ARROW &&      //Flechas
            GetBaseItemType(oObjetoEquipado) != BASE_ITEM_BULLET &&     //Balas
            GetBaseItemType(oObjetoEquipado) != BASE_ITEM_BOLT)          //Virotes
        {
            FloatingTextStringOnCreature("<cþ<<>* Modo Disparo Múltiple desactivado *</c>", oPC, FALSE);
            RemoveEffectsFromSpell(oPC, 980);
            RemoveEffectsFromSpell(oPC, 981);
        }
    }
    if(GetHasSpellEffect(982, oPC))
    {
        FloatingTextStringOnCreature("<cþ<<>* Modo Combate con dos armas Mayor desactivado *</c>", oPC, FALSE);
        RemoveEffectsFromSpell(oPC, 982);
    }
    if(GetHasSpellEffect(983, oPC))
    {
        FloatingTextStringOnCreature("<cþ<<>* Modo Defensa con dos armas desactivado *</c>", oPC, FALSE);
        RemoveEffectsFromSpell(oPC, 983);
    }
    //La dote carrera solo se desactiva cuando cambias la armadura (la única condicionante de la dote).
    if(GetHasSpellEffect(984, oPC) && GetBaseItemType(oObjetoEquipado) == BASE_ITEM_ARMOR)
    {
        FloatingTextStringOnCreature("<cþ<<>* Modo Carrera desactivado *</c>", oPC, FALSE);
        RemoveEffectsFromSpell(oPC, 984);
    }
    if(GetHasSpellEffect(1328, oPC))
    {
        FloatingTextStringOnCreature("<cþ<<>** Posición de Falange Desactivada **</c>", oPC, FALSE);
        RemoveEffectsFromSpell(oPC, 1328);
    }

    // COMPETENCIAS (Armas, armaduras y escudos)
    AplicarCompetenciaArmas(oPC, oObjetoEquipado, iTipoObjetoEquipado);
    if (iTipoObjetoEquipado == BASE_ITEM_TOWERSHIELD || iTipoObjetoEquipado == BASE_ITEM_SMALLSHIELD || iTipoObjetoEquipado == BASE_ITEM_LARGESHIELD)
    {
        if(ObtenerIntPersistente(oPC, "CAB_MONTADO") > 0) ReaplicarEfectosPB(oPC, TRUE, TRUE, TRUE, TRUE);
        else ReaplicarEfectosPB(oPC, FALSE, TRUE, TRUE, TRUE);
    }
    //Si estamos montados no podemos equipar armaduras
    if (iTipoObjetoEquipado == 341 ||
        iTipoObjetoEquipado == 345 || iTipoObjetoEquipado == 346 ||
        iTipoObjetoEquipado == 352 || iTipoObjetoEquipado == 16 && ObtenerIntPersistente(oPC, "CAB_MONTADO") > 0)
    {
        FloatingTextStringOnCreature("<cþ<<>** No puedes equipar armaduras estando montado **</c>", oPC, FALSE);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oPC, 2.0);
        DelayCommand(1.0, AssignCommand(oPC, ClearAllActions()));
        AssignCommand(oPC, ActionUnequipItem(oObjetoEquipado));
    }

    // HABILIDADES DEL TIRADOR DE LA ESPESURA
    if(GetLevelByClass(42, oPC))
    {
        if (iTipoObjetoEquipado == BASE_ITEM_LIGHTCROSSBOW ||
            iTipoObjetoEquipado == BASE_ITEM_HEAVYCROSSBOW ||
            iTipoObjetoEquipado == BASE_ITEM_SHORTBOW ||
            iTipoObjetoEquipado == BASE_ITEM_LONGBOW)
        {
            // Proyectiles afilados
            if(GetHasFeat(1141, oPC)) IPSafeAddItemProperty(oObjetoEquipado, ItemPropertyKeen(), 999999.9, X2_IP_ADDPROP_POLICY_KEEP_EXISTING,TRUE, TRUE);

            // Critico mejorado
            if(GetHasFeat(1142, oPC))
            {
                int iTipoCritico = IP_CONST_DAMAGEBONUS_1d10;
                if(GetHasFeat(1143, oPC)) iTipoCritico = IP_CONST_DAMAGEBONUS_2d10;

                IPSafeAddItemProperty(oObjetoEquipado, ItemPropertyMassiveCritical(iTipoCritico), 999999.9, X2_IP_ADDPROP_POLICY_KEEP_EXISTING,TRUE, TRUE);
            }
        }
        else if (iTipoObjetoEquipado == BASE_ITEM_ARROW ||
                 iTipoObjetoEquipado == BASE_ITEM_BOLT)
        {
            // Punteria constante
            if(GetHasFeat(1144, oPC))
            {
                int iTipoCD = IP_CONST_ONHIT_SAVEDC_14;
                if(GetHasFeat(1146, oPC))      iTipoCD = IP_CONST_ONHIT_SAVEDC_18;
                else if(GetHasFeat(1145, oPC)) iTipoCD = IP_CONST_ONHIT_SAVEDC_16;

                IPSafeAddItemProperty(oObjetoEquipado, ItemPropertyOnHitProps(IP_CONST_ONHIT_WOUNDING, iTipoCD, IP_CONST_DAMAGETYPE_PIERCING), 999999.9, X2_IP_ADDPROP_POLICY_KEEP_EXISTING,TRUE, TRUE);
            }
        }
    }

    // OBJETOS INVISIBLES
    if(sObjetoEquipado == "uki_objinvisible")
    {
        effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_IMPROVED);
        AssignCommand(oPC, PlayAnimation(ANIMATION_FIREFORGET_STEAL,1.0));
        AssignCommand(oPC, SpeakString("<cþ<<>*Al equipártelo desaparece junto contigo*</c>"));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, oPC, 120.0);
        DestroyObject(oObjetoEquipado);
        return;
    }

    // OBJETOS MALDITOS
    if(sObjetoEquipado == "uki_objmaldito")
    {
        effect eVisual1 = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
        effect eMaldi = EffectCurse(2,0,2,0,0,0);
        SendMessageToPC(oPC, "<cþ<<>*Parece que el objeto estaba maldito, te drena tus energías al equipártelo*</c>");
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual1, oPC);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eMaldi, oPC, 300.0);
        DestroyObject(oObjetoEquipado);
        return;
    }

    // LYTHARIS Y LICANTROPOS: NO ARMADURAS PESADAS NI OBJETOS EN MANOS EN FORMA ANIMAL
    string sSubraza = GetStringLowerCase(GetSubRace(oPC));
    if((sSubraza == "lythari" || sSubraza == "licantropo") && GetAppearanceType(oPC) > 6 && ObtenerIntPersistente(oPC, "CAB_MONTADO") == 0)
    {
        if(ObtenerIntPersistente(oPC, "ESTADOLICANTROPIA") == 2)
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oPC, 2.0);
            DelayCommand(1.0, AssignCommand(oPC, ClearAllActions()));
            DelayCommand(1.1, DesequiparObjetosArmaduraTransformacionesSubrazas(oPC));
            DelayCommand(1.1, DesequiparObjetosManosTransformacionesSubrazas(oPC));
        }
    }

    // MENSAJE DE EQUIPACION DE OBJETO Y ESPERA DE EQUIPACION DE ARMADURAS
    if (GetIsDM(oPC) == FALSE &&
        GetIsDMPossessed(oPC) == FALSE)
    {
        int iTipoObjeto = GetBaseItemType(oObjetoEquipado);
        if(InvisibleTrue(oPC) == FALSE)
        {
            if(iTipoObjeto == BASE_ITEM_AMULET)      AssignCommand(oPC, ActionSpeakString("<c!}þ>*Amuleto equipado*</c>"));
            else if(iTipoObjeto == BASE_ITEM_BELT)   AssignCommand(oPC, ActionSpeakString("<c!}þ>*Cinturón equipado*</c>"));
            else if(iTipoObjeto == BASE_ITEM_BOOTS)  AssignCommand(oPC, ActionSpeakString("<c!}þ>*Botas equipadas*</c>"));
            else if(iTipoObjeto == BASE_ITEM_BRACER) AssignCommand(oPC, ActionSpeakString("<c!}þ>*Brazaletes equipados*</c>"));
            else if(iTipoObjeto == BASE_ITEM_GLOVES) AssignCommand(oPC, ActionSpeakString("<c!}þ>*Guantes equipados*</c>"));
            else if(iTipoObjeto == BASE_ITEM_HELMET) AssignCommand(oPC, ActionSpeakString("<c!}þ>*Yelmo/Capucha equipad@*</c>"));
            else if(iTipoObjeto == BASE_ITEM_RING)   AssignCommand(oPC, ActionSpeakString("<c!}þ>*Anillo equipado*</c>"));
            else if(iTipoObjeto == BASE_ITEM_CLOAK)  AssignCommand(oPC, ActionSpeakString("<c!}þ>*Capa equipada*</c>"));
        }

        if(iTipoObjeto == BASE_ITEM_ARMOR) ExecuteScript("cr_onequip",OBJECT_SELF); // Espera en equipar armaduras
    }

    // Vampiros transformados
    if(GetIsVampire(oPC)==TRUE)
    {
        if(GetAppearanceType(oPC) > 6 && ObtenerIntPersistente(oPC, "CAB_MONTADO") == 0 )
        {
            DesequiparObjetosArmaduraTransformacionesSubrazas(oPC);
            DelayCommand(2.0, DesequiparObjetosArmaduraTransformacionesSubrazas(oPC));
        }
        else
        {
            if(GetLevelByClass(CLASS_TYPE_MONK, oPC) > 0)
            {
                if(iTipoObjetoEquipado == BASE_ITEM_BRACER ||iTipoObjetoEquipado == BASE_ITEM_GLOVES)
                {
                    object oMordisco = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC);
                    if(oMordisco != OBJECT_INVALID) DestroyObject(oMordisco);
                    object oO = GetFirstItemInInventory(oPC);
                    string sS;
                    while(GetIsObjectValid(oO))
                    {
                        sS = GetTag(oO);
                        if(sS == "NW_IT_CREWPS014" || sS == "NW_IT_CREWPS033"
                        || sS == "NW_IT_CREWPS011" || sS == "NW_IT_CREWPS007"
                        || sS == "asy_mordiscovampiro") DestroyObject(oO);

                        oO = GetNextItemInInventory(oPC);
                    }

                    Vampire_Remove_Stats(oPC);
                    DelayCommand(1.0,Vampire_Apply_Stats(oPC));
                }
            }
        }
    }

    // BUCLE PROPIEDADES
    int iSlotClase, iSlotEsfera, iSlotSoloUnaVez;
    //int nDamage=0, nCount=0; No se está usando.
    itemproperty iPropiedad = GetFirstItemProperty(oObjetoEquipado);
    while(GetIsItemPropertyValid(iPropiedad))
    {
        // Resistencias a Magico y Divino se han eliminado del mod(medida temporal)
        if ((GetItemPropertyType(iPropiedad) == 20 || GetItemPropertyType(iPropiedad) == 23) &&
           (GetItemPropertySubType(iPropiedad) == 5 || GetItemPropertySubType(iPropiedad) == 8))
        {
            RemoveItemProperty(oObjetoEquipado, iPropiedad);
            SendMessageToPC(oPC, "<cþ<<>Las resistencias de daño mágico y divino se han eliminado del servidor.</c>");
        }

        // Slots de conjuros ilegales (imposibilita equiparse slots de conjuros que no llegas al nivel)
        if(GetItemPropertyType(iPropiedad) == 13 && iSlotSoloUnaVez == FALSE)
        {
            iSlotClase = GetItemPropertySubType(iPropiedad);
            iSlotEsfera = GetItemPropertyCostTableValue(iPropiedad);
            if(ObtenerPropiedadSlotValido(oPC, iSlotClase, iSlotEsfera) == FALSE && GetLevelByClass(iSlotClase, oPC) > 0) // No tiene nivel suficiente y tiene la clase que beneficia la propiedad
            {
                iSlotSoloUnaVez = TRUE;
                SendMessageToPC(oPC, "<cþ<<>No puedes equiparte el objeto '" + GetName(oObjetoEquipado) + "', tiene espacios de conjuros demasiado elevados para ti.</c>");
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oPC, 2.0);
                DelayCommand(1.0, AssignCommand(oPC, ClearAllActions()));
                DelayCommand(1.1, AssignCommand(oPC, ActionUnequipItem(oObjetoEquipado)));
            }
        }

        // Limitacion de uso: genero (mejor scripteado que el CEP)
        if(GetItemPropertyType(iPropiedad) == 150 && iSlotSoloUnaVez == FALSE)
        {
            if(GetItemPropertySubType(iPropiedad) != GetGender(oPC))
            {
                iSlotSoloUnaVez = TRUE;
                SendMessageToPC(oPC, "<cþ<<>No cumples la restricción de género del objeto.</c>");
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oPC, 2.0);
                DelayCommand(1.0, AssignCommand(oPC, ClearAllActions()));
                DelayCommand(1.1, AssignCommand(oPC, ActionUnequipItem(oObjetoEquipado)));
                }
        }

        //Comprobamos si el objeto tiene una resistencia y la reemplazamos por una inmunidad.
        if( (GetItemPropertyType(iPropiedad) == ITEM_PROPERTY_DAMAGE_RESISTANCE) && (GetItemPropertyDurationType(iPropiedad)== DURATION_TYPE_PERMANENT ) )
        {
            int iResistencia = GetItemPropertySubType(iPropiedad);
            int iCost = GetItemPropertyCostTableValue(iPropiedad);

            // Comprobamos el valor de la resistencia.
            if (iCost < 2)
            {
                IPSafeAddItemProperty(oObjetoEquipado,ItemPropertyDamageImmunity(iResistencia, IP_CONST_DAMAGEIMMUNITY_10_PERCENT),0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
                SendMessageToPC(oPC,"<cþ<<>* Este objeto tiene una resistencia al daño, que será cambiada acorde a la normativa. *</c>");
            }
            // Comprobamos el valor de la resistencia.
            else
            {
                IPSafeAddItemProperty(oObjetoEquipado,ItemPropertyDamageImmunity(iResistencia, 8),0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
                SendMessageToPC(oPC,"<cþ<<>* Este objeto tiene una resistencia al daño, que será cambiada acorde a la normativa. *</c>");
            }
            RemoveItemProperty(oObjetoEquipado, iPropiedad);
        }

        //Comprobamos si sumamos más % de inmunidad de un mismo tipo y si es así, desequipamos el objeto.
        if( (GetItemPropertyType(iPropiedad) == ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE) && (GetItemPropertyDurationType(iPropiedad)== DURATION_TYPE_PERMANENT ) )
        {
            int iResistencia = GetItemPropertySubType(iPropiedad);
            int iCost = GetItemPropertyCostTableValue(iPropiedad);

            //Siempre guardamos la variable antes de nada.
            if(iCost == 1)SetLocalInt(oObjetoEquipado,"DAMAGE_IMMUNITY_CANTIDAD"+IntToString(iResistencia),5);
            else if(iCost == 2)SetLocalInt(oObjetoEquipado,"DAMAGE_IMMUNITY_CANTIDAD"+IntToString(iResistencia),10);
            else if(iCost == 3)SetLocalInt(oObjetoEquipado,"DAMAGE_IMMUNITY_CANTIDAD"+IntToString(iResistencia),25);
            else if(iCost == 4)SetLocalInt(oObjetoEquipado,"DAMAGE_IMMUNITY_CANTIDAD"+IntToString(iResistencia),50);
            else if(iCost == 5)SetLocalInt(oObjetoEquipado,"DAMAGE_IMMUNITY_CANTIDAD"+IntToString(iResistencia),75);
            else if(iCost == 6)SetLocalInt(oObjetoEquipado,"DAMAGE_IMMUNITY_CANTIDAD"+IntToString(iResistencia),90);
            else if(iCost == 7)SetLocalInt(oObjetoEquipado,"DAMAGE_IMMUNITY_CANTIDAD"+IntToString(iResistencia),100);
            else if(iCost == 8)SetLocalInt(oObjetoEquipado,"DAMAGE_IMMUNITY_CANTIDAD"+IntToString(iResistencia),20);
            else if(iCost == 9)SetLocalInt(oObjetoEquipado,"DAMAGE_IMMUNITY_CANTIDAD"+IntToString(iResistencia),15);
            SetLocalInt(oObjetoEquipado,"DAMAGE_IMMUNITY_TIPO",iResistencia);

            //Daños físicos solo dejamos equipar si no sumamos más del 25%.
            if((iResistencia == IP_CONST_DAMAGETYPE_BLUDGEONING || iResistencia == IP_CONST_DAMAGETYPE_SLASHING || iResistencia == IP_CONST_DAMAGETYPE_PIERCING) && GetTotalDamageImmunity(oPC, iResistencia) > 25)
            {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oPC, 2.0);
                DelayCommand(1.0, AssignCommand(oPC, ClearAllActions()));
                AssignCommand(oPC, ActionUnequipItem(oObjetoEquipado));
                SendMessageToPC(oPC,"<cþ<<>* Acumulas más inmunidad al tipo de daño de la que permite la normativa del servidor. *</c>");
            }
            //Resto de daños, 75%.
            else
            {
                if(GetTotalDamageImmunity(oPC, iResistencia) > 75)
                {
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oPC, 2.0);
                    DelayCommand(1.0, AssignCommand(oPC, ClearAllActions()));
                    AssignCommand(oPC, ActionUnequipItem(oObjetoEquipado));
                    SendMessageToPC(oPC,"<cþ<<>* Acumulas más inmunidad al tipo de daño de la que permite la normativa del servidor. *</c>");
                }
            }
        }

        //nCount++;
        iPropiedad = GetNextItemProperty(oObjetoEquipado);
    }

    //Berserker Frenetico, AutoFrenesy
    if(GetLevelByClass(CLASS_TYPE_BERSERKER, oPC) > 0 )
    {
        object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
        if (oObjetoEquipado == oArmor)
        {
            ApplyAutoFrenzy(oPC, oArmor);
        }
    }

    /*//Improved Crossbow Sniper
    if(GetHasFeat(1522, oPC ))
    {
        if (iTipoObjetoEquipado == BASE_ITEM_LIGHTCROSSBOW || iTipoObjetoEquipado == BASE_ITEM_HEAVYCROSSBOW)
            SetLocalInt(oPC, "DOTE_FRANCOTIRADOR", 2);
    }

    //Dote Crossbow Sniper
    else*/ if (GetHasFeat(1521, oPC))
    {
        if (iTipoObjetoEquipado == BASE_ITEM_LIGHTCROSSBOW || iTipoObjetoEquipado == BASE_ITEM_HEAVYCROSSBOW)
            SetLocalInt(oPC, "DOTE_FRANCOTIRADOR", 1);
    }

    //VENGADORA IMPIA
    if(GetLevelByClass(CLASS_TYPE_BLACKGUARD, oPC) > 0 )
    {
        object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
        if(oObjetoEquipado == oWeapon && GetLocalInt(oObjetoEquipado, "Arma_Impia") == 1 )
        {
            IPSafeAddItemProperty(oWeapon, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_GOOD, IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGEBONUS_1d6), HoursToSeconds(9999), X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
            IPSafeAddItemProperty(oWeapon, ItemPropertyOnHitProps(IP_CONST_ONHIT_DISPELMAGIC, IP_CONST_ONHIT_SAVEDC_18), HoursToSeconds(9999), X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
            IPSafeAddItemProperty(oWeapon, ItemPropertyEnhancementBonus(5), HoursToSeconds(9999), X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
            IPSafeAddItemProperty(oWeapon, ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_16), HoursToSeconds(9999), X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
            IPSafeAddItemProperty(oWeapon, ItemPropertyVisualEffect(ITEM_VISUAL_EVIL), HoursToSeconds(9999), X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
        }
    }


    //SETS DE ARMADURAS ESPECIALES
    if (GetLocalInt(oObjetoEquipado, "Kit_Celestial") == 1    ||
        GetLocalInt(oObjetoEquipado, "Kit_Infernal") == 1    ||
        GetLocalInt(oObjetoEquipado, "Kit_Nirvana") == 1     ||
        GetLocalInt(oObjetoEquipado, "Kit_Camino") == 1      ||
        GetLocalInt(oObjetoEquipado, "Kit_Artifice") == 1    ||
        GetLocalInt(oObjetoEquipado, "Kit_Gigante") == 1     ||
        GetLocalInt(oObjetoEquipado, "Kit_VaraNegra") == 1   ||
        GetLocalInt(oObjetoEquipado, "Kit_Loco") == 1        ||
        GetLocalInt(oObjetoEquipado, "Kit_Inmortal") == 1    ||
        GetLocalInt(oObjetoEquipado, "Kit_Tierra") == 1  )
    {
        int PiezaCelestial = 0;
        int PiezaInfernal = 0;
        int PiezaNirvana = 0;
        int PiezaCamino = 0;
        int PiezaArtifice = 0;
        int PiezaGigante = 0;
        int PiezaVaraNegra = 0;
        int PiezaLoco = 0;
        int PiezaInmortal = 0;
        int PiezaTierra = 0;
        int i;

        for (i=0;i<NUM_INVENTORY_SLOTS;i++)//equipado
        {
            object oItem = GetItemInSlot(i, oPC);
            if (GetLocalInt(oItem, "Kit_Celestial") == 1 ) PiezaCelestial = PiezaCelestial + 1;
            if (GetLocalInt(oItem, "Kit_Infernal") == 1 ) PiezaInfernal = PiezaInfernal + 1;
            if (GetLocalInt(oItem, "Kit_Nirvana") == 1 ) PiezaNirvana = PiezaNirvana + 1;
            if (GetLocalInt(oItem, "Kit_Camino") == 1 ) PiezaCamino = PiezaCamino + 1;
            if (GetLocalInt(oItem, "Kit_Artifice") == 1 ) PiezaArtifice = PiezaArtifice + 1;
            if (GetLocalInt(oItem, "Kit_Gigante") == 1 ) PiezaGigante = PiezaGigante + 1;
            if (GetLocalInt(oItem, "Kit_Varanegra") == 1 ) PiezaVaraNegra = PiezaVaraNegra + 1;
            if (GetLocalInt(oItem, "Kit_Loco") == 1 ) PiezaLoco = PiezaLoco + 1;
            if (GetLocalInt(oItem, "Kit_Inmortal") == 1 ) PiezaInmortal = PiezaInmortal + 1;
            if (GetLocalInt(oItem, "Kit_Tierra") == 1 ) PiezaTierra = PiezaTierra + 1;
        }

        int Alineamiento = GetAlignmentGoodEvil(oPC);
        int Alineamiento2 = GetAlignmentLawChaos(oPC);
        int iHeal = GetCurrentHitPoints(oPC);
        int iDamage = (iHeal*25)/100;


        //Kit Celestial
        if (GetLocalInt(oObjetoEquipado, "Kit_Celestial") == 1 )
        {
            if (Alineamiento != ALIGNMENT_GOOD)
            {
                 ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oPC, 2.0);
                 AssignCommand(oPC, ClearAllActions());
                 AssignCommand(oPC, ActionUnequipItem(oObjetoEquipado));
                 ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDamage, DAMAGE_TYPE_POSITIVE), oPC);
                 ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(1232), oPC);
                 SendMessageToPC(oPC, "Al equiparte este objeto notas como te abrasa...");
            }
            else
            {
                SendMessageToPC(oPC, "Al equiparte este objeto notas como una energia positiva te envuelve...");
            }

            //Si tenemos 4 piezas equipadas...
            if (PiezaCelestial >= 4 && ObtenerIntPersistente(oPC, "Poder_activo") == 0)
            {
                FloatingTextStringOnCreature("¡Al combinar las 4 piezas celestiales su poder se hace latente!", oPC, FALSE);
                GuardarIntPersistente(oPC, "Poder_activo", 1);
                SetLocalInt(oPC, "Poder_Celestial", 1);
                ExecuteScript("pb_setpoderes", oPC);
            }
        }

        //Kit Infernal
        if (GetLocalInt(oObjetoEquipado, "Kit_Infernal") == 1 )
        {
            if (Alineamiento != ALIGNMENT_EVIL)
            {
                 ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oPC, 2.0);
                 AssignCommand(oPC, ClearAllActions());
                 AssignCommand(oPC, ActionUnequipItem(oObjetoEquipado));
                 ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDamage, DAMAGE_TYPE_NEGATIVE), oPC);
                 ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY), oPC);
                 SendMessageToPC(oPC, "Al equiparte este objeto notas como te consume...");
            }
            else
            {
                SendMessageToPC(oPC, "Al equiparte este objeto notas como una energia oscura te envuelve...");
            }

            //Si tenemos 4 piezas equipadas...
            if (PiezaInfernal >= 4 && ObtenerIntPersistente(oPC, "Poder_activo") == 0)
            {
                FloatingTextStringOnCreature("¡Al combinar las 4 piezas infernales su poder se hace latente!", oPC, FALSE);
                GuardarIntPersistente(oPC, "Poder_activo", 1);
                SetLocalInt(oPC, "Poder_Infernal", 1);
                ExecuteScript("pb_setpoderes", oPC);
            }
        }

        //Kit Nirvana
        if (GetLocalInt(oObjetoEquipado, "Kit_Nirvana") == 1 )
        {
            if (Alineamiento != ALIGNMENT_NEUTRAL)
            {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oPC, 2.0);
                AssignCommand(oPC, ClearAllActions());
                AssignCommand(oPC, ActionUnequipItem(oObjetoEquipado));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDamage, DAMAGE_TYPE_MAGICAL), oPC);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY), oPC);
                SendMessageToPC(oPC, "Al equiparte este objeto notas como te consume...");
            }
            else
            {
                //GuardarIntPersistente(oPC, "Pieza_Nirvana", PiezaNirvana +1);
                SendMessageToPC(oPC, "Al equiparte este objeto notas como una energia natural te envuelve...");
            }

            //Si tenemos 4 piezas equipadas...
            if (PiezaNirvana >= 4 && ObtenerIntPersistente(oPC, "Poder_activo") == 0)
            {
                FloatingTextStringOnCreature("¡Al combinar las 4 piezas del nirvana su poder se hace latente!", oPC, FALSE);
                GuardarIntPersistente(oPC, "Poder_activo", 1);
                SetLocalInt(oPC, "Poder_Nirvana", 1);
                ExecuteScript("pb_setpoderes", oPC);
            }
        }

        //Kit Camino Sin Fin
        if (GetLocalInt(oObjetoEquipado, "Kit_Camino") == 1 )
        {
            //GuardarIntPersistente(oPC, "Pieza_Camino", PiezaCamino +1);
            SendMessageToPC(oPC, "Al equiparte este objeto notas como una energia te envuelve...");

            //Si tenemos 4 piezas equipadas...
            if (PiezaCamino >= 4 && ObtenerIntPersistente(oPC, "Poder_activo") == 0)
            {
                FloatingTextStringOnCreature("¡Al combinar las 4 piezas del Camino sin Fin su poder se hace latente!", oPC, FALSE);
                GuardarIntPersistente(oPC, "Poder_activo", 1);
                SetLocalInt(oPC, "Poder_Camino", 1);
                ExecuteScript("pb_setpoderes", oPC);
            }

        }

        //Kit Artifice
        if (GetLocalInt(oObjetoEquipado, "Kit_Artifice") == 1 )
        {
            //GuardarIntPersistente(oPC, "Pieza_Artifice", PiezaArtifice +1);1);
            SendMessageToPC(oPC, "Al equiparte este objeto notas como una energia te envuelve...");

            //Si tenemos 4 piezas equipadas...
            if(PiezaArtifice >= 4 && ObtenerIntPersistente(oPC, "Poder_activo") == 0)
            {
                FloatingTextStringOnCreature("¡Al combinar las 4 piezas del Artifice su poder se hace latente!", oPC, FALSE);
                GuardarIntPersistente(oPC, "Poder_activo", 1);
                SetLocalInt(oPC, "Poder_Artifice", 1);
                ExecuteScript("pb_setpoderes", oPC);
            }
        }

        //Kit Gigante
        if (GetLocalInt(oObjetoEquipado, "Kit_Gigante") == 1 )
        {
            //GuardarIntPersistente(oPC, "Pieza_Gigante", PiezaGigante +1);
            SendMessageToPC(oPC, "Al equiparte este objeto notas como una energia te envuelve...");

            //Si tenemos 4 piezas equipadas...
            if(PiezaGigante >= 4 && ObtenerIntPersistente(oPC, "Poder_activo") == 0)
            {
                FloatingTextStringOnCreature("¡Al combinar las 4 piezas del Gigante su poder se hace latente!", oPC, FALSE);
                GuardarIntPersistente(oPC, "Poder_activo", 1);
                SetLocalInt(oPC, "Poder_Gigante", 1);
                ExecuteScript("pb_setpoderes", oPC);
            }
        }

        //Kit Varanegra
        if (GetLocalInt(oObjetoEquipado, "Kit_Varanegra") == 1 )
        {
            //GuardarIntPersistente(oPC, "Pieza_Varanegra", PiezaVaraNegra +1);
            SendMessageToPC(oPC, "Al equiparte este objeto notas como una energia te envuelve...");

            //Si tenemos 4 piezas equipadas...
            if (PiezaVaraNegra >= 4 && ObtenerIntPersistente(oPC, "Poder_activo") == 0)
            {
                FloatingTextStringOnCreature("¡Al combinar las 4 piezas de Vara Negra su poder se hace latente!", oPC, FALSE);
                GuardarIntPersistente(oPC, "Poder_activo", 1);
                SetLocalInt(oPC, "Poder_VaraNegra", 1);
                ExecuteScript("pb_setpoderes", oPC);
            }
        }

        //Kit Del Loco
        if (GetLocalInt(oObjetoEquipado, "Kit_Loco") == 1 )
        {
            if (Alineamiento2 != ALIGNMENT_CHAOTIC)
            {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oPC, 2.0);
                AssignCommand(oPC, ClearAllActions());
                AssignCommand(oPC, ActionUnequipItem(oObjetoEquipado));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDamage, DAMAGE_TYPE_MAGICAL), oPC);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY), oPC);
                SendMessageToPC(oPC, "Al equiparte este objeto notas como te consume...");
            }
            else
            {
                //GuardarIntPersistente(oPC, "Pieza_Loco", PiezaLoco +1);
                SendMessageToPC(oPC, "Al equiparte este objeto notas como una energia caotica te envuelve...");
            }

            //Si tenemos 4 piezas equipadas...
            if (PiezaLoco >= 4 && ObtenerIntPersistente(oPC, "Poder_activo") == 0)
            {
                FloatingTextStringOnCreature("¡Al combinar las 4 piezas del Loco su poder se hace latente!", oPC, FALSE);
                GuardarIntPersistente(oPC, "Poder_activo", 1);
                SetLocalInt(oPC, "Poder_Loco", 1);
                ExecuteScript("pb_setpoderes", oPC);
            }
        }

        //Kit Del Rey Inmortal
        if(GetLocalInt(oObjetoEquipado, "Kit_Inmortal") == 1 )
        {
            if (Alineamiento != ALIGNMENT_EVIL)
            {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oPC, 2.0);
                AssignCommand(oPC, ClearAllActions());
                AssignCommand(oPC, ActionUnequipItem(oObjetoEquipado));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDamage, DAMAGE_TYPE_NEGATIVE), oPC);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY), oPC);
                SendMessageToPC(oPC, "Al equiparte este objeto notas como te consume...");
            }
            else
            {
                //GuardarIntPersistente(oPC, "Pieza_Inmortal", PiezaInmortal +1);
                SendMessageToPC(oPC, "Al equiparte este objeto notas como una energia inmortal te envuelve...");
            }

            //Si tenemos 4 piezas equipadas...
            if (PiezaInmortal >= 4 && ObtenerIntPersistente(oPC, "Poder_activo") == 0)
            {
                FloatingTextStringOnCreature("¡Al combinar las 4 piezas del Rey Inmortal su poder se hace latente!", oPC, FALSE);
                GuardarIntPersistente(oPC, "Poder_activo", 1);
                SetLocalInt(oPC, "Poder_Inmortal", 1);
                ExecuteScript("pb_setpoderes", oPC);
            }
        }

        //Kit Deber de la Tierra
        if (GetLocalInt(oObjetoEquipado, "Kit_Tierra") == 1 )
        {
            if (Alineamiento != ALIGNMENT_NEUTRAL)
            {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oPC, 2.0);
                AssignCommand(oPC, ClearAllActions());
                AssignCommand(oPC, ActionUnequipItem(oObjetoEquipado));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDamage, DAMAGE_TYPE_MAGICAL), oPC);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY), oPC);
                SendMessageToPC(oPC, "Al equiparte este objeto notas como te consume...");
            }
            else
            {
                //GuardarIntPersistente(oPC, "Pieza_Tierra", PiezaTierra +1);
                SendMessageToPC(oPC, "Al equiparte este objeto notas como una energia natural te envuelve...");
            }

            //Si tenemos 4 piezas equipadas...
            if (PiezaTierra >= 4 && ObtenerIntPersistente(oPC, "Poder_activo") == 0)
            {
                FloatingTextStringOnCreature("¡Al combinar las 4 piezas del Deber de la Tierra su poder se hace latente!", oPC, FALSE);
                GuardarIntPersistente(oPC, "Poder_activo", 1);
                SetLocalInt(oPC, "Poder_Tierra", 1);
                ExecuteScript("pb_setpoderes", oPC);
            }
        }
    }

    //MEJORAS DE LOS OBJETOS DEL ARTIFICE
    int iNivel;
    //Mejoramos los objetos del Artillero.
    if(ObtenerIntPersistente(oPC,"CLS_ING_TIPO") == 1 && GetTag(oObjetoEquipado) == "cls_ing_item1")
    {
        if(GetLevelByClass(CLASS_TYPE_INGENIERO,oPC) >=3 && GetLevelByClass(CLASS_TYPE_INGENIERO,oPC) <5)
        {
            IPSafeAddItemProperty(oObjetoEquipado, ItemPropertyEnhancementBonus(1),0.0,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        }
        else if(GetLevelByClass(CLASS_TYPE_INGENIERO,oPC) >=5 && GetLevelByClass(CLASS_TYPE_INGENIERO,oPC) <9)
        {
            IPSafeAddItemProperty(oObjetoEquipado, ItemPropertyEnhancementBonus(3),0.0,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        }
        else if(GetLevelByClass(CLASS_TYPE_INGENIERO,oPC) >=9 && GetLevelByClass(CLASS_TYPE_INGENIERO,oPC) <13)
        {
            IPSafeAddItemProperty(oObjetoEquipado, ItemPropertyEnhancementBonus(4),0.0,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        }
        else if(GetLevelByClass(CLASS_TYPE_INGENIERO,oPC) >=13)
        {
            IPSafeAddItemProperty(oObjetoEquipado, ItemPropertyEnhancementBonus(5),0.0,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        }
    }
    //Mejoramos los objetos del Armero.
    if(ObtenerIntPersistente(oPC,"CLS_ING_TIPO") == 2 && GetTag(oObjetoEquipado) == "cls_ing_item2")
    {
        if(GetLevelByClass(CLASS_TYPE_INGENIERO,oPC) >=3 && GetLevelByClass(CLASS_TYPE_INGENIERO,oPC) <5)
        {
            IPSafeAddItemProperty(oObjetoEquipado, ItemPropertyACBonus(1),0.0,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        }
        else if(GetLevelByClass(CLASS_TYPE_INGENIERO,oPC) >=5 && GetLevelByClass(CLASS_TYPE_INGENIERO,oPC) <9)
        {
            IPSafeAddItemProperty(oObjetoEquipado, ItemPropertyACBonus(2),0.0,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        }
        else if(GetLevelByClass(CLASS_TYPE_INGENIERO,oPC) >=9 && GetLevelByClass(CLASS_TYPE_INGENIERO,oPC) <13)
        {
            IPSafeAddItemProperty(oObjetoEquipado, ItemPropertyACBonus(3),0.0,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        }
        else if(GetLevelByClass(CLASS_TYPE_INGENIERO,oPC) >=13 && GetLevelByClass(CLASS_TYPE_INGENIERO,oPC) <17)
        {
            IPSafeAddItemProperty(oObjetoEquipado, ItemPropertyACBonus(4),0.0,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        }
        else if(GetLevelByClass(CLASS_TYPE_INGENIERO,oPC) >=17)
        {
            IPSafeAddItemProperty(oObjetoEquipado, ItemPropertyACBonus(5),0.0,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        }
    }
    //Mejoramos los objetos del Alquimista.
    if(ObtenerIntPersistente(oPC,"CLS_ING_TIPO") == 4 && GetTag(oObjetoEquipado) == "cls_ing_item4")
    {
        //Le borramos siempre todas las propiedades, ya que se las ponemos al equipárselo.
        IPRemoveAllItemProperties(oObjetoEquipado, DURATION_TYPE_PERMANENT);
        //Le ponemos value decrease.
        IPSafeAddItemProperty(oObjetoEquipado, ItemPropertyCustom(155, -1, 50),0.0,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        //Apartado de CAs.
        if(GetLevelByClass(CLASS_TYPE_INGENIERO,oPC) >=3 && GetLevelByClass(CLASS_TYPE_INGENIERO,oPC) <5)
        {
            IPSafeAddItemProperty(oObjetoEquipado, ItemPropertyACBonus(1),0.0,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        }
        else if(GetLevelByClass(CLASS_TYPE_INGENIERO,oPC) >=5 && GetLevelByClass(CLASS_TYPE_INGENIERO,oPC) <9)
        {
            IPSafeAddItemProperty(oObjetoEquipado, ItemPropertyACBonus(2),0.0,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        }
        else if(GetLevelByClass(CLASS_TYPE_INGENIERO,oPC) >=9 && GetLevelByClass(CLASS_TYPE_INGENIERO,oPC) <13)
        {
            IPSafeAddItemProperty(oObjetoEquipado, ItemPropertyACBonus(3),0.0,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        }
        else if(GetLevelByClass(CLASS_TYPE_INGENIERO,oPC) >=13 && GetLevelByClass(CLASS_TYPE_INGENIERO,oPC) <17)
        {
            IPSafeAddItemProperty(oObjetoEquipado, ItemPropertyACBonus(4),0.0,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        }
        else if(GetLevelByClass(CLASS_TYPE_INGENIERO,oPC) >=17)
        {
            IPSafeAddItemProperty(oObjetoEquipado, ItemPropertyACBonus(5),0.0,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
        }
        //Apartado de huecos de conjuros.
        //Evitamos posibles abusos.
        if(GetLevelByClass(CLASS_TYPE_INGENIERO,oPC) >=1) //Nivel 1, el ingeniero gana trucos.
        {
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusLevelSpell(CLASS_TYPE_INGENIERO, 0), oObjetoEquipado);
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusLevelSpell(CLASS_TYPE_INGENIERO, 0), oObjetoEquipado);
            iNivel = 1;
        }
        if(GetLevelByClass(CLASS_TYPE_INGENIERO,oPC) >=2) //Nivel 2, el ingeniero gana trucos y esfera 1.
        {
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusLevelSpell(CLASS_TYPE_INGENIERO, 1), oObjetoEquipado);
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusLevelSpell(CLASS_TYPE_INGENIERO, 1), oObjetoEquipado);
            iNivel = 2;
        }
        if(GetLevelByClass(CLASS_TYPE_INGENIERO,oPC) >=6) //Nivel 6, el ingeniero gana trucos y esferas 1, 2.
        {

            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusLevelSpell(CLASS_TYPE_INGENIERO, 2), oObjetoEquipado);
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusLevelSpell(CLASS_TYPE_INGENIERO, 2), oObjetoEquipado);
            iNivel = 6;
        }
        if(GetLevelByClass(CLASS_TYPE_INGENIERO,oPC) >=9) //Nivel 9, el ingeniero gana trucos y esferas 1, 2, 3.
        {
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusLevelSpell(CLASS_TYPE_INGENIERO, 3), oObjetoEquipado);
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusLevelSpell(CLASS_TYPE_INGENIERO, 3), oObjetoEquipado);
            iNivel = 9;
        }
        if(GetLevelByClass(CLASS_TYPE_INGENIERO,oPC) >=12) //Nivel 12, el ingeniero gana trucos y esferas 1, 2, 3, 4.
        {
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusLevelSpell(CLASS_TYPE_INGENIERO, 4), oObjetoEquipado);
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusLevelSpell(CLASS_TYPE_INGENIERO, 4), oObjetoEquipado);
            iNivel = 12;
        }
        if(GetLevelByClass(CLASS_TYPE_INGENIERO,oPC) >=15) //Nivel 14, el ingeniero gana trucos y esferas 1, 2, 3, 4, 5.
        {
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusLevelSpell(CLASS_TYPE_INGENIERO, 5), oObjetoEquipado);
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusLevelSpell(CLASS_TYPE_INGENIERO, 5), oObjetoEquipado);
            iNivel = 15;
        }
        if(GetLevelByClass(CLASS_TYPE_INGENIERO,oPC) >=18) //Nivel 14, el ingeniero gana trucos y esferas 1, 2, 3, 4, 5, 6.
        {
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusLevelSpell(CLASS_TYPE_INGENIERO, 6), oObjetoEquipado);
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusLevelSpell(CLASS_TYPE_INGENIERO, 6), oObjetoEquipado);
            iNivel = 18;
        }
        SetLocalInt(oObjetoEquipado,"NivelAlquimista",iNivel);

        //Desequipamos el item del Alquimista, para evitar bugs, si el nivel que corresponde no es el que debe.
        if(GetLevelByClass(CLASS_TYPE_INGENIERO,oPC) < GetLocalInt(oObjetoEquipado,"NivelAlquimista"))
        {
            DestroyObject(oObjetoEquipado); //Destruimos el ITEM desfasado.
            CreateItemOnObject("cls_ing_item4", oPC); //Le volvemos a dar un cinturón básico, que al equipar, se volverá a setear solo.
        }
    }

    // SISTEMA DE EFECTOS PERSISTENTES
    OnEquipItemCheckIfHelmAndRemoveDMVFX(oPC, oObjetoEquipado);
}
