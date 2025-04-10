int StartingConditional()
{
  object oPC = GetPCSpeaker();
  object oEscritoGuardado = GetLocalObject(oPC, "ESC_PAPEL");

  if(GetLocalString(oEscritoGuardado, "ESC_ANTERIORCAMBIO") != "") return TRUE;

  return FALSE;
}
