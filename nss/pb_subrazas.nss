//::///////////////////////////////////////////////
//:: EFECTOS DE SUBRAZAS
//:: Copyright (c) www.puertadebaldur.net
//:://////////////////////////////////////////////
/*
    Regula los efectos de las subrazas
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 27/03/2012
//:://////////////////////////////////////////////

#include "mti_libreria"
#include "NW_I0_SPELLS"
#include "nwnx_creature"
#include "pb_constantes"

void main()
{
    object oPC = OBJECT_SELF;

    // Habilidades
    effect eEsconderseMenos4 = SupernaturalEffect(EffectSkillDecrease(SKILL_HIDE, 4));
    effect eEnganyar2 = SupernaturalEffect(EffectSkillIncrease(SKILL_BLUFF, 2));
    effect eEsconderse2 = SupernaturalEffect(EffectSkillIncrease(SKILL_HIDE, 2));
    effect eEsconderse4 = SupernaturalEffect(EffectSkillIncrease(SKILL_HIDE, 4));
    effect eEsconderse6 = SupernaturalEffect(EffectSkillIncrease(SKILL_HIDE, 6));
    effect eEsconderse8 = SupernaturalEffect(EffectSkillIncrease(SKILL_HIDE, 8));
    effect eMoverse2 = SupernaturalEffect(EffectSkillIncrease(SKILL_MOVE_SILENTLY, 2));
    effect eMoverse4 = SupernaturalEffect(EffectSkillIncrease(SKILL_MOVE_SILENTLY, 4));
    effect eMoverse8 = SupernaturalEffect(EffectSkillIncrease(SKILL_MOVE_SILENTLY, 8));
    effect eAvistar1 = SupernaturalEffect(EffectSkillIncrease(SKILL_SPOT, 1));
    effect eAvistar2 = SupernaturalEffect(EffectSkillIncrease(SKILL_SPOT, 2));
    effect eAvistar4 = SupernaturalEffect(EffectSkillIncrease(SKILL_SPOT, 4));
    effect eAvistar8 = SupernaturalEffect(EffectSkillIncrease(SKILL_SPOT, 8));
    effect eBuscar2 = SupernaturalEffect(EffectSkillIncrease(SKILL_SEARCH, 2));
    effect eBuscar4 = SupernaturalEffect(EffectSkillIncrease(SKILL_SEARCH, 4));
    effect eBuscar8 = SupernaturalEffect(EffectSkillIncrease(SKILL_SEARCH, 8));
    effect eEscuchar1 = SupernaturalEffect(EffectSkillIncrease(SKILL_LISTEN, 1));
    effect eEscuchar2 = SupernaturalEffect(EffectSkillIncrease(SKILL_LISTEN, 2));
    effect eEscuchar4 = SupernaturalEffect(EffectSkillIncrease(SKILL_LISTEN, 4));
    effect eEscuchar8 = SupernaturalEffect(EffectSkillIncrease(SKILL_LISTEN, 8));
    effect ePiruetas4 = SupernaturalEffect(EffectSkillIncrease(SKILL_TUMBLE, 4));
    effect eTasacion2 = SupernaturalEffect(EffectSkillIncrease(SKILL_APPRAISE, 2));
    effect eArtesania2 = SupernaturalEffect(EffectSkillIncrease(22, 2));
    effect eSaltar4 = SupernaturalEffect(EffectSkillIncrease(26, 4));
    effect eSupervivencia2 = SupernaturalEffect(EffectSkillIncrease(36, 2));
    effect eAveriguarIntenciones8 = SupernaturalEffect(EffectSkillIncrease(28, 8));

    // Immunidades muertos vivientes
    effect eImmuGolpesCriticos = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT));
    effect eImmuMagiaMuerte = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_DEATH));
    effect eImmuEnfermedad = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_DISEASE));
    effect eImmuNivelNegativo = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL));
    effect eImmuReduccionCaracteristica = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE));
    effect eImmuConjurosEnajenadores = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS));
    effect eImmuParalisis = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_PARALYSIS));
    effect eImmuVeneno = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_POISON));
    effect eImmuAtaqueFurtivo = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK));

    // Salvaciones
    effect eFortaleza2 =SupernaturalEffect(EffectSavingThrowIncrease(SAVING_THROW_FORT, 2));
    effect eReflejos2 =SupernaturalEffect(EffectSavingThrowIncrease(SAVING_THROW_REFLEX, 2));
    effect eUnoVoluntadConjuros = SupernaturalEffect(EffectSavingThrowIncrease(SAVING_THROW_WILL,1,SAVING_THROW_TYPE_SPELL));
    effect eDosVoluntadConjuros = SupernaturalEffect(EffectSavingThrowIncrease(SAVING_THROW_WILL,2,SAVING_THROW_TYPE_SPELL));
    effect eUnoVoluntadEnajenadores = SupernaturalEffect(EffectSavingThrowIncrease(SAVING_THROW_WILL,1,SAVING_THROW_TYPE_MIND_SPELLS));
    effect eDosVoluntadEnajenadores = SupernaturalEffect(EffectSavingThrowIncrease(SAVING_THROW_WILL,2,SAVING_THROW_TYPE_MIND_SPELLS));

    // Resistir 5
    effect eRD5Mas1 = SupernaturalEffect(EffectDamageReduction(5, DAMAGE_POWER_PLUS_ONE));
    effect eCincoFrio = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_COLD,5,0));
    effect eCincoAcid = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_ACID,5,0));
    effect eCincoElec = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL,5,0));
    effect eCincoFueg = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_FIRE,5,0));
    effect eRD5Mas3 = SupernaturalEffect(EffectDamageReduction(5, DAMAGE_POWER_PLUS_THREE));

    // Resistir 10
    effect eRD10Mas1 = SupernaturalEffect(EffectDamageReduction(10, DAMAGE_POWER_PLUS_ONE));
    effect eDiezFrio = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_COLD,10,0));
    effect eDiezAcid = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_ACID,10,0));
    effect eDiezElec = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL,10,0));
    effect eDiezFueg = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_FIRE,10,0));

    // Resistir 15
    effect eRD15Mas1 = SupernaturalEffect(EffectDamageReduction(15, DAMAGE_POWER_PLUS_ONE));
    effect eQuinceNeg = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_NEGATIVE,15,0));
    effect eQuinceCon = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING,15,0));

    // CA
    effect eMasUnoCAArmadura =    SupernaturalEffect(EffectACIncrease(1, AC_NATURAL_BONUS));
    effect eMasDosCAArmadura =    SupernaturalEffect(EffectACIncrease(2, AC_NATURAL_BONUS));
    effect eMasTresCAArmadura =   SupernaturalEffect(EffectACIncrease(3, AC_NATURAL_BONUS));
    effect eMasCuatroCAArmadura = SupernaturalEffect(EffectACIncrease(4, AC_NATURAL_BONUS));
    effect eMasCincoCAArmadura =  SupernaturalEffect(EffectACIncrease(5, AC_NATURAL_BONUS));

    // Varios
    effect ePielHielo = SupernaturalEffect(EffectVisualEffect(VFX_DUR_ICESKIN));
    effect eDanyo1d10 = SupernaturalEffect(EffectDamageIncrease(DAMAGE_BONUS_1d10, DAMAGE_TYPE_SLASHING));
    effect eRegeneracion1 = SupernaturalEffect(EffectRegenerate(1, 6.0));
    effect eRegeneracion2 = SupernaturalEffect(EffectRegenerate(2, 6.0));
    effect eRegeneracion5 = SupernaturalEffect(EffectRegenerate(5, 6.0));
    effect eResistenciaMagica19 = SupernaturalEffect(EffectSpellResistanceIncrease(19));
    effect eMasDosDmgUmbra = SupernaturalEffect(EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_NEGATIVE));
    effect eDmgLich = SupernaturalEffect(EffectDamageIncrease(DAMAGE_BONUS_8, DAMAGE_TYPE_NEGATIVE));
    effect eNeg8 = SupernaturalEffect(EffectDamageIncrease(DAMAGE_BONUS_1d8, DAMAGE_TYPE_NEGATIVE));
    effect eMasDosAtaque = SupernaturalEffect(EffectAttackIncrease(2));
    effect eMenosUnoAtaque = SupernaturalEffect(EffectAttackDecrease(1));
    effect eUltravision = SupernaturalEffect(EffectVisualEffect(244));
    effect eImmuFrio = SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 100));
    effect eImmuElectrico = SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, 100));
    effect eResistenciaMagicaDrowSvirf = SupernaturalEffect(EffectSpellResistanceIncrease(11 + GetHitDice(oPC)));
    effect eResistenciaMagicaSemis = SupernaturalEffect(EffectSpellResistanceIncrease(10 + GetHitDice(oPC)));
    effect eResistenciaMagicaSemidrow = SupernaturalEffect(EffectSpellResistanceIncrease(GetHitDice(oPC)));
    effect eResistenciaMagicaGithzerai = SupernaturalEffect(EffectSpellResistanceIncrease(5 + GetHitDice(oPC)));
    effect eVelocidadAnimal = SupernaturalEffect(EffectMovementSpeedIncrease(35));
    effect eVelocidadTamanyoGrande = SupernaturalEffect(EffectMovementSpeedIncrease(25));
    effect eVelocidadUmbra = SupernaturalEffect(EffectMovementSpeedIncrease(20));
    effect eVelocidadFata = SupernaturalEffect(EffectMovementSpeedIncrease(10));
    effect eMasDosSalvaciones = SupernaturalEffect(EffectSavingThrowIncrease(SAVING_THROW_ALL,2));
    effect eMasCuatroSalvaciones = SupernaturalEffect(EffectSavingThrowIncrease(SAVING_THROW_ALL,4));
    effect eImmunidadAsesinoFantasmal = SupernaturalEffect(EffectSpellImmunity(SPELL_PHANTASMAL_KILLER));
    effect eImmunidadNemesisInexorable = SupernaturalEffect(EffectSpellImmunity(SPELL_WEIRD));
    effect eImmunudadexpulsion = SupernaturalEffect(EffectSpellImmunity(SPELLABILITY_TURN_UNDEAD));
    effect eImmunudadexpulsion2 = SupernaturalEffect(EffectTurnResistanceIncrease(4));
    effect eResistencia4Veneno = SupernaturalEffect(EffectSavingThrowIncrease(SAVING_THROW_FORT,4,SAVING_THROW_TYPE_POISON));

    // Genasies
    int iBonoElemento = GetHitDice(oPC)/5;
    if(iBonoElemento <= 0) iBonoElemento = 1;
    effect eBonoGenasiAgua   = EffectSavingThrowIncrease(SAVING_THROW_ALL, iBonoElemento, SAVING_THROW_TYPE_COLD);
    effect eBonoGenasiAire   = EffectSavingThrowIncrease(SAVING_THROW_ALL, iBonoElemento, SAVING_THROW_TYPE_ELECTRICITY);
    effect eBonoGenasiFuego  = EffectSavingThrowIncrease(SAVING_THROW_ALL, iBonoElemento, SAVING_THROW_TYPE_FIRE);
    effect eBonoGenasiTierra = EffectSavingThrowIncrease(SAVING_THROW_ALL, iBonoElemento, SAVING_THROW_TYPE_ACID);

    string sSubraza = GetStringLowerCase(GetSubRace(oPC));
    int iRaza = GetRacialType(oPC);
    int iDrowSuperficie = ObtenerIntPersistente(oPC, "DROWSUPERFICIE");
    int iSemidrowSuperficie = ObtenerIntPersistente(oPC, "SEMIDROWSUPERFICIE");
    int iDrowTamano = ObtenerIntPersistente(oPC, "DROWTAMANO");
    // 0. Ceguera Antipoda Oscura
    if(GetLocalInt(oPC, "CEGUERA_AO"))
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectAttackDecrease(1)), oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSkillDecrease(SKILL_ALL_SKILLS,1)), oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSavingThrowDecrease(SAVING_THROW_ALL,1)), oPC);
    }

    // ENANO ARTICO
    if(iRaza == RACIAL_TYPE_DWARF_ARTICO)
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eUltravision, oPC);
    }

    //TRASGO
    else if(iRaza == RACIAL_TYPE_TIEFLING)
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eUltravision, oPC);
    }

    // GRAN TRASGO
    else if(iRaza == RACIAL_TYPE_GRAN_TRASGO)
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eUltravision, oPC);
    }

    // TIFLIN - Antiguo
    else if(sSubraza == "tiflin" || sSubraza == "Tiflin")
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCincoFueg, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCincoFrio, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCincoElec, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEnganyar2, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEsconderse2, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eUltravision, oPC);
    }

    // SEMIOGRO
    else if(iRaza == RACIAL_TYPE_SEMIOGRO)
    {
        NWNX_Creature_SetSize(oPC, CREATURE_SIZE_LARGE);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eUltravision, oPC);
    }

    // OGRO
    else if(iRaza == RACIAL_TYPE_OGRO)
    {
        NWNX_Creature_SetSize(oPC, CREATURE_SIZE_LARGE); //Por si ponemos la skin de semiorco al PJ.
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eUltravision, oPC);
    }

    // OGRO HECHICERO
    else if(iRaza == RACIAL_TYPE_OGROHECHICERO)
    {
        NWNX_Creature_SetSize(oPC, CREATURE_SIZE_LARGE); //Por si ponemos la skin de semiorco al PJ.
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eUltravision, oPC);
    }

    // MINOTAURO
    else if(iRaza == RACIAL_TYPE_MINOTAURO)
    {
        NWNX_Creature_SetSize(oPC, CREATURE_SIZE_LARGE); //Por si ponemos la skin de semiorco al PJ.
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eUltravision, oPC);
    }

    // DROWS
    else if(iRaza == RACIAL_TYPE_DROW || iRaza == RACIAL_TYPE_DROW_BASICO)
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eUltravision, oPC);
        if (iDrowTamano==FALSE)
        {
            if (!((GetObjectVisualTransform(oPC,OBJECT_VISUAL_TRANSFORM_SCALE)>=0.95) && (GetObjectVisualTransform(oPC,OBJECT_VISUAL_TRANSFORM_SCALE)<=0.97)))
            {
                SetObjectVisualTransform(oPC, OBJECT_VISUAL_TRANSFORM_SCALE, 0.97);
                GuardarIntPersistente(oPC, "DROWTAMANO", TRUE);

            }
        }
    }


    // LYTHARI
    else if(sSubraza == "lythari" || sSubraza == "Lythari")
    {
        int iEstadoLicantropia = ObtenerIntPersistente(oPC, "ESTADOLICANTROPIA");
        if(iEstadoLicantropia == 0) // Humanoide
        {
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMasDosCAArmadura, oPC);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBuscar2, oPC);
        }
        else // Animal
        {
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDanyo1d10, oPC);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMasCuatroCAArmadura, oPC);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBuscar2, oPC);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eReflejos2, oPC);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFortaleza2, oPC);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRD5Mas3, oPC);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVelocidadAnimal, oPC);
        }
    }

    // LICANTROPOS
    else if(sSubraza == "licantropo" || sSubraza == "Licantropo")
    {
        int iEstadoLicantropia = ObtenerIntPersistente(oPC, "ESTADOLICANTROPIA");
        if(iEstadoLicantropia == 0) // Humanoide
        {
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMasDosCAArmadura, oPC);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSupervivencia2, oPC);
        }
        else // Hibrida
        {
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMasCuatroCAArmadura, oPC);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBuscar2, oPC);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eReflejos2, oPC);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFortaleza2, oPC);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRD5Mas1, oPC);

            if(iEstadoLicantropia == 2) // Animal
            {
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDanyo1d10, oPC);
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVelocidadAnimal, oPC);
            }
        }
    }

    // DUERGAR
    else if(iRaza == RACIAL_TYPE_DUERGAR)
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eUltravision, oPC);
    }

    // KOBOLD
    else if(iRaza == RACIAL_TYPE_KOBOLD)
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eUltravision, oPC);
    }

    // ORCO
    else if(iRaza == RACIAL_TYPE_ORCO_MONTANA)
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eUltravision, oPC);
    }

    // OSGO
    else if(iRaza == RACIAL_TYPE_OSGO)
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eUltravision, oPC);
    }

    // GENASI DE AGUA
    else if(iRaza == RACIAL_TYPE_GAGUA)
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBonoGenasiAgua, oPC);
    }

    // GENASI DE AIRE
    else if(iRaza == RACIAL_TYPE_GAIRE)
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBonoGenasiAire, oPC);
    }

    // GENASI DE FUEGO
    else if(iRaza == RACIAL_TYPE_GFUEGO)
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBonoGenasiFuego, oPC);
    }

    // GENASI DE TIERRA
    else if(iRaza == RACIAL_TYPE_GTIERRA)
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBonoGenasiTierra, oPC);
    }

    // UMBRA
    else if(sSubraza == "umbra" || sSubraza == "Umbra")
    {
        if(GetLocalInt(oPC, "BONOS_UMBRA"))
        {
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMasCuatroCAArmadura, oPC);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMasCuatroSalvaciones, oPC);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAvistar4, oPC);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEscuchar4, oPC);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEsconderse8, oPC);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMoverse8, oPC);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eResistenciaMagicaDrowSvirf, oPC);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRegeneracion2, oPC);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVelocidadUmbra, oPC);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMasDosDmgUmbra, oPC);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMasDosAtaque, oPC);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eUltravision, oPC);
        }
    }

    // LICHE
    else if(sSubraza == "liche" || sSubraza == "Liche")
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMasCincoCAArmadura, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAvistar8, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEscuchar8, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEsconderse8, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMoverse8, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBuscar8, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAveriguarIntenciones8, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImmuGolpesCriticos, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImmuMagiaMuerte, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImmuEnfermedad, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImmuNivelNegativo, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImmuReduccionCaracteristica, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImmuConjurosEnajenadores, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImmuParalisis, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImmuVeneno, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImmuAtaqueFurtivo, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImmuFrio, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImmuElectrico, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eQuinceCon, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eQuinceNeg, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDmgLich, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eUltravision, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImmunudadexpulsion2, oPC);
    }
    // SEMIFATA
    else if(sSubraza == "semifata" || sSubraza == "Semifata")
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImmuConjurosEnajenadores, oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVelocidadFata, oPC);

    }

    // GOLIAT
    else if(iRaza == RACIAL_TYPE_GOLIAT)
    {
        NWNX_Creature_SetSize(oPC, CREATURE_SIZE_LARGE);
    }

    // SHADAR KAI
    else if(iRaza == RACIAL_TYPE_SHADARKAI)
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eUltravision, oPC);
    }

    // TUMULARIO
    else if(iRaza == RACIAL_TYPE_WIGHT)
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eUltravision, oPC);
    }

    // TANARUK
    else if(iRaza == RACIAL_TYPE_TANARUKK)
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eUltravision, oPC);
    }

    // GNOLL
    else if(iRaza == RACIAL_TYPE_GNOLL)
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eUltravision, oPC);
    }

    // CELADRIN
    else if(iRaza == RACIAL_TYPE_CELADRIN)
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eUltravision, oPC);
    }

    // AZERBLOOD
    else if(iRaza == RACIAL_TYPE_AZERBLOOD)
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eUltravision, oPC);
    }

    // KENKU
    else if(iRaza == RACIAL_TYPE_KENKU)
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eUltravision, oPC);
    }

    // YUANTI
    else if(iRaza == RACIAL_TYPE_YUANTI)
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eUltravision, oPC);
    }

    //Indicar que ya se le ha dado los efectos de al subrazas.
    GuardarIntPersistente(oPC, "bSubRaza", 1);
}

//void main(){}
