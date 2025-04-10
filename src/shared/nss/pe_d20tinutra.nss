int StartingConditional()
{
  if(!GetHasSkill(SKILL_DISABLE_TRAP, GetPCSpeaker())) return FALSE;
  return TRUE;
}
