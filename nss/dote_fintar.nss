//::///////////////////////////////////////////////
//:: DOTE FINTA Y FINTA MEJORADA
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Dote Finta y Finta Mejorada.
*/
//:://////////////////////////////////////////////
//:: Created By: Delom y Monti
//:: Created On: 1 de Octubre de 2011
//:://////////////////////////////////////////////

#include "x0_i0_spells"
#include "zep_inc_armas"

void main()
{
  object oPC = OBJECT_SELF;
  object oObjetivo = GetSpellTargetObject();
  location lLugarObjetivo = GetItemActivatedTargetLocation();

  // Antisaturamiento
  if(GetLocalInt(oPC, "FINTA_NOSATURAR"))
  {
      FloatingTextStringOnCreature("<cþ<<>* No puedes fintar otra vez tan rápidamente *</c>", oPC, FALSE);
      return;
  }

  // Solo a criaturas
  if(GetObjectType(oObjetivo) != OBJECT_TYPE_CREATURE)
  {
      FloatingTextStringOnCreature("<cþ<<>* Sólo puedes fintar a criaturas *</c>", oPC, FALSE);
      return;
  }

  // Solo se finta a los cercanos
  if(GetDistanceBetween(oPC, oObjetivo) > 4.0)
  {
      FloatingTextStringOnCreature("<cþ<<>* Estás demasiado lejos para fintar a esa criatura *</c>", oPC, FALSE);
      return;
  }

  // Si no nos esta atacando nanay
  if(GetAttackTarget(oObjetivo) != oPC)
  {
      FloatingTextStringOnCreature("<cþ<<>* No puedes fintar a una critura que no te ataca *</c>", oPC, FALSE);
      return;
  }
  // Con efectos dayninos no puedes usarla
  int iFalloDote = FALSE;
  if(GetIsResting(oPC) || GetLocalInt(oPC, "DERRIBADO") || GetLocalInt(oPC, "SLIDING")) iFalloDote = TRUE;

  effect eEfecto = GetFirstEffect(oPC);
  while(GetIsEffectValid(eEfecto))
  {
      if(GetEffectType(eEfecto) == EFFECT_TYPE_CHARMED ||           GetEffectType(eEfecto) == EFFECT_TYPE_CONFUSED ||
         GetEffectType(eEfecto) == EFFECT_TYPE_CUTSCENE_PARALYZE || GetEffectType(eEfecto) == EFFECT_TYPE_CUTSCENEIMMOBILIZE ||
         GetEffectType(eEfecto) == EFFECT_TYPE_DAZED ||             GetEffectType(eEfecto) == EFFECT_TYPE_DOMINATED ||
         GetEffectType(eEfecto) == EFFECT_TYPE_ENTANGLE ||          GetEffectType(eEfecto) == EFFECT_TYPE_FRIGHTENED ||
         GetEffectType(eEfecto) == EFFECT_TYPE_PARALYZE ||          GetEffectType(eEfecto) == EFFECT_TYPE_PETRIFY ||
         GetEffectType(eEfecto) == EFFECT_TYPE_SLEEP ||             GetEffectType(eEfecto) == EFFECT_TYPE_STUNNED) iFalloDote = TRUE;

      eEfecto = GetNextEffect(oPC);
  }

  if(iFalloDote == TRUE)
  {
      FloatingTextStringOnCreature("<cþ<<>* En tu estado no puedes usar la finta *</c>", OBJECT_SELF, FALSE);
      return;
  }

  // Calculo tirada
  int iBonusInteligenciaDefensor = 0;
  int iBonoFintaMejorada = 0;
  int iInteligenciaObjetivo = GetAbilityScore(oObjetivo, ABILITY_INTELLIGENCE);
  if(iInteligenciaObjetivo <= 3) iBonusInteligenciaDefensor = 4;
  else if(iInteligenciaObjetivo < 10) iBonusInteligenciaDefensor = 8;
  if(GetHasFeat(1229, oPC)) iBonoFintaMejorada = 4;

  int iTirada = d20() + GetSkillRank(SKILL_BLUFF, oPC) + iBonoFintaMejorada;
  int iCD = d20() + GetSkillRank(28, oObjetivo) + GetBaseAttackBonus(oObjetivo) + iBonusInteligenciaDefensor;

  AssignCommand(oPC, SetFacingPoint(GetPosition(oObjetivo)));
//  DelayCommand(0.1, AssignCommand(oPC, PlayAnimation(ANIMATION_FIREFORGET_STEAL)));
//  DelayCommand(1.9, AssignCommand(oPC, ClearAllActions(TRUE)));
  DelayCommand(0.1, AssignCommand(oPC, ActionAttack(oObjetivo)));

  if(iTirada > iCD)
  {

      if(GetHasSpellEffect(986, oObjetivo)) // Se disipa esquiva asombrosa mejorada si tiene
      {
          DelayCommand(1.5, RemoveEffectsFromSpell(oObjetivo, 986));
          if(GetIsPC(oObjetivo)) DelayCommand(1.5, FloatingTextStringOnCreature("<cþ<<>* Modo Esquiva asombrosa mejorada desactivado *</c>", oObjetivo, FALSE));
      }

      //tras usar la finta, van a tener solo un ataque furtivo, reducimos temporalmetne su numero de ataques.
      int numAtaqReducir = 0;
      int numAtaques = GetBaseAttackBonus(oPC);
      if(GetLevelByClass(CLASS_TYPE_MONK, oPC) > 0 ){ //los monjes ganan 1 ataque cada multiplo de 3
          if(numAtaques<=3) numAtaqReducir=0;
          if(numAtaques<=6) numAtaqReducir=-1;
          if(numAtaques<=9) numAtaqReducir=-2;
          if(numAtaques<=12) numAtaqReducir=-3;
          if(numAtaques<=15) numAtaqReducir=-4;
          if(numAtaques<=18) numAtaqReducir=-5;
      }else{                                          //el resto de clases cada 5
          if(numAtaques<=5) numAtaqReducir=0;
          if(numAtaques<=10) numAtaqReducir=-1;
          if(numAtaques<=15) numAtaqReducir=-2;
          if(numAtaques<=20) numAtaqReducir=-3;
      }

      //ataques en mano torpe tambien se reducen
      if(VerSiEsArmaCuerpoACuerpo(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC))){
         if(GetHasFeat(FEAT_IMPROVED_TWO_WEAPON_FIGHTING, oPC) ) numAtaqReducir--;
         if(GetHasFeat(1202, oPC) ) numAtaqReducir--;
      }

      if(GetHasFeat(1229, oPC)){
          DelayCommand(0.1, FloatingTextStringOnCreature("<c´þd>* Finta: "+IntToString(iTirada)+" vs CD "+IntToString(iCD)+": éxito *</c>", oPC, FALSE));
          if(GetIsPC(oObjetivo)) DelayCommand(0.1, FloatingTextStringOnCreature("<cþ<<>* No resistes un intento de finta: "+IntToString(iCD)+" vs CD "+IntToString(iTirada)+": fracaso *</c>", oObjetivo, FALSE));
          ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectModifyAttacks(numAtaqReducir) , oPC, 6.0);
          DelayCommand(0.1, AssignCommand(oObjetivo, ClearAllActions(TRUE)));
          DelayCommand(0.2, AssignCommand(oObjetivo, PlayAnimation(ANIMATION_FIREFORGET_STEAL)));
          DelayCommand(2.0, AssignCommand(oObjetivo, ActionAttack(oPC)));
          if(GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC) > 0 ) ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectImmunity(IMMUNITY_TYPE_PARALYSIS), oObjetivo, 2.0);

      }else{   // tiene un retraso de 6 segundos al usarse "al momento" la finta normal, aunque deberia tardar un asalto, si se corrige en el 2da no hace falta dicho retraso, pues ya lo hace el motor.
          DelayCommand(6.1, FloatingTextStringOnCreature("<c´þd>* Finta: "+IntToString(iTirada)+" vs CD "+IntToString(iCD)+": éxito *</c>", oPC, FALSE));
          if(GetIsPC(oObjetivo)) DelayCommand(6.1, FloatingTextStringOnCreature("<cþ<<>* No resistes un intento de finta: "+IntToString(iCD)+" vs CD "+IntToString(iTirada)+": fracaso *</c>", oObjetivo, FALSE));
          ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectModifyAttacks(numAtaqReducir) , oPC, 12.0) ;
          DelayCommand(6.0, AssignCommand(oObjetivo, ClearAllActions(TRUE)));
          DelayCommand(6.1, AssignCommand(oObjetivo, PlayAnimation(ANIMATION_FIREFORGET_STEAL)));
          DelayCommand(8.2, AssignCommand(oObjetivo, ActionAttack(oPC)));
          if(GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC) > 0 ) ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectImmunity(IMMUNITY_TYPE_PARALYSIS), oObjetivo, 2.0);
      }
  }
  else
  {
      DelayCommand(0.1, FloatingTextStringOnCreature("<cþ<<>* Finta: "+IntToString(iTirada)+" vs CD "+IntToString(iCD)+": fracaso *</c>", oPC));
      if(GetIsPC(oObjetivo)) DelayCommand(0.1, FloatingTextStringOnCreature("<c´þd>* Resistes un intento de finta: "+IntToString(iCD)+" vs CD "+IntToString(iTirada)+": éxito *</c>", oObjetivo));
  }

  SetLocalInt(oPC, "FINTA_NOSATURAR", TRUE);
  DelayCommand(6.0, DeleteLocalInt(oPC, "FINTA_NOSATURAR"));
}
