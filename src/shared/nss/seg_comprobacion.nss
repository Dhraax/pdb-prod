#include "mti_libreria"

int StartingConditional()
{
  object oPC = GetPCSpeaker();
  object oMod = GetModule();
  string sCdKey = GetPCPublicCDKey(oPC);
  string sContrasenyaMemorizada = ObtenerStringPersistente(oPC, "SEGCONTRASENYA");
  string sSerie = GetLocalString(oPC, "SEGSERIE");
  string sIntentos = IntToString(3 - (GetLocalInt(oMod, "SEG_INTENTOS" + sCdKey) + 1));

  SetCustomToken(1001, sIntentos);

  if(sContrasenyaMemorizada == sSerie) return TRUE;
  else return FALSE;
}
