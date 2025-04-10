//::///////////////////////////////////////////////
//:: ORBE
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Orbe.
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
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);
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
  if(!nTouch)
  {
      return;
  }

  if(!MyResistSpell(oCaster,oTarget))
  {

      int nCasterLevel = GetTotalCasterLevel(oCaster);
      if(nCasterLevel > 15)
      {
          nCasterLevel = 15;
      }

      int nDmg = d6(nCasterLevel);
      int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
      if(nMetaMagic == METAMAGIC_EMPOWER)
      {
          nDmg = nDmg + (nDmg / 2);
      }

      if(nMetaMagic == METAMAGIC_MAXIMIZE)
      {
          nDmg = 6 * nCasterLevel;
      }
      if(nTouch == 2)
      {
          nDmg = nDmg * 2;
      }

      int nVfx1;
      int nVfx2;
      int nType;
      int nSaveType;
      int nImmune;
      int nImmune2;
      effect eEffect;
      int nSpellId = GetSpellId();
      switch(nSpellId)
      {
          case 1034: nVfx1 = VFX_IMP_ACID_S;      nType = DAMAGE_TYPE_ACID;       nSaveType = SAVING_THROW_TYPE_ACID;        nVfx2 = VFX_IMP_STUN;         eEffect = EffectStunned();   nImmune = IMMUNITY_TYPE_STUN;      nImmune2 = IMMUNITY_TYPE_MIND_SPELLS; break;//Acid_Orb
          case 1035: nVfx1 = VFX_IMP_FROST_S;     nType = DAMAGE_TYPE_COLD;       nSaveType = SAVING_THROW_TYPE_COLD;        nVfx2 = VFX_IMP_BLIND_DEAF_M; eEffect = EffectBlindness(); nImmune = IMMUNITY_TYPE_BLINDNESS; nImmune2 = -1; break;//Cold_Orb
          case 1036: nVfx1 = VFX_IMP_LIGHTNING_S; nType = DAMAGE_TYPE_ELECTRICAL; nSaveType = SAVING_THROW_TYPE_ELECTRICITY; nVfx2 = VFX_IMP_SLOW;         eEffect = EffectSlow();      nImmune = IMMUNITY_TYPE_SLOW;      nImmune2 = -1; break;//Electric_Orb
          case 1037: nVfx1 = VFX_IMP_FLAME_S;     nType = DAMAGE_TYPE_FIRE;       nSaveType = SAVING_THROW_TYPE_FIRE;        nVfx2 = VFX_IMP_DAZED_S;      eEffect = EffectDazed();     nImmune = IMMUNITY_TYPE_DAZED;     nImmune2 = IMMUNITY_TYPE_MIND_SPELLS; break;//Fire_Orb
          case 1038: nVfx1 = VFX_IMP_SONIC;       nType = DAMAGE_TYPE_SONIC;      nSaveType = SAVING_THROW_TYPE_SONIC;       nVfx2 = VFX_IMP_BLIND_DEAF_M; eEffect = EffectDeaf();      nImmune = IMMUNITY_TYPE_DEAFNESS;  nImmune2 = -1; break;//Sonic_Orb
      }

      SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellId, TRUE));

      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDmg, ChangedElementalDamage(OBJECT_SELF, nType)), oTarget);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nVfx1), oTarget);
      int nSave = FortitudeSave(oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(OBJECT_SELF)), nSaveType, oCaster);
      if(nSave == 1)
      {
          ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FORTITUDE_SAVING_THROW_USE), oTarget);
      }
      else if(!nSave)
      {
          ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, RoundsToSeconds(1));
          if(!GetIsImmune(oTarget, nImmune))
          {
              if(nImmune2)
              {
                  if(GetIsImmune(oTarget, nImmune2))
                  {
                      return;
                  }
              }

              ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nVfx2), oTarget);

          }
      }
  }
  DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

