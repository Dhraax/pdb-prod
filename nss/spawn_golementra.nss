#include "x0_inc_henai"
void main()
{
  effect eVida = EffectDamage(150);
  object oMaster = GetMaster(OBJECT_SELF);
  int iLividez = GetLevelByClass(CLASS_TYPE_PALEMASTER,oMaster);
  int iNiveles = GetLocalInt(oMaster,"Nivelentranyas");

  effect eAC = EffectACIncrease(iLividez);
  effect eSTR = EffectAbilityIncrease(ABILITY_STRENGTH,iLividez);
  effect eSTR2 = EffectAbilityIncrease(ABILITY_STRENGTH,iNiveles/2);
  effect eSTI = EffectSavingThrowIncrease(SAVING_THROW_FORT,iNiveles/2);
  ApplyEffectToObject(DURATION_TYPE_PERMANENT,eVida,OBJECT_SELF);
  ApplyEffectToObject(DURATION_TYPE_PERMANENT,eAC,OBJECT_SELF);
  ApplyEffectToObject(DURATION_TYPE_PERMANENT,eSTR,OBJECT_SELF);
  ApplyEffectToObject(DURATION_TYPE_PERMANENT,eSTR2,OBJECT_SELF);
  ApplyEffectToObject(DURATION_TYPE_PERMANENT,eSTI,OBJECT_SELF);
  AssignCommand(OBJECT_SELF, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 0.0,2.0));

  SetAssociateState(NW_ASC_DISTANCE_2_METERS);
}
