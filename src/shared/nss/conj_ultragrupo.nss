//::///////////////////////////////////////////////
//:: ULTRAVISION EN GRUPO
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Ultravision en grupo.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 31 de Mayo de 2010
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "x0_i0_spells"
#include "pb_nivellanzador"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_DIVINATION);
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
  int nDuration = GetTotalCasterLevel(oCaster);
  if((GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE) == METAMAGIC_EXTEND)
  {
      nDuration = nDuration * 2;
  }

  location lTarget = GetSpellTargetLocation();
  object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
  while(GetIsObjectValid(oTarget))
  {
      if(GetFactionLeader(oCaster) == GetFactionLeader(oTarget) && !GetIsDead(oTarget))
      {
          effect eEffect = GetFirstEffect(oTarget);
          while(GetIsEffectValid(eEffect))
          {
              if(GetEffectType(eEffect) == EFFECT_TYPE_ULTRAVISION)
              {
                  RemoveEffect(oTarget, eEffect);
              }

              eEffect = GetNextEffect(oTarget);
          }

          ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectLinkEffects(EffectLinkEffects(EffectLinkEffects(EffectVisualEffect(VFX_DUR_ULTRAVISION), EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE)), EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT)), EffectUltravision()), oTarget, HoursToSeconds(nDuration));
          SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
      }

      oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
      DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
  }
}
