#include "pb_nivellanzador"
#include "x2_inc_spellhook"
#include "war_utilities"

void main()
{
    object oTarget = GetSpellTargetObject();
    //effect eDur = EffectVisualEffect(VFX_FNF_SOUND_BURST);
    effect eDur = EffectVisualEffect(1320);
    effect eDur2 = EffectVisualEffect(1746);
    effect eLink = EffectLinkEffects(eDur,eDur2);

    if (CambiarEsencia(WARLOCK_ESENCIA_DERRIBO))
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
}
