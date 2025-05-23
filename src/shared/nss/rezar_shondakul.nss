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
if(iAli1 == ALIGNMENT_CHAOTIC && iAli2 == ALIGNMENT_NEUTRAL ||  //c neutral
    iAli1 == ALIGNMENT_CHAOTIC && iAli2 == ALIGNMENT_EVIL ||   //c maligno x
    iAli1 == ALIGNMENT_CHAOTIC && iAli2 == ALIGNMENT_GOOD||    //cb
    iAli1 == ALIGNMENT_NEUTRAL && iAli2 == ALIGNMENT_NEUTRAL || //nn
    iAli1 == ALIGNMENT_NEUTRAL && iAli2 == ALIGNMENT_EVIL ||    //nm
    iAli1 == ALIGNMENT_NEUTRAL && iAli2 == ALIGNMENT_GOOD)  //nb
{

  SetLocalInt(oPC, "REZARSHONDA", 1);
  DelayCommand(1440.0, DeleteLocalInt(oPC, "REZARSHONDA"));

  DelayCommand(1.0,SetCutsceneMode(oPC, TRUE));
  DelayCommand(21.0, SetCutsceneMode(oPC, FALSE));

  DelayCommand(1.0,SetCameraMode(oPC, CAMERA_MODE_STIFF_CHASE_CAMERA));
  DelayCommand(1.0,SetCutsceneCameraMoveRate(oPC, 0.1));

  DelayCommand(1.0,AssignCommand(oPC, ActionDoCommand(SetFacingPoint(GetPositionFromLocation(GetLocation(OBJECT_SELF))))));
  DelayCommand(1.0,AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE, 1.0, 20.0)));

  int iProb = d100();
  int iSab = GetAbilityModifier(ABILITY_WISDOM, oPC);
  if(iProb <= 25 + iSab)
  {

      effect eEfecto2 = EffectVisualEffect(21);;
      effect eEfecto3 = EffectMovementSpeedIncrease(70);
      DelayCommand(21.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto2, oPC));
      DelayCommand(21.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEfecto3, oPC, 330.0));
      DelayCommand(21.0, FloatingTextStringOnCreature("*¡Shondakul te ha bendecido!*", oPC, FALSE));
      DelayCommand(1.5,GiveXPToCreature(oPC,100));
      return;
  }
  else
  {
      DelayCommand(21.0, FloatingTextStringOnCreature("*Tus rezos no han llegado a Shondakul.*", oPC, FALSE));
      DelayCommand(1.5,GiveXPToCreature(oPC,10));
      return;
  }
  }
  else
  {
  FloatingTextStringOnCreature("*Tu alineamiento no te permite rezar a Shondakul.*", oPC, FALSE);
    }
}
