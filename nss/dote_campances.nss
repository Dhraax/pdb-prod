#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "inc_spells"
#include "cls_ing_lib"
#include "pb_nivellanzador"

void main()
{
    object oPC = OBJECT_SELF;

    //Enlistamos efectos.
    effect eReg = EffectRegenerate(6, 6.0);
    effect eCA = EffectACIncrease(3);
    effect eVis = EffectVisualEffect(VFX_IMP_AURA_HOLY);

    //Duración de los efectos.
    float fDuracion = RoundsToSeconds(GetAbilityModifier(ABILITY_CHARISMA,oPC) + 1);

    //Aplicamos los efectos.
    gsSPApplyEffect(oPC, eReg, GetSpellId(), fDuracion);
    gsSPApplyEffect(oPC, eCA, GetSpellId(), fDuracion);
    gsSPApplyEffect(oPC, eVis, GetSpellId(), GS_SP_DURATION_INSTANT);
}


