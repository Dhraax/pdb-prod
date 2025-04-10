int StartingConditional()
{
  object oPC = GetPCSpeaker();

  // Restricción basada en las caracteristicas y habilidades
  if(GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE) < 13) return FALSE;
  if(GetAbilityScore(oPC, ABILITY_DEXTERITY, TRUE) < 15) return FALSE;

  return TRUE;
}
