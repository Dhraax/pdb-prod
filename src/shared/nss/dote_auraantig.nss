#include "x0_i0_spells"
#include "inc_spells"

void main()
{
  object oPC = OBJECT_SELF;

  if(GetHasSpellEffect(1431))
  {
      gsSPRemoveEffect(oPC, 1431);
      IncrementRemainingFeatUses(oPC, 1730);
      FloatingTextStringOnCreature("<cþ<<>** Aura de los antiguos desactivada **</c>", oPC);
      return;
  }

  FloatingTextStringOnCreature("<c´þd>** Aura de los antiguos activada **</c>", oPC);
  effect eAOE = EffectAreaOfEffect(AOE_MOB_CIRCCHAOS, "dote_auraantig2", "****", "dote_auraantig3");
  gsSPApplyEffect(oPC, eAOE, 1431, GS_SP_DURATION_PERMANENT);
  //gsSPApplyEffect(oPC, EffectImmunity(IMMUNITY_TYPE_FEAR), 1431, GS_SP_DURATION_PERMANENT);
}
