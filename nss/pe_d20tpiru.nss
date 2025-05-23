int StartingConditional()
{
  if(!GetHasSkill(SKILL_TUMBLE, GetPCSpeaker())) return FALSE;
  return TRUE;
}
