int StartingConditional()
{
  object oPC = GetPCSpeaker();

  if(GetLocalString(oPC, "DSCPJ_ANTERIORCAMBIO") != "") return TRUE;

  return FALSE;
}
