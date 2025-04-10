int StartingConditional()
{
  if(!GetHasSkill(SKILL_PERFORM, GetPCSpeaker())) return FALSE;
  return TRUE;
}
