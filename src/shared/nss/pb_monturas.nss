//::///////////////////////////////////////////////
//:: EFECTOS DE MONTURAS
//:: Copyright (c) www.puertadebaldur.net
//:://////////////////////////////////////////////
/*
    Regula los efectos de las monturas
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 27/03/2012
//:://////////////////////////////////////////////

#include "mti_libreria"

int ObtenerRangoJineteInt(object oPC)
{
  int iNivelEquitacion = ObtenerIntPersistente(oPC, "NIVELEQUITACION");
  int iRango;
  if(iNivelEquitacion >= 100) iRango = 7;
  else if(iNivelEquitacion >= 90) iRango = 6;
  else if(iNivelEquitacion >= 70) iRango = 5;
  else if(iNivelEquitacion >= 50) iRango = 4;
  else if(iNivelEquitacion >= 25) iRango = 3;
  else if(iNivelEquitacion >= 10) iRango = 2;
  else if(iNivelEquitacion >= 1) iRango = 1;

  return iRango;
}

int ObtenerArmaduraMontura(int iApariencia)
{
  // SIN ARMADURAS
  if((iApariencia >= 496 && iApariencia <= 498) ||
     (iApariencia >= 509 && iApariencia <= 511) ||
     (iApariencia >= 522 && iApariencia <= 524) ||
     (iApariencia >= 535 && iApariencia <= 537) ||
     (iApariencia >= 549 && iApariencia <= 561) ||
     (iApariencia >= 2856 && iApariencia <= 2863) || //1855-1862
     (iApariencia >= 3519 && iApariencia <= 3521) || //2518-2520
     (iApariencia >= 3560 && iApariencia <= 3562) || //2559-2561
     (iApariencia >= 3575 && iApariencia <= 3579) || //2574-2578
     (iApariencia >= 3590 && iApariencia <= 3592) || //2589-2591
     (iApariencia >= 4906 && iApariencia <= 4913) || //3905-3912
      iApariencia == 4915 || iApariencia == 4916 ||  //3914-3915
     (iApariencia >= 4921 && iApariencia <= 4932) || //3920-3931
      iApariencia == 4902 || iApariencia == 204) return 1; //3901

  // ARMADURA DE MALLAS
  else if(iApariencia == 501  || iApariencia == 506  ||
          iApariencia == 514  || iApariencia == 519  ||
          iApariencia == 527  || iApariencia == 532  ||
          iApariencia == 540  || iApariencia == 545  ||
          iApariencia == 3524 || iApariencia == 3529 || //2523-2528
          iApariencia == 3582 || iApariencia == 3587 || //2581-2586
          iApariencia == 3595 || iApariencia == 4903 || //2594-3902
          iApariencia == 4904) return 3; //3903

  // ARMADURA DE ESCAMAS
  else if(iApariencia == 500  || iApariencia == 505   ||
          iApariencia == 513  || iApariencia == 518   ||
          iApariencia == 526  || iApariencia == 531   ||
          iApariencia == 539  || iApariencia == 544   ||
          iApariencia == 3581 || iApariencia == 3586  || //2580-2585
          iApariencia == 3523 || iApariencia == 3528  || //2522-2527
          iApariencia == 3594 || iApariencia == 4914  || //2593-3913
         (iApariencia >= 4917 && iApariencia <= 4920)) return 4; //3916-3919

  // ARMADURA DE CUERO
  return 2;
}

void main()
{
  object oPC = OBJECT_SELF;
  int iAparienciaCaballo = ObtenerIntPersistente(oPC, "CABRESREF2");

  // 5. Bonos/malus del caballo (base + nivel equitacion + nivel montura + armadura + dotes + habilidad ride)
  // 5.1 Base
  effect eDisarmTrap = SupernaturalEffect(EffectSkillDecrease(SKILL_DISABLE_TRAP , 50));
  effect eOpenLock   = SupernaturalEffect(EffectSkillDecrease(SKILL_OPEN_LOCK    , 50));
  effect eHide       = SupernaturalEffect(EffectSkillDecrease(SKILL_HIDE         , 50));
  effect eHide2      = SupernaturalEffect(EffectSkillIncrease(SKILL_HIDE         , 5));
  effect eMove       = SupernaturalEffect(EffectSkillDecrease(SKILL_MOVE_SILENTLY, 50));
  effect eMove2      = SupernaturalEffect(EffectSkillIncrease(SKILL_MOVE_SILENTLY, 5));
  effect ePickPocket = SupernaturalEffect(EffectSkillDecrease(SKILL_PICK_POCKET  , 50));
  effect eSetTrap    = SupernaturalEffect(EffectSkillDecrease(SKILL_SET_TRAP     , 50));
  effect eTumble     = SupernaturalEffect(EffectSkillDecrease(SKILL_TUMBLE       , 50));
  effect eArtesania  = SupernaturalEffect(EffectSkillDecrease(22       , 50));
  effect eEquilibrio = SupernaturalEffect(EffectSkillDecrease(31       , 50));
  effect eEquilibrio2= SupernaturalEffect(EffectSkillIncrease(31       , 5));
  effect eEscapismo  = SupernaturalEffect(EffectSkillDecrease(32       , 50));
  effect eNadar      = SupernaturalEffect(EffectSkillDecrease(25       , 50));
  effect eSaltar     = SupernaturalEffect(EffectSkillDecrease(26       , 50));
  effect eSaltar2    = SupernaturalEffect(EffectSkillIncrease(26       , 5));
  effect eTrepar     = SupernaturalEffect(EffectSkillDecrease(37       , 50));
  effect eTrepar2    = SupernaturalEffect(EffectSkillIncrease(37       , 5));

  if(iAparienciaCaballo == 4923 || iAparienciaCaballo == 4924)//3922-3923
  {
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, eHide2, oPC);
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMove2, oPC);
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEquilibrio2, oPC);
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, eTrepar2, oPC);
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSaltar2, oPC);
  }
  else
  {
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, eHide, oPC);
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMove, oPC);
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEquilibrio, oPC);
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, eTrepar, oPC);
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSaltar, oPC);
  }

  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDisarmTrap, oPC);
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eOpenLock, oPC);
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePickPocket, oPC);
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSetTrap, oPC);
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eTumble, oPC);
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eArtesania, oPC);
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEscapismo, oPC);
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eNadar, oPC);

  // 5.2 Nivel equitacion
  int iNivelEquitacion = ObtenerIntPersistente(oPC, "NIVELEQUITACION");
  int iCalculoFalloConjuro =  90 - (iNivelEquitacion * 2);
  int iCalculoConcentracion = 20 - (iNivelEquitacion / 2);
  int iCalculoReflejos = 3 - (ObtenerRangoJineteInt(oPC) - 1);
  int iCalculoAtaque =   2 - (ObtenerRangoJineteInt(oPC) - 1);
  effect eFalloConjuro = SupernaturalEffect(EffectSpellFailure(iCalculoFalloConjuro));
  effect eConcentracion = SupernaturalEffect(EffectSkillDecrease(SKILL_CONCENTRATION, iCalculoConcentracion));
  effect eReflejos = SupernaturalEffect(EffectSavingThrowDecrease(SAVING_THROW_REFLEX, iCalculoReflejos));
  effect eAtaquePen = SupernaturalEffect(EffectAttackDecrease(iCalculoAtaque));
  effect eAtaqueBon = SupernaturalEffect(EffectAttackIncrease(abs(iCalculoAtaque)));
  if(iCalculoFalloConjuro > 0) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFalloConjuro, oPC);
  if(iCalculoConcentracion > 0) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eConcentracion, oPC);
  if(iCalculoReflejos > 0) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eReflejos, oPC);
  if(iCalculoAtaque > 0) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAtaquePen, oPC);
  else if(iCalculoAtaque < 0) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAtaqueBon, oPC);

  // 5.3 Nivel montura
  int iConMontura = GetLocalInt(oPC, "CAB_CON_MONTURA");
  effect eCon = SupernaturalEffect(EffectAbilityIncrease(ABILITY_CONSTITUTION, iConMontura));
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCon, oPC);

  // 5.4 Armadura del caballo
  int iArmaduraMontura = ObtenerArmaduraMontura(iAparienciaCaballo);
  int iPorcentageImmu, iVelocidad, iPenalizadorVelocidad, iCalculoVelocidad;
  if(iArmaduraMontura == 1) {iPorcentageImmu = 0; iVelocidad = 30;}
  else if(iArmaduraMontura == 2) {iPorcentageImmu = 3; iVelocidad = 25;}
  else if(iArmaduraMontura == 3) {iPorcentageImmu = 6; iVelocidad = 15;}
  else if(iArmaduraMontura == 4) {iPorcentageImmu = 12; iVelocidad = 5;}
  effect eImmuContundente = SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, iPorcentageImmu));
  effect eImmuPerforante = SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING, iPorcentageImmu));
  effect eImmuCortante = SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, iPorcentageImmu));

  if(iPorcentageImmu > 0)
  {
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImmuContundente, oPC);
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImmuPerforante, oPC);
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImmuCortante, oPC);
  }

  int iNivelMonje = GetLevelByClass(CLASS_TYPE_MONK, oPC);
  int iNivelBarbaro = GetLevelByClass(CLASS_TYPE_BARBARIAN, oPC);
  if(iNivelMonje > 2)   iPenalizadorVelocidad = iPenalizadorVelocidad + (10 * (iNivelMonje / 3));
  if(iNivelBarbaro > 0) iPenalizadorVelocidad = iPenalizadorVelocidad + 10;

  iCalculoVelocidad = iVelocidad - iPenalizadorVelocidad + GetHitDice(OBJECT_SELF); // Un detalle del nivel de la montura tambien
  if(iCalculoVelocidad > 0)
  {
      effect eVelocidad = SupernaturalEffect(EffectMovementSpeedIncrease(iCalculoVelocidad));
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVelocidad, oPC);
  }
  else if(iCalculoVelocidad < 0)
  {
      effect eNoVelocidad = SupernaturalEffect(EffectMovementSpeedDecrease(abs(iCalculoVelocidad)));
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, eNoVelocidad, oPC);
  }

  // 5.5 Dotes
  effect eMenos2CA = SupernaturalEffect(EffectACDecrease(2));
  effect e2Destreza = SupernaturalEffect(EffectAbilityIncrease(ABILITY_DEXTERITY, 2));
  if(GetHasFeat(FEAT_MOUNTED_COMBAT, oPC) == FALSE) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMenos2CA, oPC);
  if(GetHasFeat(FEAT_MOUNTED_ARCHERY, oPC) == TRUE) ApplyEffectToObject(DURATION_TYPE_PERMANENT, e2Destreza, oPC);

  // 5.6 Habilidad montar
  int iRide = GetSkillRank(SKILL_RIDE, oPC);
  if(iRide > 3)
  {
      int iDanyo;
      if(iRide >= 2 && iRide <= 8) iDanyo = DAMAGE_BONUS_1;
      else if(iRide >= 9 && iRide <= 14) iDanyo = DAMAGE_BONUS_2;
      else if(iRide >= 15 && iRide <= 20) iDanyo = DAMAGE_BONUS_3;
      else if(iRide >= 21 && iRide <= 26) iDanyo = DAMAGE_BONUS_4;
      else if(iRide >= 27 && iRide <= 32) iDanyo = DAMAGE_BONUS_5;
      else if(iRide >= 33 && iRide <= 38) iDanyo = DAMAGE_BONUS_6;
      else iDanyo = DAMAGE_BONUS_8;
      effect eDanyoAumentado = SupernaturalEffect(EffectDamageIncrease(iDanyo, DAMAGE_TYPE_BLUDGEONING));
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDanyoAumentado, oPC);
  }
}


