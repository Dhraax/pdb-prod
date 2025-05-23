//OnHit de Espada Cazadora, hace 1d4 a psíquico vs malignos.
#include "pb_constantes"
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "pb_nivellanzador"

void main()
{
    object oTarget = GetSpellTargetObject();
    int nDmg = d6();
    int iAlineamiento = GetAlignmentGoodEvil(oTarget);

    effect eDmg = EffectDamage(nDmg,DAMAGE_TYPE_PSIQUICO);
    effect eMiedo = EffectFrightened();
    effect eVis = EffectVisualEffect(1231); // PRCVFX_COM_HIT_NEGATIVE
    eDmg = EffectLinkEffects (eVis, eDmg);

    if (GetIsObjectValid(oTarget))
    {
        if(iAlineamiento == ALIGNMENT_EVIL)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget);

        }
        if(!MySavingThrow(SAVING_THROW_WILL, oTarget, 10 + (GetTotalCasterLevel(OBJECT_SELF)/4) + GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF), SAVING_THROW_TYPE_FEAR, OBJECT_SELF))
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eMiedo, oTarget, RoundsToSeconds(2));
        }

    }

}
