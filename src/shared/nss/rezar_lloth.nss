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

  // SOLO REZAN MALIGNOS
  int iMaligno = GetAlignmentGoodEvil(oPC);
  if(iMaligno != ALIGNMENT_EVIL)
  {
      FloatingTextStringOnCreature("*Tu alineamiento no te permite rezar a Lolt.*", oPC, FALSE);
      return;
  }

  // Variables
  SetLocalInt(oPC, "REZARLLOTH", 1);
  DelayCommand(1440.0, DeleteLocalInt(oPC, "REZARLLOTH"));

  // Animaciones
  SetCutsceneMode(oPC, TRUE);
  SetCameraMode(oPC, CAMERA_MODE_STIFF_CHASE_CAMERA);
  SetCutsceneCameraMoveRate(oPC, 0.1);
  AssignCommand(oPC, ActionDoCommand(SetFacingPoint(GetPositionFromLocation(GetLocation(OBJECT_SELF)))));
  AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE, 1.0, 20.0));
  DelayCommand(20.0, SetCutsceneMode(oPC, FALSE));

  // Efectos
  int iTirada = d100() + GetAbilityModifier(ABILITY_WISDOM, oPC);
  int iCD = 75;
  if(iTirada >= iCD)
  {
      effect eEfecto1 = EffectSkillIncrease(SKILL_BLUFF,d6(1));
      effect eEfecto2 = EffectVisualEffect(VFX_FNF_PWKILL);
      effect eEfecto3 = EffectSavingThrowIncrease(SAVING_THROW_WILL,d4(1),SAVING_THROW_TYPE_MIND_SPELLS);
      DelayCommand(20.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEfecto1, oPC, 1000.0));
      DelayCommand(20.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto2, oPC));
      DelayCommand(20.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEfecto3, oPC, 1000.0));
      DelayCommand(20.0, FloatingTextStringOnCreature("*¡Lloth te ha bendecido!*", oPC, FALSE));
      GiveXPToCreature(oPC,100);
      return;
  }
  else
  {
      DelayCommand(20.0, FloatingTextStringOnCreature("*Tus rezos no han llegado a Lolt.*", oPC, FALSE));
      GiveXPToCreature(oPC,10);
      return;
  }
}
