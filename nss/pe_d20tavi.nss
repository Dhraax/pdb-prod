int StartingConditional()
{
  if(!GetHasSkill(SKILL_SPOT, GetPCSpeaker())) return FALSE;
  return TRUE;
}
