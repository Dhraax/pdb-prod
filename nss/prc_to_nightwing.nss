//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Feb 05, 2003
//:://////////////////////////////////////////////
#include "conv_inc"
#include "mti_libreria"
#include "pb_nivellanzador"
#include "x2_inc_spellhook"

void main()
{

  if (!X2PreSpellCastCode())
        {
        // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
            return;
        }

    int nCasterLevel = GetLevelByClass(CLASS_TYPE_ORCUS,OBJECT_SELF);
    int nDG = GetHitDice(OBJECT_SELF);
    int nDuration = nCasterLevel+nDG;
    effect eSummon;
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_EPIC_UNDEAD);

            eSummon = EffectSummonCreature("s_nightwings");


    //Apply the VFX impact and summon effect
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, GetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), TurnsToSeconds(nDuration));

    // Aumentar convocacion
    DelayCommand(2.0, BonosConvocarCriatura());
}





