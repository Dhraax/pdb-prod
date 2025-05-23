//Script Dotes Pasivas PdB//

#include "x2_inc_itemprop"
#include "mti_libreria"
#include "pb_constantes"

void RemoveAutoFrenzy(object oPC, object oArmor)
{
     IPRemoveMatchingItemProperties(oArmor, ITEM_PROPERTY_ONHITCASTSPELL, DURATION_TYPE_TEMPORARY, -1 );
}

void ApplyAutoFrenzy(object oPC, object oArmor)
{
     IPSafeAddItemProperty(oArmor, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 999999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
}

void main()
{
  object oPC = OBJECT_SELF;

    //Efectos
    // effect eDureza = SupernaturalEffect(EffectTemporaryHitpoints(GetHitDice(oPC)));
    effect eDadiva = SupernaturalEffect(EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_SPELL));
    effect eAsombrosa = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK));
    effect eAC1 = SupernaturalEffect(EffectACIncrease(1, AC_DODGE_BONUS));
    effect eAC2 = SupernaturalEffect(EffectACIncrease(2, AC_DODGE_BONUS));
    effect eAC3 = SupernaturalEffect(EffectACIncrease(3, AC_DODGE_BONUS));
    effect eAC4 = SupernaturalEffect(EffectACIncrease(4, AC_DODGE_BONUS));
    effect eBrujoUOM = SupernaturalEffect(EffectSkillIncrease(SKILL_USE_MAGIC_DEVICE, 6));
    effect eResistFire = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_FIRE, 5, 0));
    effect eResistCold = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_COLD, 5, 0));
    effect eResistAcid = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_ACID, 5, 0));
    effect eResistElec = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 5, 0));
    effect eResistSonic = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_SONIC, 5, 0));
    effect eResistFire10 = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_FIRE, 10, 0));
    effect eResistCold10 = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_COLD, 10, 0));
    effect eResistAcid10 = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_ACID, 10, 0));
    effect eResistElec10 = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 10, 0));
    effect eResistSonic10 = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_SONIC, 10, 0));
    effect eRDBrujo = SupernaturalEffect(EffectDamageReduction(1, DAMAGE_POWER_PLUS_TWENTY));
    effect eRD2Brujo = SupernaturalEffect(EffectDamageReduction(2, DAMAGE_POWER_PLUS_TWENTY));
    effect eRD3Brujo = SupernaturalEffect(EffectDamageReduction(3, DAMAGE_POWER_PLUS_TWENTY));
    effect eRD4Brujo = SupernaturalEffect(EffectDamageReduction(4, DAMAGE_POWER_PLUS_TWENTY));
    effect eRD5Brujo = SupernaturalEffect(EffectDamageReduction(5, DAMAGE_POWER_PLUS_TWENTY));
    effect eRD1Mas = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, 1, 0));
           eRD1Mas = SupernaturalEffect(EffectLinkEffects(eRD1Mas, EffectDamageResistance(DAMAGE_TYPE_PIERCING, 1, 0)));
           eRD1Mas = SupernaturalEffect(EffectLinkEffects(eRD1Mas, EffectDamageResistance(DAMAGE_TYPE_SLASHING, 1, 0)));
           eRD1Mas = SupernaturalEffect(EffectLinkEffects(eRD1Mas, EffectDamageResistance(DAMAGE_TYPE_ACID, 1, 0)));
           eRD1Mas = SupernaturalEffect(EffectLinkEffects(eRD1Mas, EffectDamageResistance(DAMAGE_TYPE_COLD, 1, 0)));
           eRD1Mas = SupernaturalEffect(EffectLinkEffects(eRD1Mas, EffectDamageResistance(DAMAGE_TYPE_DIVINE, 1, 0)));
           eRD1Mas = SupernaturalEffect(EffectLinkEffects(eRD1Mas, EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 1, 0)));
           eRD1Mas = SupernaturalEffect(EffectLinkEffects(eRD1Mas, EffectDamageResistance(DAMAGE_TYPE_FIRE, 1, 0)));
           eRD1Mas = SupernaturalEffect(EffectLinkEffects(eRD1Mas, EffectDamageResistance(DAMAGE_TYPE_MAGICAL, 1, 0)));
           eRD1Mas = SupernaturalEffect(EffectLinkEffects(eRD1Mas, EffectDamageResistance(DAMAGE_TYPE_NEGATIVE, 1, 0)));
           eRD1Mas = SupernaturalEffect(EffectLinkEffects(eRD1Mas, EffectDamageResistance(DAMAGE_TYPE_POSITIVE, 1, 0)));
           eRD1Mas = SupernaturalEffect(EffectLinkEffects(eRD1Mas, EffectDamageResistance(DAMAGE_TYPE_SONIC, 1, 0)));
    effect eRegeneracion1 = SupernaturalEffect(EffectRegenerate(1, 6.0));
    effect eRegeneracion2 = SupernaturalEffect(EffectRegenerate(2, 6.0));
    effect eRegeneracion5 = SupernaturalEffect(EffectRegenerate(5, 6.0));
    effect eImmuReduccionCaracteristica = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE));
    effect eArtiArtesania2 = SupernaturalEffect(EffectSkillIncrease(SKILL_CRAFT_TRAP, 2));
        effect eArtiArtesania4 = SupernaturalEffect(EffectSkillIncrease(SKILL_CRAFT_TRAP, 4));
        effect eArtiArtesania6 = SupernaturalEffect(EffectSkillIncrease(SKILL_CRAFT_TRAP, 6));
        effect eArtiArtesania8 = SupernaturalEffect(EffectSkillIncrease(SKILL_CRAFT_TRAP, 8));
        effect eArtiArtesania10 = SupernaturalEffect(EffectSkillIncrease(SKILL_CRAFT_TRAP, 10));
    effect eArtiInutiliza2 = SupernaturalEffect(EffectSkillIncrease(SKILL_DISABLE_TRAP, 2));
        effect eArtiInutiliza4 = SupernaturalEffect(EffectSkillIncrease(SKILL_DISABLE_TRAP, 4));
        effect eArtiInutiliza6 = SupernaturalEffect(EffectSkillIncrease(SKILL_DISABLE_TRAP, 6));
        effect eArtiInutiliza8 = SupernaturalEffect(EffectSkillIncrease(SKILL_DISABLE_TRAP, 8));
        effect eArtiInutiliza10 = SupernaturalEffect(EffectSkillIncrease(SKILL_DISABLE_TRAP, 10));
    effect eArtiUOM4 = SupernaturalEffect(EffectSkillIncrease(SKILL_USE_MAGIC_DEVICE, 4));
        effect eArtiUOM8 = SupernaturalEffect(EffectSkillIncrease(SKILL_USE_MAGIC_DEVICE, 8));

    //Bonificadores de habilidad del ingeniero.
    if(GetLevelByClass(CLASS_TYPE_INGENIERO, oPC) >= 20)
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eArtiUOM8, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eArtiInutiliza10, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eArtiArtesania10, oPC);
    }
    else if(GetLevelByClass(CLASS_TYPE_INGENIERO, oPC) >= 18 && GetLevelByClass(CLASS_TYPE_INGENIERO, oPC) < 20)
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eArtiUOM8, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eArtiInutiliza8, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eArtiArtesania8, oPC);
    }
    else if(GetLevelByClass(CLASS_TYPE_INGENIERO, oPC) >= 16 && GetLevelByClass(CLASS_TYPE_INGENIERO, oPC) < 18)
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eArtiUOM4, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eArtiInutiliza8, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eArtiArtesania8, oPC);
    }
    else if(GetLevelByClass(CLASS_TYPE_INGENIERO, oPC) >= 14 && GetLevelByClass(CLASS_TYPE_INGENIERO, oPC) < 16)
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eArtiUOM4, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eArtiInutiliza6, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eArtiArtesania6, oPC);
    }
    else if(GetLevelByClass(CLASS_TYPE_INGENIERO, oPC) >= 12 && GetLevelByClass(CLASS_TYPE_INGENIERO, oPC) < 14)
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eArtiInutiliza6, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eArtiArtesania6, oPC);
    }
    else if(GetLevelByClass(CLASS_TYPE_INGENIERO, oPC) >= 8 && GetLevelByClass(CLASS_TYPE_INGENIERO, oPC) < 12)
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eArtiInutiliza4, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eArtiArtesania4, oPC);
    }
    else if(GetLevelByClass(CLASS_TYPE_INGENIERO, oPC) >= 4 && GetLevelByClass(CLASS_TYPE_INGENIERO, oPC) < 8)
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eArtiInutiliza2, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eArtiArtesania2, oPC);
    }

    //Dotes
    if(GetHasFeat(1327, oPC)) { ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAsombrosa, oPC); } // Esquiva Asombrosa Mejorada
    //if(GetHasFeat(1437, oPC)) { ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDureza, oPC); } // Dureza Mejorada
    if(GetHasFeat(1438, oPC)) { ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRD1Mas, oPC); } // Resistencia Mayor
    if(GetHasFeat(1434, oPC)) { ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDadiva, oPC); } // Davida de Mystra

    //DOTES SOLDADO DE LA LUZ: APLICAR AJUSTE DE REGENERACION

    if (GetHasFeat(1390, oPC))
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRegeneracion2, oPC);
        RemoveEffect(oPC,eRegeneracion1);
    }
    else if (GetHasFeat(1389, oPC))
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRegeneracion1, oPC);
    }

    //Bonificador CA enano Defensor
    if(GetLevelByClass(36, oPC) >= 10 ) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC4, oPC);
    else if(GetLevelByClass(36, oPC) >= 8 && GetLevelByClass(36, oPC) < 10 ) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC3, oPC);
    else if(GetLevelByClass(36, oPC) >= 4 && GetLevelByClass(36, oPC) < 8 ) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC2, oPC);
    else if(GetLevelByClass(36, oPC) > 0 && GetLevelByClass(36, oPC) < 4 ) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC1, oPC);

    //Conocimiento de Leyendas Agente Custodio
    effect eConocimiento = SupernaturalEffect(EffectSkillIncrease(SKILL_LORE , GetLevelByClass(54, oPC)));
    if(GetLevelByClass(54, oPC) > 0 ) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eConocimiento, oPC);


    //Berserker Frenetico, AutoFrenesy
    if(GetLevelByClass(56, oPC) > 0 )
    {
        object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
        RemoveAutoFrenzy(oPC, oArmor);
        ApplyAutoFrenzy(oPC, oArmor);
    }

    //BRUJO ARCANO

    /*/Resistencia daño
    if(GetLevelByClass(57, oPC) >= 19 ) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRD5Brujo, oPC);
    else if(GetLevelByClass(57, oPC) >= 15 && GetLevelByClass(57, oPC) < 19 ) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRD4Brujo, oPC);
    else if(GetLevelByClass(57, oPC) >= 11 && GetLevelByClass(57, oPC) < 15 ) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRD3Brujo, oPC);
    else if(GetLevelByClass(57, oPC) >= 7 && GetLevelByClass(57, oPC) < 11 ) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRD2Brujo, oPC);
    else if(GetLevelByClass(57, oPC) >= 3 && GetLevelByClass(57, oPC) < 7 ) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRDBrujo, oPC); */

    //Resistencia elemental
    if(GetLevelByClass(57, oPC) >= 20 )
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eResistFire10, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eResistCold10, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eResistAcid10, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eResistElec10, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eResistSonic10, oPC);
    }
    else if(GetLevelByClass(57, oPC) >= 10 && GetLevelByClass(57, oPC) < 20 )
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eResistFire, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eResistCold, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eResistAcid, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eResistElec, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eResistSonic, oPC);
    }

    //Usar UOM Brujo
    if(GetHasFeat(1469, oPC)) { ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBrujoUOM, oPC); }

    //Regeneración Infernal
    if(GetLevelByClass(57, oPC) >= 18 ) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRegeneracion5, oPC);
    else if(GetLevelByClass(57, oPC) >= 13 && GetLevelByClass(57, oPC) < 18 ) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRegeneracion2, oPC);
    else if(GetLevelByClass(57, oPC) >= 8 && GetLevelByClass(57, oPC) < 13 ) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRegeneracion1, oPC);

    //Brujo Parangon Visionario
    effect eUltra = SupernaturalEffect(EffectUltravision());
    effect eSee = SupernaturalEffect(EffectSeeInvisible());
    effect eAbsorb = SupernaturalEffect(EffectSpellLevelAbsorption(9, 0, SPELL_SCHOOL_ILLUSION));
    if(GetHasFeat(1515, oPC))
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eUltra, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSee, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAbsorb, oPC);
    }

   //ESPADACHIN
    object oArmadura = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    int iTipoArmadura = GetArmorType(oArmadura);
    effect eDamageINT;

    if(iTipoArmadura <= 3 && GetLevelByClass(58, oPC) > 0) //Solo con armadura ligera y Espadachin
    {
        //Bonificador CA Espadachin
        if(GetLevelByClass(58, oPC) >= 20 ) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC4, oPC);
        else if(GetLevelByClass(58, oPC) >= 15 && GetLevelByClass(58, oPC) < 20 ) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC3, oPC);
        else if(GetLevelByClass(58, oPC) >= 10 && GetLevelByClass(58, oPC) < 15 ) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC2, oPC);
        else if(GetLevelByClass(58, oPC) >= 5 && GetLevelByClass(58, oPC) < 10 ) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC1, oPC);

        //Bonificador Espadachin **Gracia
        effect eReflejos3 = SupernaturalEffect(EffectSavingThrowIncrease(SAVING_THROW_REFLEX, 3, SAVING_THROW_TYPE_NONE));
        effect eReflejos2 = SupernaturalEffect(EffectSavingThrowIncrease(SAVING_THROW_REFLEX, 2, SAVING_THROW_TYPE_NONE));
        effect eReflejos1 = SupernaturalEffect(EffectSavingThrowIncrease(SAVING_THROW_REFLEX, 1, SAVING_THROW_TYPE_NONE));
        if(GetLevelByClass(58, oPC) >= 20 ) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eReflejos3, oPC);
        else if(GetLevelByClass(58, oPC) >= 11 && GetLevelByClass(58, oPC) < 20 ) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eReflejos2, oPC);
        else if(GetLevelByClass(58, oPC) >= 2 && GetLevelByClass(58, oPC) < 11 ) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eReflejos1, oPC);


        //Maestria Habilidad Acrobacia
        effect eSaltos = SupernaturalEffect(EffectSkillIncrease(21, 6));
        effect ePiruetas = SupernaturalEffect(EffectSkillIncrease(26, 6));
        effect eSaltosPiruetas = SupernaturalEffect(EffectLinkEffects(eSaltos, ePiruetas));
        if(GetHasFeat(1511, oPC)) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSaltosPiruetas, oPC);
    }

    //Solturas en una Habilidad
    effect eAveriguarIntenciones = SupernaturalEffect(EffectSkillIncrease(28, 3));
    effect eDescifrarEscritura = SupernaturalEffect(EffectSkillIncrease(29, 3));
    effect eDisfrazarse = SupernaturalEffect(EffectSkillIncrease(30, 3));
    effect eEquilibrio = SupernaturalEffect(EffectSkillIncrease(31, 3));
    effect eEscapismo = SupernaturalEffect(EffectSkillIncrease(32, 3));
    effect eFalsificar = SupernaturalEffect(EffectSkillIncrease(33, 3));
    effect eHablarIdioma = SupernaturalEffect(EffectSkillIncrease(34, 3));
    effect eReunirInfo = SupernaturalEffect(EffectSkillIncrease(35, 3));
    effect eSupervivencia = SupernaturalEffect(EffectSkillIncrease(36, 3));
    effect eTrepar = SupernaturalEffect(EffectSkillIncrease(37, 3));
    effect eUsoCuerdas = SupernaturalEffect(EffectSkillIncrease(38, 3));
    if(GetHasFeat(1222, oPC)) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAveriguarIntenciones, oPC);
    if(GetHasFeat(1224, oPC)) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDescifrarEscritura, oPC);
    if(GetHasFeat(1225, oPC)) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDisfrazarse, oPC);
    if(GetHasFeat(1227, oPC)) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEquilibrio, oPC);
    if(GetHasFeat(1228, oPC)) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEscapismo, oPC);
    if(GetHasFeat(1232, oPC)) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFalsificar, oPC);
    if(GetHasFeat(1233, oPC)) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eHablarIdioma, oPC);
    if(GetHasFeat(1234, oPC)) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eReunirInfo, oPC);
    if(GetHasFeat(1235, oPC)) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSupervivencia, oPC);
    if(GetHasFeat(1236, oPC)) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eTrepar, oPC);
    if(GetHasFeat(1237, oPC)) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eUsoCuerdas, oPC);

    //Indicar que ya se le ha dado los efectos.
    GuardarIntPersistente(oPC, "bSubRaza", 1);
}


