// modified by: Dhraax
int StartingConditional()
{
  object oPC = GetPCSpeaker();
  object oEscritoGuardado = GetLocalObject(oPC, "ESC_PAPEL");
  string sNombreEscrito = GetName(oEscritoGuardado);

  SetCustomToken(93001, sNombreEscrito);

  if(GetLocalInt(oEscritoGuardado, "ESC_FINALIZADO") == TRUE) return TRUE;

  return FALSE;
}
