int StartingConditional()
{
  if(!GetHasSkill(SKILL_APPRAISE, GetPCSpeaker())) return FALSE;
  return TRUE;
}
