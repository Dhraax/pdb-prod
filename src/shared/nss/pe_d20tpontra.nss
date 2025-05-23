int StartingConditional()
{
  if(!GetHasSkill(SKILL_SET_TRAP, GetPCSpeaker())) return FALSE;
  return TRUE;
}
