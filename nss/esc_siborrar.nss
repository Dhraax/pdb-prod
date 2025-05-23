int StartingConditional()
{
  object oPC = GetPCSpeaker();
  object oEscritoGuardado = GetLocalObject(oPC, "ESC_PAPEL");

  if(GetLocalInt(oEscritoGuardado, "ESC_USADO") == TRUE) return TRUE;

  return FALSE;
}
