int StartingConditional()
{
  if(!GetHasSkill(SKILL_USE_MAGIC_DEVICE, GetPCSpeaker())) return FALSE;
  return TRUE;
}
