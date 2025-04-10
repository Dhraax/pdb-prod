int StartingConditional()
{
  if(!GetHasSkill(SKILL_HEAL, GetPCSpeaker())) return FALSE;
  return TRUE;
}
