int StartingConditional()
{
  object oPC = GetPCSpeaker();

  if(GetAbilityScore(oPC, ABILITY_STRENGTH) >= 18) return TRUE;
  return FALSE;
}
