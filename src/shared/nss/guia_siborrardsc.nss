int StartingConditional()
{
  object oPC = GetPCSpeaker();

  if(GetDescription(oPC) != "") return TRUE;

  return FALSE;
}
