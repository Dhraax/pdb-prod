#include "pb_nivellanzador"
#include "x2_inc_spellhook"
#include "war_utilities"

void main()
{
    object oTarget = GetSpellTargetObject();
    //effect eDur = EffectVisualEffect(VFX_IMP_AC_BONUS);
    effect eDur = EffectVisualEffect(1238);
    effect eDur2 = EffectVisualEffect(1745);
    effect eLink = EffectLinkEffects(eDur,eDur2);

    if (CambiarEsencia(WARLOCK_ESENCIA_INFERNAL))
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
}
