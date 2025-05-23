//::///////////////////////////////////////////////
//:: Thrall of Orcus Pallor of Death
//:: prc_to_pallor.nss
//:://////////////////////////////////////////////
/*
    Upon entering the aura of the creature the enemy
    must make a will save or be struck with fear because
    of the Thrall's appearance
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: July 11, 2004
//:://////////////////////////////////////////////

#include "pb_nivellanzador"
#include "x0_i0_spells"

void main()
{
  object oPC = OBJECT_SELF;

  int nDur = GetLevelByClass(CLASS_TYPE_ORCUS, OBJECT_SELF);
  effect eDur = EffectVisualEffect(VFX_DUR_GHOST_SMOKE_2);
  effect eDur2 = EffectVisualEffect(VFX_DUR_GHOST_TRANSPARENT);


 //Set and apply AOE object
  FloatingTextStringOnCreature("<c´þd>** Palidez de Muerte activada **</c>", oPC);
  effect eAOE = EffectAreaOfEffect(AOE_MOB_FEAR, "prc_to_pallora", "****", "****");
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oPC, HoursToSeconds(nDur));
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur2, oPC, HoursToSeconds(nDur));
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, OBJECT_SELF, HoursToSeconds(nDur));
}
