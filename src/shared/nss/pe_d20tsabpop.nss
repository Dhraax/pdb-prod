int StartingConditional()
{
  if(!GetHasSkill(SKILL_LORE, GetPCSpeaker())) return FALSE;
  return TRUE;
}
