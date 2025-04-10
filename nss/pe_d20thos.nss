int StartingConditional()
{
  if(!GetHasSkill(SKILL_TAUNT, GetPCSpeaker())) return FALSE;
  return TRUE;
}
