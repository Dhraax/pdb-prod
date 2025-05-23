int StartingConditional()
{
  object oPC = GetPCSpeaker();
  object oEscritoGuardado = GetLocalObject(oPC, "ESC_PAPEL");
  string sNombreEscrito = GetName(oEscritoGuardado);

  SetCustomToken(500, sNombreEscrito);

  if(GetLocalInt(oEscritoGuardado, "ESC_FINALIZADO") == TRUE) return TRUE;

  return FALSE;
}
