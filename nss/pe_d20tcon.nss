int StartingConditional()
{
  if(!GetHasSkill(SKILL_CONCENTRATION, GetPCSpeaker()))  return FALSE;
  return TRUE;
}
