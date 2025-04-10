int StartingConditional()
{
  if(!GetHasSkill(SKILL_DISCIPLINE, GetPCSpeaker()))  return FALSE;
  return TRUE;
}
