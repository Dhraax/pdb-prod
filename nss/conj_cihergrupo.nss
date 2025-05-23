//::///////////////////////////////////////////////
//:: CURAR / INFLIGIR HERIDAS EN GRUPO
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Curar heridas leves en grupo.
    Curar heridas moderadas grupo.
    Curar heridas graves en grupo.
    Curar heridas criticas en grupo.
    Infligir heridas leves en grupo.
    Infligir heridas moderadas grupo.
    Infligir heridas graves en grupo.
    Infligir heridas criticas en grupo.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 31 de Mayo de 2010
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "x0_i0_spells"
#include "pb_nivellanzador"
#include "colors_inc"

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
  location lTarget = GetSpellTargetLocation();
  int nCasterLevel = GetTotalCasterLevel(oCaster);
  int nSpellId = GetSpellId();
  int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
  int nVfxAoe;
  int nVfxHeal;
  int nVfxHarm;
  int nHealing;
  int nDice;
  int nMax;
  int nHeal;

  switch(nSpellId)
  {
      case 1050: nVfxAoe = 1260; nVfxHeal = VFX_IMP_HEALING_S; nVfxHarm = VFX_IMP_SUNSTRIKE; nDice = 1; nMax = 25; nHeal = TRUE; break;//Mass_Cure_Light_Wounds
      case 1051: nVfxAoe = 1260; nVfxHeal = VFX_IMP_HEALING_M; nVfxHarm = VFX_IMP_SUNSTRIKE; nDice = 2; nMax = 30; nHeal = TRUE; break;//Mass_Cure_Moderate_Wounds
      case 1052: nVfxAoe = 1260; nVfxHeal = VFX_IMP_HEALING_L; nVfxHarm = VFX_IMP_SUNSTRIKE; nDice = 3; nMax = 35; nHeal = TRUE; break;//Mass_Cure_Serious_Wounds
      case 1053: nVfxAoe = 1260; nVfxHeal = VFX_IMP_HEALING_G; nVfxHarm = VFX_IMP_SUNSTRIKE; nDice = 4; nMax = 40; nHeal = TRUE; break;//Mass_Cure_Critical_Wounds
      case 1054: nVfxAoe = 1261; nVfxHeal = VFX_IMP_HEALING_S; nVfxHarm = VFX_IMP_HARM; nDice = 1; nMax = 25; nHeal = FALSE; break;//Mass_Inflict_Light_Wounds
      case 1055: nVfxAoe = 1261; nVfxHeal = VFX_IMP_HEALING_M; nVfxHarm = VFX_IMP_HARM; nDice = 2; nMax = 30; nHeal = FALSE; break;//Mass_Inflict_Moderate_Wounds
      case 1056: nVfxAoe = 1261; nVfxHeal = VFX_IMP_HEALING_L; nVfxHarm = VFX_IMP_HARM; nDice = 3; nMax = 35; nHeal = FALSE; break;//Mass_Inflict_Serious_Wounds
      case 1057: nVfxAoe = 1261; nVfxHeal = VFX_IMP_HEALING_G; nVfxHarm = VFX_IMP_HARM; nDice = 4; nMax = 40; nHeal = FALSE; break;//Mass_Inflict_Critical_Wounds
  }

  if(nCasterLevel > nMax)
  {
      nCasterLevel = nMax;
  }

  ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(nVfxAoe), lTarget);
  object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
  while(GetIsObjectValid(oTarget))
  {
      int nDmg = d8(nDice) + nCasterLevel;
      if(nMetaMagic == METAMAGIC_EMPOWER || GetHasFeat(FEAT_HEALING_DOMAIN_POWER))
      {
          if(GetHasFeat(FEAT_HEALING_DOMAIN_POWER)) SendMessageToPC(OBJECT_SELF, ColorToken(254,254,254) + "Dominio de Curación: +"+IntToString(nDmg / 2)+" pg.</c>");

          nDmg = nDmg + (nDmg / 2);
      }
      if(nMetaMagic == METAMAGIC_MAXIMIZE)
      {
          nDmg = (8 * nDice) + nCasterLevel;
      }
      if(nHeal && GetHasFeat(1121)) // Curacion aumentada
      {
          int iNivelInnato = StringToInt(Get2DAString("spells", "Innate", nSpellId));

          nDmg = nDmg + ( iNivelInnato * 2);

          SendMessageToPC(OBJECT_SELF, ColorToken(254,254,254) + "Curación aumentada: +"+IntToString(iNivelInnato * 2)+" pg.</c>");
      }


      float fDelay = GetRandomDelay(0.1, 1.0);
      if (PB_Race_GetIsUndead(oTarget))
      {
          if (nHeal)
          {
              if (!ResistSpell(oCaster, oTarget))
              {
                  DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nVfxHarm), oTarget));
                  SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellId, TRUE));

                  if(!WillSave(oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(OBJECT_SELF)), SAVING_THROW_TYPE_POSITIVE, oCaster))
                  {
                      DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDmg, DAMAGE_TYPE_POSITIVE), oTarget));
                  }
                  else
                  {
                      DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDmg / 2, DAMAGE_TYPE_POSITIVE), oTarget));
                  }
              }
              else
              {
                  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE), oTarget);
              }
          }
          else
          {
              SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellId, FALSE));
              DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nDmg), oTarget));
              DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nVfxHeal), oTarget));
          }
      }
      else
      {
          if(nHeal && !GetIsReactionTypeHostile(oCaster, oTarget))
          {
              SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellId, FALSE));
              DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nDmg), oTarget));
              DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nVfxHeal), oTarget));
          }
          if(!nHeal && GetIsReactionTypeHostile(oCaster, oTarget))
          {
              if(!ResistSpell(oCaster, oTarget))
              {
                  SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellId, TRUE));
                  DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nVfxHarm), oTarget));

                  if(!WillSave(oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(OBJECT_SELF)), SAVING_THROW_TYPE_NEGATIVE, oCaster))
                  {
                      DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDmg, DAMAGE_TYPE_NEGATIVE), oTarget));
                  }
                  else
                  {
                      DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDmg / 2, DAMAGE_TYPE_NEGATIVE), oTarget));
                  }
              }
              else
              {
                  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE), oTarget);
              }
          }
      }

      oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
      DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
  }
}
