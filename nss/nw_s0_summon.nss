//::///////////////////////////////////////////////
//:: Summon Creature Series
//:: NW_S0_Summon
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Carries out the summoning of the appropriate
    creature for the Summon Monster Series of spells
    1 to 9
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 8, 2002
//:://////////////////////////////////////////////

effect SetSummonEffect(int nSpellID);

#include "conv_inc"
#include "x2_inc_spellhook"
#include "mti_libreria"
#include "pb_nivellanzador"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);
/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
    // End of Spell Cast Hook

    //Declare major variables
    int nSpellID = GetSpellId();
    int nDuration = GetTotalCasterLevel(OBJECT_SELF);
    if(nDuration < 5) nDuration = 5;

    //Make metamagic check for extend
    int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;   //Duration is +100%
    }

    //Apply the VFX impact and summon effect
    effect eSummon = SetSummonEffect(nSpellID);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), (TurnsToSeconds(nDuration))*2);

    // Aumentar convocacion y Dominio Animal
    DelayCommand(2.0, BonosConvocarCriatura());
}

effect SetSummonEffect(int nSpellID)
{
    int nFNF_Effect;
    int nRoll = d4();
    string sSummon;

    string sConvocarMemorizadoI = ObtenerStringPersistente(OBJECT_SELF, "CONV1");
    string sConvocarMemorizadoII = ObtenerStringPersistente(OBJECT_SELF, "CONV2");
    string sConvocarMemorizadoIII = ObtenerStringPersistente(OBJECT_SELF, "CONV3");
    string sConvocarMemorizadoIV = ObtenerStringPersistente(OBJECT_SELF, "CONV4");
    string sConvocarMemorizadoV = ObtenerStringPersistente(OBJECT_SELF, "CONV5");
    string sConvocarMemorizadoVI = ObtenerStringPersistente(OBJECT_SELF, "CONV6");
    string sConvocarMemorizadoVII = ObtenerStringPersistente(OBJECT_SELF, "CONV7");
    string sConvocarMemorizadoVIII = ObtenerStringPersistente(OBJECT_SELF, "CONV8");
    string sConvocarMemorizadoIX = ObtenerStringPersistente(OBJECT_SELF, "CONV9");

    if(nSpellID == SPELL_SUMMON_CREATURE_I || nSpellID == 1075)
    {
        if(sConvocarMemorizadoI != "") sSummon = sConvocarMemorizadoI;
        else sSummon = "NW_S_badgerdire";

        nFNF_Effect = VFX_FNF_SUMMON_MONSTER_1;
    }

    else if(nSpellID == SPELL_SUMMON_CREATURE_II || nSpellID == 1081)
    {
        if(sConvocarMemorizadoII != "") sSummon = sConvocarMemorizadoII;
        else sSummon = "NW_S_BOARDIRE";

        nFNF_Effect = VFX_FNF_SUMMON_MONSTER_1;
    }

    else if(nSpellID == SPELL_SUMMON_CREATURE_III || nSpellID == 1086)
    {
        if(sConvocarMemorizadoIII != "") sSummon = sConvocarMemorizadoIII;
        else sSummon = "NW_S_WOLFDIRE";

        nFNF_Effect = VFX_FNF_SUMMON_MONSTER_1;
    }

    else if(nSpellID == SPELL_SUMMON_CREATURE_IV || nSpellID == 1092)
    {
        if(sConvocarMemorizadoIV != "") sSummon = sConvocarMemorizadoIV;
        else sSummon = "NW_S_SPIDDIRE";

        nFNF_Effect = VFX_FNF_SUMMON_MONSTER_2;
    }

    else if(nSpellID == SPELL_SUMMON_CREATURE_V)
    {
        if(sConvocarMemorizadoV != "") sSummon = sConvocarMemorizadoV;
        else sSummon = "NW_S_beardire";

        nFNF_Effect = VFX_FNF_SUMMON_MONSTER_2;
    }

    else if(nSpellID == SPELL_SUMMON_CREATURE_VI)
    {
        if(sConvocarMemorizadoVI != "") sSummon = sConvocarMemorizadoVI;
        else sSummon = "NW_S_diretiger";

        nFNF_Effect = VFX_FNF_SUMMON_MONSTER_2;
    }

    else if(nSpellID == SPELL_SUMMON_CREATURE_VII)
    {
        if(sConvocarMemorizadoVII != "") sSummon = sConvocarMemorizadoVII;
        else
        {
            switch (nRoll)
            {
                case 1:
                sSummon = "NW_S_AIRHUGE";
                break;

                case 2:
                sSummon = "NW_S_WATERHUGE";
                break;

                case 3:
                sSummon = "NW_S_FIREHUGE";
                break;

                case 4:
                sSummon = "conv_eletieeno";
                break;
            }
        }

        nFNF_Effect = VFX_FNF_SUMMON_MONSTER_3;
    }

    else if(nSpellID == SPELL_SUMMON_CREATURE_VIII)
    {
        if(sConvocarMemorizadoVIII != "") sSummon = sConvocarMemorizadoVIII;
        else
        {
            switch (nRoll)
            {
                case 1:
                sSummon = "NW_S_AIRGREAT";
                break;

                case 2:
                sSummon = "NW_S_WATERGREAT";
                break;

                case 3:
                sSummon = "NW_S_FIREGREAT";
                break;

                case 4:
                sSummon = "conv_eletiemay";
                break;
            }
        }

        nFNF_Effect = VFX_FNF_SUMMON_MONSTER_3;
    }

    else if(nSpellID == SPELL_SUMMON_CREATURE_IX)
    {
        if(sConvocarMemorizadoIX != "") sSummon = sConvocarMemorizadoIX;
        else
        {
            switch (nRoll)
            {
                case 1:
                sSummon = "NW_S_AIRELDER";
                break;

                case 2:
                sSummon = "NW_S_WATERELDER";
                break;

                case 3:
                sSummon = "NW_S_FIREELDER";
                break;

                case 4:
                sSummon = "conv_eletieanc";
                break;
            }
        }

        nFNF_Effect = VFX_FNF_SUMMON_MONSTER_3;
    }

    effect eSummonedMonster = EffectSummonCreature(sSummon, nFNF_Effect);
    return eSummonedMonster;
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
