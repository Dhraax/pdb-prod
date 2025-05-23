int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int iTipoAviso = GetLocalInt(oPC, "CAB_POSIBLEMUERTO");

  if(iTipoAviso == 2) return TRUE;

  return FALSE;
}
