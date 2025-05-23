#include "mti_libreria"
#include "nwnx_creature"
void main()
{
  object oPC = GetPCSpeaker();

  //Quitamos del jugador el modo cutsecene
  SetCutsceneMode(oPC, FALSE);

  // El leto ha sido aplicado
  GuardarIntPersistente(oPC, "LETO_APLICADO", TRUE);

  // Efecto visual
  ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(752), GetLocation(oPC));

  // Raza
  NWNX_Creature_SetRacialType(oPC, RACIAL_TYPE_HUMANOID_GOBLINOID);

  int iFue = GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE);
  int iDes = GetAbilityScore(oPC, ABILITY_DEXTERITY, TRUE);
  int iCon = GetAbilityScore(oPC, ABILITY_CONSTITUTION, TRUE);
  int iCar = GetAbilityScore(oPC, ABILITY_CHARISMA, TRUE);
  NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_STRENGTH, iFue + 4);
  NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_DEXTERITY, iDes + 2);
  NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CONSTITUTION, iCon + 2);
  NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CHARISMA, iCar - 2);
}
