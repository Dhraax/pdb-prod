//::///////////////////////////////////////////////
//:: Divine Power
//:: NW_S0_DivPower.nss
//:: Copyright (coffee) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Improves the Clerics attack to be the
    equivalent of a Fighter's BAB of the same level,
    +1 HP per level and raises their strength +6
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 10/04/2012
//:://////////////////////////////////////////////

#include "nw_i0_spells"
#include "x2_inc_spellhook"
#include "nostack_inc"
#include "pb_nivellanzador"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);
/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

  if(!X2PreSpellCastCode())
  {
      // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
      return;
  }

  object oTarget = GetSpellTargetObject();

  int nLevel = GetTotalCasterLevel(OBJECT_SELF);
  int oPCLevel = GetHitDice(oTarget);
  int nModAttack;
  int nHP = nLevel;
  int nAttack = oPCLevel - GetBaseAttackBonus(oTarget) ;
  int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
  int NAtaqueBase;
  if (GetBaseAttackBonus(oTarget) <=5 )NAtaqueBase = 1;
  if (GetBaseAttackBonus(oTarget) >=6 ) NAtaqueBase = 2;
  if (GetBaseAttackBonus(oTarget) >=11 ) NAtaqueBase = 3;
  if (GetBaseAttackBonus(oTarget) >=16 ) NAtaqueBase = 4;
  if (oPCLevel <=5 ) nModAttack = 1 - NAtaqueBase;
  if (oPCLevel >=6 ) nModAttack = 2 - NAtaqueBase;
  if (oPCLevel >=11 ) nModAttack = 3 - NAtaqueBase;
  if (oPCLevel >=16 ) nModAttack = 4 - NAtaqueBase;
  if(nModAttack < 0) nModAttack = 0;
  effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
  effect eHP = EffectTemporaryHitpoints(nHP);
  effect eAttack = EffectAttackIncrease(nAttack);
  effect eAttackMod = EffectModifyAttacks(nModAttack);
  effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
  effect eLink = EffectLinkEffects(eAttack, eAttackMod);

  eLink = EffectLinkEffects(eLink, eDur);

  //Meta-Magic
  if(nMetaMagic == METAMAGIC_EXTEND)
  {
      nLevel *= 2;
  }

  RemoveEffectsFromSpell(oTarget, GetSpellId());
  RemoveTempHitPoints();

  float fDuration = RoundsToSeconds(nLevel);

  //Fire cast spell at event for the specified target
//  SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DIVINE_POWER, FALSE));

  //Apply Link and VFX effects to the target
  DoNoStackAbilityBonus(OBJECT_SELF, OBJECT_SELF, 6, ABILITY_STRENGTH, fDuration);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oTarget, fDuration);
  ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
 DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}