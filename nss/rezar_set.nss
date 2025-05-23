#include "pb_oraciones"
void main()
{
  object oPC = GetLastUsedBy();

  int iUnaVez = Rezar_Dios(oPC);
  if(iUnaVez == TRUE)
  {
      SendMessageToPC(oPC, "El rezo diario en el altar ha sido realizado");
      return;
  }
  SetLocalInt(oPC, "REZARSET", 1);
  DelayCommand(2000.0, DeleteLocalInt(oPC, "REZARSET"));

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

      effect eEfecto2 = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
      effect eEfecto3 = EffectSavingThrowIncrease(SAVING_THROW_WILL,3);
      DelayCommand(20.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto2, oPC));
      DelayCommand(20.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEfecto3, oPC, 600.0));
      DelayCommand(20.0, FloatingTextStringOnCreature("*¡Set ha recibido tus plegarias!*", oPC, FALSE));
      GiveXPToCreature(oPC,100);
      return;
  }
  else
  {
      DelayCommand(20.0, FloatingTextStringOnCreature("*Tus rezos no han llegado a Set.*", oPC, FALSE));
      GiveXPToCreature(oPC,10);
      return;
  }
}
