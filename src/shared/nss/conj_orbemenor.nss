//::///////////////////////////////////////////////
//:: ORBE MENOR
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Orbe menor.
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
      if(nCasterLevel > 10)
      {
          nCasterLevel = 10;
      }

      int nDmg = d8(nCasterLevel / 2);
      int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
      if(nMetaMagic == METAMAGIC_EMPOWER)
      {
          nDmg = nDmg + (nDmg / 2);
      }

      if(nMetaMagic == METAMAGIC_MAXIMIZE)
      {
          nDmg = 8 * (nCasterLevel / 2);
      }

      if(nTouch == 2)
      {
          nDmg = nDmg * 2;
      }

      int nVfx;
      int nType;
      int nSpellId = GetSpellId();
      int iSaveType;
      switch(nSpellId)
      {
          case 1029: nVfx = VFX_IMP_ACID_S;      nType = DAMAGE_TYPE_ACID;       iSaveType = SAVING_THROW_TYPE_ACID;            break;//Lesser_Acid_Orb
          case 1030: nVfx = VFX_IMP_FROST_S;     nType = DAMAGE_TYPE_COLD;       iSaveType = SAVING_THROW_TYPE_COLD;            break;//Lesser_Cold_Orb
          case 1031: nVfx = VFX_IMP_LIGHTNING_S; nType = DAMAGE_TYPE_ELECTRICAL; iSaveType = SAVING_THROW_TYPE_ELECTRICITY;     break;//Lesser_Electric_Orb
          case 1032: nVfx = VFX_IMP_FLAME_S;     nType = DAMAGE_TYPE_FIRE;       iSaveType = SAVING_THROW_TYPE_FIRE;            break;//Lesser_Fire_Orb
          case 1033: nVfx = VFX_IMP_SONIC;       nType = DAMAGE_TYPE_SONIC;      iSaveType = SAVING_THROW_TYPE_SONIC;           break;//Lesser_Sonic_Orb
      }

      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDmg, ChangedElementalDamage(OBJECT_SELF, nType)), oTarget);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nVfx), oTarget);
      SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellId, TRUE));
  }
  DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

