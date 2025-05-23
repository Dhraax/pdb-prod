int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int iVariable = GetLocalInt(oPC, "Fuente_esmel");

  if(iVariable == 1) return TRUE;
  return FALSE;
}
