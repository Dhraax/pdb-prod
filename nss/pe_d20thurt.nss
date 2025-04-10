int StartingConditional()
{
  if(!GetHasSkill(SKILL_PICK_POCKET, GetPCSpeaker())) return FALSE;
  return TRUE;
}
