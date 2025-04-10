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

  // Ajuste de raza y caracteristicas
  NWNX_Creature_SetRacialType(oPC, RACIAL_TYPE_OUTSIDER);
  SetCreatureAppearanceType(oPC, 6);

  int iSab = GetAbilityScore(oPC, ABILITY_WISDOM, TRUE);
  int iCar = GetAbilityScore(oPC, ABILITY_CHARISMA, TRUE);
  NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_WISDOM, iSab + 2);
  NWNX_Creature_SetRawAbilityScore(oPC, ABILITY_CHARISMA, iCar + 2);

  // Habilidades de Aasimar
  CreateItemOnObject("crr_subrace_5", oPC);
}
