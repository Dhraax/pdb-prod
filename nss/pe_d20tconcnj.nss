int StartingConditional()
{
  if(!GetHasSkill(SKILL_SPELLCRAFT, GetPCSpeaker())) return FALSE;
  return TRUE;
}
