//::///////////////////////////////////////////////
//:: RAYO POLAR
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Rayo polar.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 31 de Mayo de 2010
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "nw_i0_spells"
#include "pb_nivellanzador"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);
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

  // End of Spell Cast Hook

  object oCaster = OBJECT_SELF;
  object oTarget = GetSpellTargetObject();
  int nTouch = TouchAttackRanged(oTarget);
  int nMiss;
  //if (!MyResistSpell(OBJECT_SELF, oTarget))
  //{
    if(nTouch > 0)
    {
      int nCasterLevel = GetTotalCasterLevel(oCaster);
      if(nCasterLevel > 25)
      {
          nCasterLevel = 25;
      }

      int nDamage = d6(nCasterLevel);
      int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
      if(nMetaMagic == METAMAGIC_MAXIMIZE)
      {
          nDamage = nCasterLevel * 6;
      }

      if(nMetaMagic == METAMAGIC_EMPOWER)
      {
          nDamage = nDamage + (nDamage / 2);
      }

      if(nTouch == 2)
      {
          nDamage = nDamage * 2;
      }

      SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FROST_S), oTarget);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FROST_L), oTarget);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage, ChangedElementalDamage(OBJECT_SELF, DAMAGE_TYPE_COLD)), oTarget);
    }
    else if(!nTouch)
    {
      nMiss = TRUE;
    }
  //}
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_LIGHTNING, oCaster, BODY_NODE_HAND, nMiss), oTarget, 1.7);//VFX_BEAM_COLD
  DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}