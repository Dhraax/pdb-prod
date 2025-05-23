#include "mti_libreria"

int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int nLevel = GetLevelByPosition(1, oPC) + GetLevelByPosition(2, oPC)+ GetLevelByPosition(3, oPC);

        if (ObtenerIntPersistente(oPC, "TEL_BRYNNLEY") == TRUE)
        {
            if (nLevel >= 8) return TRUE;
        }



  return FALSE;
}
