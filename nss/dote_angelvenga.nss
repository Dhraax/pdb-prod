#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "inc_spells"
#include "cls_ing_lib"
#include "pb_nivellanzador"

void main()
{
    object oPC = OBJECT_SELF;

    //Enlistamos efectos.
    effect eAtaque = EffectAttackIncrease(3);
    effect eVelocidad = EffectMovementSpeedIncrease(50);
    effect eVis = EffectVisualEffect(VFX_IMP_AURA_UNEARTHLY);

    //Duración de los efectos.
    float fDuracion = RoundsToSeconds(GetAbilityModifier(ABILITY_CHARISMA,oPC));

    //Aplicamos los efectos.
    gsSPApplyEffect(oPC, eAtaque, GetSpellId(), fDuracion);
    gsSPApplyEffect(oPC, eVelocidad, GetSpellId(), fDuracion);
    gsSPApplyEffect(oPC, eVis, GetSpellId(), GS_SP_DURATION_INSTANT);
}


