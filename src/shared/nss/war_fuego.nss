#include "war_utilities"

void main()
{
    object oTarget = GetSpellTargetObject();
    //effect eDur = EffectVisualEffect(VFX_IMP_ELEMENTAL_PROTECTION);
    effect eDur = EffectVisualEffect(1843);
    effect eDur2 = EffectVisualEffect(1515);
    effect eLink = EffectLinkEffects(eDur,eDur2);

    if (CambiarEsencia(WARLOCK_ESENCIA_AZUFRE))
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
}
