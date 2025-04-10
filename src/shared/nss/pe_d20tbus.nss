int StartingConditional()
{
  if(!GetHasSkill(SKILL_SEARCH, GetPCSpeaker())) return FALSE;
  return TRUE;
}
