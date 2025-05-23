#include "pb_oraciones"
void main()
{
  object oPC = GetLastUsedBy();

  int iUnaVez = Rezar_Dios(oPC);
  if(iUnaVez == TRUE)
  {
      SendMessageToPC(oPC, "Ya he rezado una vez, probaré más tarde.");
      return;
  }

  SetLocalInt(oPC, "REZAKHAUNTEA", 1);
  DelayCommand(1440.0, DeleteLocalInt(oPC, "REZAKHAUNTEA"));

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
      effect eEfecto1 = EffectDamageResistance(DAMAGE_TYPE_ACID, 10, 100);
      effect eEfecto2 = EffectVisualEffect(VFX_FNF_SUMMONDRAGON);

      DelayCommand(20.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEfecto1, oPC, 1000.0));
      DelayCommand(20.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto2, oPC));

      DelayCommand(20.0, FloatingTextStringOnCreature("*¡Khauntea te ha bendecido!*", oPC, FALSE));
      GiveXPToCreature(oPC,100);
  }
  else
  {
      DelayCommand(20.0, FloatingTextStringOnCreature("*Tus rezos no han llegado a Khauntea.*", oPC, FALSE));
      GiveXPToCreature(oPC,10);
  }
}
