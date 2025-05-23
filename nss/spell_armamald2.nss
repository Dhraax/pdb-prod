//OnHit de Maldita, hace 1d6 necrótico a buenos.
#include "pb_constantes"

void main()
{
    object oTarget = GetSpellTargetObject();
    int nDmg = d6();
    int iAlineamiento = GetAlignmentGoodEvil(oTarget);

    effect eDmg = EffectDamage(nDmg,DAMAGE_TYPE_NEGATIVE);
    effect eVis = EffectVisualEffect(VFX_COM_HIT_NEGATIVE);
    eDmg = EffectLinkEffects (eVis, eDmg);

    if (GetIsObjectValid(oTarget))
    {
        if(iAlineamiento == ALIGNMENT_GOOD)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget);
        }

    }

}
