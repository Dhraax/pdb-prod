//::///////////////////////////////////////////////
//:: HEROISMO / HEROISMO MAYOR
//:: Copyright (c) www.puertadebaldur.net
//:://////////////////////////////////////////////
/*
    Heroismo:
    +2 Ataque
    +2 TS
    +2 Habilidades

    Heroismo mayor:
    +4 Ataque
    +4 TS
    +4 Habilidades
    Immunidad miedo
    Puntos de golpe temporales igual al nivel de lanzador (maximo 20)

    Duracion: asaltos / nivel
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 29 de Mayo de 2010
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "x0_i0_spells"
#include "pb_nivellanzador"
#include "nw_i0_spells"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);
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

  if(GetIsDead(oTarget))
  {
      return;
  }

  int nCasterLevel = GetTotalCasterLevel(oCaster);
  int nSpellId = GetSpellId();
  int nGreater = (nSpellId == 1059);
  float fDuration;

  if(nGreater) fDuration = RoundsToSeconds(nCasterLevel);
  else fDuration = TurnsToSeconds(nCasterLevel);

  if((GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE) == METAMAGIC_EXTEND)
  {
      fDuration = fDuration * 2;
  }

  effect eEffect = GetFirstEffect(oTarget);
  while(GetIsEffectValid(eEffect))
  {
      int nEffectSpellId = GetEffectSpellId(eEffect);
      if(nGreater)
      {
          if(nEffectSpellId == nSpellId || nEffectSpellId == 1058)
          {
              RemoveEffect(oTarget, eEffect);
          }
      }
      else
      {
          if(nEffectSpellId == 1059)
          {
              return;
          }
          else if(nEffectSpellId == nSpellId)
          {
              RemoveEffect(oTarget, eEffect);
          }
      }

      eEffect = GetNextEffect(oTarget);
  }

  //AntiApilamiento
  AntiStackMoral(oTarget);

  if(nGreater)
  {
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectLinkEffects (EffectLinkEffects (EffectLinkEffects (EffectSavingThrowIncrease(SAVING_THROW_ALL, 4, SAVING_THROW_TYPE_ALL), EffectAttackIncrease(4, ATTACK_BONUS_MISC)), EffectSkillIncrease(SKILL_ALL_SKILLS, 4)), EffectImmunity(IMMUNITY_TYPE_FEAR)), oTarget, fDuration);
      int nTempHP = nCasterLevel;
      if(nCasterLevel > 20)
      {
          nTempHP = 20;
      }

      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectTemporaryHitpoints(nTempHP), oTarget, fDuration);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HOLY_AID), oTarget);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEAD_HOLY), oTarget);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PULSE_HOLY), oTarget);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SUPER_HEROISM), oTarget);
  }

  else
  {
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectLinkEffects (EffectLinkEffects (EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL), EffectAttackIncrease(2, ATTACK_BONUS_MISC)), EffectSkillIncrease(SKILL_ALL_SKILLS, 2)), oTarget, fDuration);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HOLY_AID), oTarget);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEAD_HOLY), oTarget);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PULSE_HOLY), oTarget);
  }

  SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellId, FALSE));
  DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
