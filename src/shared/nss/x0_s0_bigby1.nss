//::///////////////////////////////////////////////
//:: Bigby's Interposing Hand
//:: [x0_s0_bigby1]
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Grants -4 to hit y 50% de movimiento disminuido to target for 1 round / level
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 7, 2002
//:://////////////////////////////////////////////

#include "nw_i0_spells"
#include "x2_inc_spellhook"
#include "pb_nivellanzador"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
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
  object oTarget = GetSpellTargetObject();
  int nDuration = GetTotalCasterLevel(OBJECT_SELF);
  int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;

  //--------------------------------------------------------------------------
  // This spell no longer stacks. If there is one hand, that's enough
  //--------------------------------------------------------------------------
  if(GetHasSpellEffect(459, oTarget) ||  GetHasSpellEffect(460, oTarget) ||
     GetHasSpellEffect(461, oTarget) ||  GetHasSpellEffect(462, oTarget) ||
     GetHasSpellEffect(463, oTarget))
  {
      FloatingTextStrRefOnCreature(100775,OBJECT_SELF,FALSE);
      return;
  }

  if(!GetIsReactionTypeFriendly(oTarget))
  {
      //Fire cast spell at event for the specified target
      SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BIGBYS_INTERPOSING_HAND, TRUE));

      //Check for metamagic extend
      if(nMetaMagic == METAMAGIC_EXTEND) //Duration is +100%
      {
           nDuration = nDuration * 2;
      }
      if(!MyResistSpell(OBJECT_SELF, oTarget))
      {
          effect eCA = EffectAttackDecrease(4);
          effect eVelocidad = EffectMovementSpeedDecrease(50);
          effect eVis = EffectVisualEffect(VFX_DUR_BIGBYS_INTERPOSING_HAND);
          effect eLink = EffectLinkEffects(eCA, eVelocidad);
          eLink = EffectLinkEffects(eLink, eVis);

          //Apply the TO HIT PENALTIES bonuses and the VFX impact
          ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
          DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
      }
  }
}

