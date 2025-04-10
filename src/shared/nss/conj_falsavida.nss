//::///////////////////////////////////////////////
//:: FALSA VIDA
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Falsa vida.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 30 de Marzo de 2011
//:://////////////////////////////////////////////

#include "nw_i0_spells"
#include "x2_inc_spellhook"
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

  if (!X2PreSpellCastCode())
  {
      // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
      return;
  }

  // End of Spell Cast Hook

  //Declare major variables
  object oCaster = OBJECT_SELF;
  object oTarget = GetSpellTargetObject();
  int nCasterLvl = GetTotalCasterLevel(oCaster);
  int nDuration = nCasterLvl;
  int iVida = d10();
  int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
  int iBonus;

  //Enter Metamagic conditions
  if(nMetaMagic == METAMAGIC_MAXIMIZE)
  {
      iVida = 10;//Damage is at max
  }

  else if(nMetaMagic == METAMAGIC_EMPOWER)
  {
      iVida = iVida + (iVida/2); //Damage/Healing is +50%
  }

  else if(nMetaMagic == METAMAGIC_EXTEND)
  {
      nDuration = nDuration * 2; //Duration is +100%
  }

  // No se apila
  RemoveEffectsFromSpell(oTarget, 1136);

  if(nCasterLvl < 10) iBonus = nCasterLvl;
  else iBonus = 10;

  effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
  effect eHP = EffectTemporaryHitpoints(iVida + iBonus);
  effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);

  //Fire spell cast at event for target
  SignalEvent(oTarget, EventSpellCastAt(oTarget, GetSpellId(), FALSE));

  //Apply the VFX impact and effects
  ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, TurnsToSeconds(nDuration));
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oTarget, TurnsToSeconds(nDuration));
  DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
