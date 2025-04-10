//::///////////////////////////////////////////////
//:: Summon Greater Undead
//:: X2_S2_SumGrUnd
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     2003-10-03 - GZ: Added Epic Progression
     The level of the Pale Master determines the
     type of undead that is summoned.

     Level 9 <= Mummy Warrior
     Level 10 <= Spectre
     Level 12 <= Vampire Rogue
     Level 14 <= Bodak
     Level 16 <= Ghoul King
     Level 18 <= Vampire Mage
     Level 20 <= Skeleton Blackguard
     Level 22 <= Lich
     Level 24 <= Lich Lord
     Level 26 <= Alhoon
     Level 28 <= Elder Alhoon
     Level 30 <= Lesser Demi Lich

     Lasts 14 + Casterlevel rounds
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Feb 05, 2003
//:://////////////////////////////////////////////
#include "conv_inc"
#include "mti_libreria"
void main()
{

    int nCasterLevel = GetLevelByClass(CLASS_TYPE_PALEMASTER,OBJECT_SELF);
    int nDuration = nCasterLevel;
    if(nDuration < 5) nDuration = 5;

    effect eSummon;

    //--------------------------------------------------------------------------
    // Summon the appropriate creature based on the summoner level
    //--------------------------------------------------------------------------
    string sConvocarMemorizadoCnMVM = ObtenerStringPersistente(OBJECT_SELF, "CONV14");
    string sSummon;

    if(sConvocarMemorizadoCnMVM != "") eSummon = EffectSummonCreature(sConvocarMemorizadoCnMVM, VFX_IMP_HARM, 0.0f, 0);
    else
    {
        if (nCasterLevel >= 30)
        {
            // * Demi Lich
            eSummon = EffectSummonCreature("X2_S_LICH_30",496,0.0f,1);
        }
        else if (nCasterLevel >= 28)
        {
            // * Mega Alhoon
            eSummon = EffectSummonCreature("x2_s_lich_26",496,0.0f,1);
        }
        else if (nCasterLevel >= 26)
        {
            // * Alhoon
            eSummon = EffectSummonCreature("X2_S_LICH_24",496,0.0f,1);
        }
        else if (nCasterLevel >= 24)
        {
            // * Lich
            eSummon = EffectSummonCreature("X2_S_LICH_22",496,0.0f,0);
        }
        else if (nCasterLevel >= 22)
        {
            // * Lich
            eSummon = EffectSummonCreature("X2_S_LICH_20",496,0.0f,0);
        }
        else if (nCasterLevel >= 20)
        {
            // * Skeleton Blackguard
            eSummon = EffectSummonCreature("x2_s_bguard_18",VFX_IMP_HARM,0.0f,0);
        }
        else if (nCasterLevel >= 18)
        {
            // * Vampire Mage
            eSummon = EffectSummonCreature("x2_s_vamp_18",VFX_FNF_SUMMON_UNDEAD,0.0f,1);
        }
        else if (nCasterLevel >= 16)
        {
            // * Ghoul King
            eSummon = EffectSummonCreature("X2_S_GHOUL_16",VFX_IMP_HARM,0.0f,0);
        }
        else if (nCasterLevel >= 14)
        {
            // * Greater Bodak
            eSummon = EffectSummonCreature("X2_S_BODAK_14",VFX_IMP_HARM,0.0f,0);
        }
        else if (nCasterLevel >= 12)
        {
            // * Vampire Rogue
            eSummon = EffectSummonCreature("X2_S_VAMP_10",VFX_FNF_SUMMON_UNDEAD,0.0f,1);
        }
        else if (nCasterLevel >= 10)
        {
            eSummon = EffectSummonCreature("X2_S_SPECTRE_10",VFX_FNF_SUMMON_UNDEAD, 0.0f,1);
        }
        else
        {
            // * Mummy
            eSummon = EffectSummonCreature("X2_S_MUMMY_9",VFX_IMP_HARM, 0.0f,0);
        }
    }

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_FNF_LOS_EVIL_10),GetSpellTargetLocation());
    //Apply the summon visual and summon the two undead.
    //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), TurnsToSeconds(nDuration));

    // Aumentar convocacion
    DelayCommand(2.0, BonosConvocarCriatura());
}
