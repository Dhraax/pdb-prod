int StartingConditional()
{
  if(!GetHasSkill(SKILL_INTIMIDATE, GetPCSpeaker())) return FALSE;
  return TRUE;
}
