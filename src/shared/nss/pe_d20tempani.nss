int StartingConditional()
{
  if(!GetHasSkill(SKILL_ANIMAL_EMPATHY, GetPCSpeaker())) return FALSE;
  return TRUE;
}
