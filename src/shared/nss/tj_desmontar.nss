#include "tj_inc"
void main()
{
  object oPC = GetPCSpeaker();

  effect eImmo = EffectCutsceneImmobilize();
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eImmo, oPC, 6.0);
  AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 6.0));

  EliminarUbicadosTJ(oPC);
  EliminarVariablesTJ(oPC);
}
