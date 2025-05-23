#include "pb_constantes"
#include "NW_I0_SPELLS"
#include "pb_constantes"
#include "cerr_newdispel"

void main()
{
    object oTarget = GetSpellTargetObject();
    int nDmg = d6();
    int iAlineamiento = GetAlignmentGoodEvil(oTarget);

    effect eDmg = EffectDamage(nDmg,DAMAGE_TYPE_NEGATIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eCharm = EffectCharmed();
    eCharm = GetScaledEffect(eCharm, oTarget);

    eDmg = EffectLinkEffects (eVis, eDmg);

    if (GetIsObjectValid(oTarget))
    {
        if(iAlineamiento == ALIGNMENT_GOOD)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget);

        }
        //Apartado del disipar lo aplica siempre.
        int       nCasterLevel = GetTotalCasterLevel(OBJECT_SELF);
        effect    eVis         = EffectVisualEffect(VFX_IMP_BREACH);
        effect    eImpact      = EffectVisualEffect(VFX_FNF_DISPEL);

        if(nCasterLevel > 10)
        {
            nCasterLevel = 10;
        }
            pbDispelMagic(oTarget, nCasterLevel, eVis, eImpact);
        }

}
