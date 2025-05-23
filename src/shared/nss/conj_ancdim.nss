//::///////////////////////////////////////////////
//:: ANCLA DIMENSIONAL
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Ancla dimensional.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 8 de Noviembre de 2011
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "nw_i0_spells"
#include "pb_nivellanzador"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);
  /*
    Spellcast Hook Code
    Added 2003-07-07 by Georg Zoeller
    If you want to make changes to all spells,
    check x2_inc_spellhook.nss to find out more
  */

  if (!X2PreSpellCastCode())
  {
      // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
      return;
  }

  object oCaster = OBJECT_SELF;
  object oTarget = GetSpellTargetObject();
  int nCasterLevel= GetTotalCasterLevel(oCaster);
  int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
  int nSpellID = GetSpellId();
  float fDur = 60.0 * nCasterLevel;

  if(nMetaMagic == METAMAGIC_EXTEND)
  {
      fDur = fDur * 2; //Duration is +100%
  }

  // Touch Attack
  int iAttackRoll = TouchAttackRanged(oTarget);

  // Shoot the ray
  effect eRay = EffectBeam(VFX_BEAM_DISINTEGRATE, oCaster, BODY_NODE_HAND, !(iAttackRoll > 0));
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7);

  // Apply effect if hit
  if(iAttackRoll > 0)
  {
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_AURA_GREEN_DARK), oTarget, fDur);
  }

  SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
  DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
