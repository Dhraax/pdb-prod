int StartingConditional()
{
  if(!GetHasSkill(SKILL_PARRY, GetPCSpeaker())) return FALSE;
  return TRUE;
}
