int StartingConditional()
{
  if(!GetHasSkill(SKILL_RIDE, GetPCSpeaker())) return FALSE;
  return TRUE;
}

