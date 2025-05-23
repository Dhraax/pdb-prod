int StartingConditional()
{
  if(!GetHasSkill(SKILL_MOVE_SILENTLY, GetPCSpeaker())) return FALSE;
  return TRUE;
}
