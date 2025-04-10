int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int iTipoAviso = GetLocalInt(oPC, "CAB_POSIBLEMUERTO");

  if(iTipoAviso == 1) return TRUE;

  return FALSE;
}
