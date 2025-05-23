int StartingConditional()
{
  if(!GetHasSkill(SKILL_CRAFT_TRAP, GetPCSpeaker())) return FALSE;
  return TRUE;
}
