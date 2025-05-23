//::///////////////////////////////////////////////
//:: EFECTOS DE LA SUBRAZA VAMPIRO
//:: Copyright (c) www.puertadebaldur.net
//:://////////////////////////////////////////////
/*
    Regula los efectos de la subraza vampiro, que va aparte
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 27/03/2012
//:://////////////////////////////////////////////

#include "f_vampire_h"
#include "x2_inc_itemprop"
#include "lib_race"

void main()
{
  object oPC = OBJECT_SELF;
  int iHD = Determine_Vampire_Level(oPC);
  int iStatMod = (iHD / 5) + 1;

  effect eVision = SupernaturalEffect(EffectVisualEffect(244));
  effect eIDisease = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_DISEASE));
  effect eIPoison = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_POISON));
  effect eIDeathSpells = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_DEATH));
  effect eISneakAttack = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK));
  effect eINegative = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL));
  effect eICriticalHit = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT));
  effect eImmuReduccionCaracteristica = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE));
  effect eImmuConjurosEnajenadores = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS));
  effect eImmuParalisis = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_PARALYSIS));
  effect eFireWeakness = SupernaturalEffect(EffectDamageImmunityDecrease(DAMAGE_TYPE_FIRE, (70 - iHD)));
  effect eDivineWeakness = SupernaturalEffect(EffectDamageImmunityDecrease(DAMAGE_TYPE_DIVINE, (90 - iHD)));
  effect eColdResist = SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 20));
  effect eNegativeResist = SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE, (80 + iHD)));

  effect eNegDamage;

  effect eDamageResist = SupernaturalEffect(EffectDamageReduction(5, DAMAGE_POWER_NORMAL));
  effect eTemp; //for epic and other effects

  Vampire_Delete_Int(oPC, "FALLEN_VAMPIRE_MIST");

  if(iHD > 0)
  { //no strengths if you are at a negative vampire level!
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, eColdResist, oPC);
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, eNegativeResist, oPC);
  }

  if(iHD >= UltravisionLevel) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVision, oPC);
  if(iHD >= ImmuneDeathLevel) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eIDeathSpells, oPC);
  if(iHD >= ImmuneNegLvlLevel) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eINegative, oPC);
  if(iHD >= ImmuneDiseaseLevel) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eIDisease, oPC);
  if(iHD >= ImmunePoisonLevel) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eIPoison, oPC);
  if(iHD >= ImmuneSnkAttkLevel) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eISneakAttack, oPC);
  if(iHD >= ImmuneCrtHitLevel) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eICriticalHit, oPC);
  if(iHD >= ImmuneDmgResistLevel) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDamageResist, oPC);
  if(iHD >= InmuneReducionCaracteristica) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImmuReduccionCaracteristica, oPC);
  if(iHD >= InmuneConjurosEnajenadores) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImmuConjurosEnajenadores, oPC);
  if(iHD >= InmuneParalisis) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImmuParalisis, oPC);

  //Regeneracion Vampirica
  if(iHD >= 1 && iHD<41)
  {
      eTemp = SupernaturalEffect(EffectRegenerate(5, 6.0));
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, eTemp, oPC);
  }

  ////////////// End Epic
  if(!UseAuraItem) Vampire_Apply_Aura(oPC);

  //Resistencia a Expulsar +4
  eTemp = SupernaturalEffect(EffectTurnResistanceIncrease(4));
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eTemp, oPC);

  //Aumento +8 a las Habilidades
  //Avistar
  eTemp = SupernaturalEffect(EffectSkillIncrease(SKILL_SPOT,8));
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eTemp, oPC);

  //Esconderse
  eTemp = SupernaturalEffect(EffectSkillIncrease(SKILL_HIDE,8));
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eTemp, oPC);

  //Moverse Siguilosamente
  eTemp = SupernaturalEffect(EffectSkillIncrease(SKILL_MOVE_SILENTLY,8));
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eTemp, oPC);

  //Buscar
  eTemp = SupernaturalEffect(EffectSkillIncrease(SKILL_SEARCH,8));
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eTemp, oPC);

  //Enganar
  eTemp = SupernaturalEffect(EffectSkillIncrease(SKILL_BLUFF,8));
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eTemp, oPC);

  //Escuchar
  eTemp = SupernaturalEffect(EffectSkillIncrease(SKILL_LISTEN,8));
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eTemp, oPC);

  //Averiguar Intenciones
  eTemp = SupernaturalEffect(EffectSkillIncrease(28,8));
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eTemp, oPC);

  if(GetHasFeat(FEAT_WEAPON_PROFICIENCY_CREATURE,oPC)==TRUE)
  {
      object oItem2 =  GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC);
      if(oItem2==OBJECT_INVALID && GetAppearanceType(oPC)!=10)
      {
          if(GetAppearanceType(oPC)<=6)
          {
              oItem2=CreateItemOnObject("asy_mordiscovampiro",oPC,1);
              SetIdentified(oItem2, TRUE);
              itemproperty ipAdd = ItemPropertyMonsterDamage(IP_CONST_MONSTERDAMAGE_1d6);
              DelayCommand(0.1,AssignCommand(oPC, ClearAllActions(TRUE)));

              if((GetClassByPosition(1,oPC)==CLASS_TYPE_MONK) || (GetClassByPosition(2,oPC)==CLASS_TYPE_MONK) ||(GetClassByPosition(3,oPC)==CLASS_TYPE_MONK))
              {
                  int iNivelMonje = GetLevelByClass(CLASS_TYPE_MONK,oPC);
                  if (PB_Race_GetIsHalfling(oPC) || GetRacialType(oPC)==RACIAL_TYPE_GNOME)
                  {
                      if(iNivelMonje>=8 && iNivelMonje<12)ipAdd = ItemPropertyMonsterDamage(IP_CONST_MONSTERDAMAGE_1d8);
                      if(iNivelMonje>=12 && iNivelMonje<16)ipAdd = ItemPropertyMonsterDamage(IP_CONST_MONSTERDAMAGE_1d10);
                      if(iNivelMonje>=16 && iNivelMonje<40)ipAdd = ItemPropertyMonsterDamage(IP_CONST_MONSTERDAMAGE_1d12);
                  }
                  else
                  {
                      if(iNivelMonje>=4 && iNivelMonje<8)ipAdd = ItemPropertyMonsterDamage(IP_CONST_MONSTERDAMAGE_1d8);
                      if(iNivelMonje>=8 && iNivelMonje<12)ipAdd = ItemPropertyMonsterDamage(IP_CONST_MONSTERDAMAGE_1d10);
                      if(iNivelMonje>=12 && iNivelMonje<16)ipAdd = ItemPropertyMonsterDamage(IP_CONST_MONSTERDAMAGE_1d12);
                      if(iNivelMonje>=16 && iNivelMonje<40)ipAdd = ItemPropertyMonsterDamage(IP_CONST_MONSTERDAMAGE_1d20);
                  }

                  IPSafeAddItemProperty(oItem2, ipAdd);
                  object oGuantes = GetItemInSlot(INVENTORY_SLOT_ARMS, oPC);
                  if (oGuantes!=OBJECT_INVALID)
                  {
                      itemproperty iprop = GetFirstItemProperty(oGuantes);
                      while(GetIsItemPropertyValid(iprop))
                      {
                          IPSafeAddItemProperty(oItem2, iprop);
                          /*if (GetItemPropertyType(iprop)==ITEM_PROPERTY_DAMAGE_BONUS)
                          {
                              IPSafeAddItemProperty(oItem2, iprop);
                          } */
                          iprop =GetNextItemProperty(oGuantes);
                      }
                  }
              }
              else IPSafeAddItemProperty(oItem2, ipAdd);
          }

          if(GetAppearanceType(oPC)==386) oItem2=CreateItemOnObject("NW_IT_CREWPS014",oPC,1);
          if(GetAppearanceType(oPC)==387) oItem2=CreateItemOnObject("NW_IT_CREWPS033",oPC,1);
          if(GetAppearanceType(oPC)==181) oItem2=CreateItemOnObject("NW_IT_CREWPS005",oPC,1);
          if(GetAppearanceType(oPC)==175) oItem2=CreateItemOnObject("NW_IT_CREWPS010",oPC,1);

          SetIdentified(oItem2, TRUE);
          DelayCommand(0.1,AssignCommand(oPC, ClearAllActions(TRUE)));
          DelayCommand(0.3,AssignCommand(oPC, ActionDoCommand(ActionEquipItem(oItem2, INVENTORY_SLOT_CWEAPON_B))));
      }
  }

  //Ca +6
  effect eMasSeisCAArmadura = SupernaturalEffect(EffectACIncrease(6, AC_NATURAL_BONUS));
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMasSeisCAArmadura, oPC);

  //Aumentado el Dano por energia Negativa al golpear con cualquier arma. Esto viene por ser no muerto.
  //Dano aumenta segun el nivel del No muerto.
  if(iHD >= NegDmg2d12Level) eNegDamage = SupernaturalEffect(EffectDamageIncrease(DAMAGE_BONUS_2d12, DAMAGE_TYPE_NEGATIVE));
  else if(iHD >= NegDmg2d10Level) eNegDamage = SupernaturalEffect(EffectDamageIncrease(DAMAGE_BONUS_2d10, DAMAGE_TYPE_NEGATIVE));
  else if(iHD >= NegDmg2d8Level) eNegDamage = SupernaturalEffect(EffectDamageIncrease(DAMAGE_BONUS_2d8, DAMAGE_TYPE_NEGATIVE));
  else if(iHD >= NegDmg2d6Level) eNegDamage = SupernaturalEffect(EffectDamageIncrease(DAMAGE_BONUS_2d6, DAMAGE_TYPE_NEGATIVE));
  else if(iHD >= NegDmg1d10Level) eNegDamage = SupernaturalEffect(EffectDamageIncrease(DAMAGE_BONUS_1d10, DAMAGE_TYPE_NEGATIVE));
  else if(iHD >= NegDmg1d8Level) eNegDamage = SupernaturalEffect(EffectDamageIncrease(DAMAGE_BONUS_1d8, DAMAGE_TYPE_NEGATIVE));
  else if(iHD >= NegDmg1d6Level) eNegDamage = SupernaturalEffect(EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_NEGATIVE));
  else if(iHD >= NegDmg1d4Level) eNegDamage = SupernaturalEffect(EffectDamageIncrease(DAMAGE_BONUS_1d4, DAMAGE_TYPE_NEGATIVE));
  else if(iHD >= NegDmg2Level) eNegDamage = SupernaturalEffect(EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_NEGATIVE));
  else if(iHD >= NegDmg1Level) eNegDamage = SupernaturalEffect(EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_NEGATIVE));
  else return; //nothing to apply...

  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eNegDamage, oPC);
  //Indicar que ya se le ha dado los efectos de al subrazas.

}
