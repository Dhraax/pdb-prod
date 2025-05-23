int StartingConditional()
{
  object oPC = GetPCSpeaker();

  if(GetHasSpell(SPELL_ANIMATE_DEAD, oPC) > 0) return TRUE;
  if(GetLevelByClass(CLASS_TYPE_PALEMASTER, oPC) >= 2) return TRUE;

  return FALSE;
}
