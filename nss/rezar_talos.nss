#include "pb_oraciones"
void main()
{
  object oPC = GetLastUsedBy();

  int iUnaVez = Rezar_Dios(oPC);
  if(iUnaVez == TRUE)
  {
      SendMessageToPC(oPC, "Ya he rezado una vez.. probaré más tarde.");
      return;
  }

int iAli1 = GetAlignmentLawChaos(oPC);
int iAli2 = GetAlignmentGoodEvil(oPC);
if(iAli1 == ALIGNMENT_CHAOTIC && iAli2 == ALIGNMENT_EVIL ||  //Caotico maligno
    iAli1 == ALIGNMENT_NEUTRAL && iAli2 == ALIGNMENT_EVIL ||   //neutral maligno x
    iAli1 == ALIGNMENT_CHAOTIC && iAli2 == ALIGNMENT_NEUTRAL)   //caotico neutral x
{

  SetLocalInt(oPC, "REZARTALOS", 1);
  DelayCommand(1440.0, DeleteLocalInt(oPC, "REZARTALOS"));

  SetCutsceneMode(oPC, TRUE);
  DelayCommand(20.0, SetCutsceneMode(oPC, FALSE));

  SetCameraMode(oPC, CAMERA_MODE_STIFF_CHASE_CAMERA);
  SetCutsceneCameraMoveRate(oPC, 0.1);

  AssignCommand(oPC, ActionDoCommand(SetFacingPoint(GetPositionFromLocation(GetLocation(OBJECT_SELF)))));
  AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE, 1.0, 20.0));

  int iProb = d100();
  int iSab = GetAbilityModifier(ABILITY_WISDOM, oPC);
  if(iProb <= 25 + iSab)
  {

      effect eEfecto2 = EffectVisualEffect(VFX_IMP_LIGHTNING_M);
      effect eEfecto4 = EffectSavingThrowIncrease(SAVING_THROW_ALL,d4(1),SAVING_THROW_TYPE_LAW);
      effect eEfecto3 = EffectSavingThrowIncrease(SAVING_THROW_ALL,d4(1),SAVING_THROW_TYPE_ELECTRICITY);
      DelayCommand(20.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto2, oPC));
      DelayCommand(20.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEfecto4, oPC, 1000.0));
      DelayCommand(20.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEfecto3, oPC, 1000.0));
      DelayCommand(20.0, FloatingTextStringOnCreature("*¡Talos te ha bendecido!*", oPC, FALSE));
      GiveXPToCreature(oPC,100);
      return;
  }
  else
  {
      DelayCommand(20.0, FloatingTextStringOnCreature("*Tus rezos no han llegado a Talos.*", oPC, FALSE));
      GiveXPToCreature(oPC,10);
      return;
  }
  }
  else
  {
  FloatingTextStringOnCreature("*Tu alineamiento no te permite rezar a Talos.*", oPC, FALSE);
    }
}
