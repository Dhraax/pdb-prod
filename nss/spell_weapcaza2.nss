//OnHit de Espada Cazadora, hace 1d4 a psíquico vs malignos.
#include "pb_constantes"

void main()
{
    object oTarget = GetSpellTargetObject();
    int nDmg = d4();
    int iAlineamiento = GetAlignmentGoodEvil(oTarget);

    effect eDmg = EffectDamage(nDmg,DAMAGE_TYPE_PSIQUICO);
    effect eVis = EffectVisualEffect(1231); // PRCVFX_COM_HIT_NEGATIVE
    eDmg = EffectLinkEffects (eVis, eDmg);

    if (GetIsObjectValid(oTarget))
    {
        if(iAlineamiento == ALIGNMENT_EVIL)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget);
        }

    }

}
