int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int iTipoAviso = GetLocalInt(oPC, "CAB_POSIBLEMUERTO");

  if(iTipoAviso == 3) return TRUE;

  return FALSE;
}
