#include "pb_oraciones"
void main()
{
  object oPC = GetLastUsedBy();

  int iUnaVez = Rezar_Dios(oPC);
  if(iUnaVez == TRUE)
  {
      SendMessageToPC(oPC, "No se debe insistir demasiado...");
      return;
  }

int iAli1 = GetAlignmentLawChaos(oPC);
int iAli2 = GetAlignmentGoodEvil(oPC);
if(iAli1 == ALIGNMENT_CHAOTIC && iAli2 == ALIGNMENT_EVIL ||  //caotico maligno
    iAli1 == ALIGNMENT_NEUTRAL && iAli2 == ALIGNMENT_EVIL ||   //neutral maligno x
    iAli1 == ALIGNMENT_LAWFUL && iAli2 == ALIGNMENT_EVIL)   //legal maligno x
{

  SetLocalInt(oPC, "REZARSHAR", 1);
  DelayCommand(1440.0, DeleteLocalInt(oPC, "REZARSHAR"));

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

      effect eEfecto2 = EffectVisualEffect(6);
      effect eEfecto6 = EffectVisualEffect(50);
      effect eEfecto4 = EffectSkillIncrease(SKILL_MOVE_SILENTLY,10);
      effect eEfecto3 = EffectSkillIncrease(SKILL_PERSUADE,10);
      effect eEfecto5 = EffectSkillIncrease(SKILL_HIDE,10);
      DelayCommand(20.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto2, oPC));
      DelayCommand(20.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto6, oPC));
      DelayCommand(20.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEfecto4, oPC, 1000.0));
      DelayCommand(20.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEfecto3, oPC, 1000.0));
      DelayCommand(20.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEfecto5, oPC, 1000.0));
      DelayCommand(20.0, FloatingTextStringOnCreature("*¡Shar te ha bendecido!*", oPC, FALSE));
      GiveXPToCreature(oPC,100);
      return;
  }
  else
  {
      DelayCommand(20.0, FloatingTextStringOnCreature("*Shar no ha querido escucharte*", oPC, FALSE));
      GiveXPToCreature(oPC,10);
      return;
  }
  }
  else
  {
  FloatingTextStringOnCreature("*Tu alineamiento no te permite rezar a Shar.*", oPC, FALSE);
    }
}
