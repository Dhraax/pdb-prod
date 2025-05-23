#include "pb_oraciones"
void main()
{
  object oPC = GetLastUsedBy();

  int iUnaVez = Rezar_Dios(oPC);
  if(iUnaVez == TRUE)
  {
      SendMessageToPC(oPC, "El rezo diario en el altar principal ha sido realizado");
      return;
  }

int iAli1 = GetAlignmentLawChaos(oPC);
int iAli2 = GetAlignmentGoodEvil(oPC);
if(iAli1 == ALIGNMENT_LAWFUL && iAli2 == ALIGNMENT_NEUTRAL ||
    iAli1 == ALIGNMENT_NEUTRAL && iAli2 == ALIGNMENT_EVIL ||
    iAli1 == ALIGNMENT_LAWFUL && iAli2 == ALIGNMENT_EVIL)
 {

  SetLocalInt(oPC, "REZARBANE", 1);
  DelayCommand(1440.0, DeleteLocalInt(oPC, "REZARBANE"));

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
      effect eEfecto3 = EffectSavingThrowIncrease(SAVING_THROW_WILL,5);
      DelayCommand(20.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto2, oPC));
      DelayCommand(20.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEfecto3, oPC, 100000.0));
      DelayCommand(20.0, FloatingTextStringOnCreature("*¡Bane esta contigo!*", oPC, FALSE));
      GiveXPToCreature(oPC,100);
      return;
  }
  else
  {
      DelayCommand(20.0, FloatingTextStringOnCreature("*Tus rezos no han llegado a Bane.*", oPC, FALSE));
      GiveXPToCreature(oPC,10);
      return;
  }
  }
  else
  {
  FloatingTextStringOnCreature("*Eres un blasfemo indigno y tu alineamiento no te permite rezar a Bane.*", oPC, FALSE);
    }
}
