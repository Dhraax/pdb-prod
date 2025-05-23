int StartingConditional()
{
  if(!GetHasSkill(SKILL_BLUFF, GetPCSpeaker()))  return FALSE;
  return TRUE;
}
