#include "mti_libreria"

int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int iLevel = GetLevelByPosition(1, oPC) + GetLevelByPosition(2, oPC) + GetLevelByPosition(3, oPC);
  if (ObtenerIntPersistente(oPC, "TEL_CARAVASAR") == TRUE)
    if (iLevel >= 8) return TRUE;

  return FALSE;
}
