//::///////////////////////////////////////////////
//:: Summon Undead
//:: X2_S2_SumUndead
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     The level of the Pale Master determines the
     type of undead that is summoned.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Feb 05, 2003
//:: Updated By: Georg Zoeller, Oct 2003
//:://////////////////////////////////////////////
#include "conv_inc"
#include "mti_libreria"
void main()
{
    //Declare major variables
    int nCasterLevel = GetLevelByClass(CLASS_TYPE_PALEMASTER,OBJECT_SELF);
    int nDuration = nCasterLevel;
    if(nDuration < 5) nDuration = 5;

    //Summon the appropriate creature based on the summoner level
    string sConvocarMemorizadoCnMV = ObtenerStringPersistente(OBJECT_SELF, "CONV13");
    string sSummon;

    if(sConvocarMemorizadoCnMV != "") sSummon = sConvocarMemorizadoCnMV;
    else
    {
        if (nCasterLevel <= 5) sSummon = "NW_S_GHOUL";
        else if (nCasterLevel == 6) sSummon = "NW_S_SHADOW";
        else if (nCasterLevel == 7) sSummon = "NW_S_GHAST";
        else if (nCasterLevel == 8) sSummon = "NW_S_WIGHT";
        else if (nCasterLevel >= 9) sSummon = "X2_S_WRAITH";
    }

    effect eSummon = EffectSummonCreature(sSummon, VFX_FNF_SUMMON_UNDEAD, 0.0f, 1);

    // * Apply the summon visual and summon the two undead.
    // * ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_FNF_LOS_EVIL_10),GetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), TurnsToSeconds(nDuration));

    // Aumentar convocacion
    DelayCommand(2.0, BonosConvocarCriatura());
}
