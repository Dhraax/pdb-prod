int StartingConditional()
{
  if(!GetHasSkill(SKILL_OPEN_LOCK, GetPCSpeaker())) return FALSE;
  return TRUE;
}
