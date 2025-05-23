#include "mti_libreria"

int StartingConditional()
{
  object oPC = GetPCSpeaker();
  string sCDKeyMemorizada = ObtenerStringPersistente(oPC, "CDKEY");

  DeleteLocalString(oPC, "SEGSERIE");

  if(sCDKeyMemorizada == "") return TRUE;
  else return FALSE;
}
