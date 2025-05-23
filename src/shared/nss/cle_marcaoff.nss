#include "mti_libreria"

int StartingConditional()
{
  object oPC = GetPCSpeaker();

  if(GetLocalInt(GetArea(oPC), "NOTELEPORT") == 1) return FALSE;

  if(ObtenerIntPersistente(oPC, "PALABRA_REGRESO_LOC1") == TRUE ||
     ObtenerIntPersistente(oPC, "PALABRA_REGRESO_LOC2") == TRUE ||
     ObtenerIntPersistente(oPC, "PALABRA_REGRESO_LOC3") == TRUE) return TRUE;

  return FALSE;
}
