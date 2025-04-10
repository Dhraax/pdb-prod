int StartingConditional()
{
  if(!GetHasSkill(SKILL_LISTEN, GetPCSpeaker())) return FALSE;
  return TRUE;
}
