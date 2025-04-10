int StartingConditional()
{
  if(!GetHasSkill(SKILL_CRAFT_WEAPON, GetPCSpeaker())) return FALSE;
  return TRUE;
}
