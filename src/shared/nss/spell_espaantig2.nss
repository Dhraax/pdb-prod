#include "pb_constantes"
#include "NW_I0_SPELLS"


void main()
{
    object oTarget = GetSpellTargetObject();
    int nDmg = d6();
    int iAlineamiento = GetAlignmentGoodEvil(oTarget);

    effect eDmg = EffectDamage(nDmg,DAMAGE_TYPE_DIVINE);
    effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);
    effect eCharm = EffectCharmed();
    eCharm = GetScaledEffect(eCharm, oTarget);

    eDmg = EffectLinkEffects (eVis, eDmg);

    if (GetIsObjectValid(oTarget))
    {
        if(iAlineamiento == ALIGNMENT_EVIL)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget);
            if (!MySavingThrow(SAVING_THROW_WILL, oTarget, 10 + (GetTotalCasterLevel(OBJECT_SELF)/4) + GetAbilityModifier(ABILITY_CHARISMA,OBJECT_SELF), SAVING_THROW_TYPE_MIND_SPELLS))
            {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCharm, oTarget, RoundsToSeconds(1));
            }
        }

    }

}
