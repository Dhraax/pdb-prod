#include "pb_nivellanzador"
#include "x2_inc_spellhook"
#include "war_utilities"

void main()
{
    object oTarget = GetSpellTargetObject();
    effect eDur = EffectVisualEffect(1235);
    effect eDur2 = EffectVisualEffect(1747);
    effect eLink = EffectLinkEffects(eDur,eDur2);

    if (CambiarEsencia(WARLOCK_ESENCIA_CAUSTICA))
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
}
