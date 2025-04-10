int StartingConditional()
{
  if(!GetHasSkill(SKILL_CRAFT_ARMOR, GetPCSpeaker())) return FALSE;
  return TRUE;
}
