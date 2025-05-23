int StartingConditional()
{
  if(!GetHasSkill(SKILL_PERSUADE, GetPCSpeaker())) return FALSE;
  return TRUE;
}
