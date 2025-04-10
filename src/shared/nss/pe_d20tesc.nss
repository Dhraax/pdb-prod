int StartingConditional()
{
  if(!GetHasSkill(SKILL_HIDE, GetPCSpeaker())) return FALSE;
  return TRUE;
}
