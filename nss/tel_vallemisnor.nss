#include "mti_libreria"

int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int nLevel = GetLevelByPosition(1, oPC) + GetLevelByPosition(2, oPC)+ GetLevelByPosition(3, oPC);
  if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD)
  {
        return TRUE;
  }
  else
  {
    if ((GetAlignmentGoodEvil(oPC) == ALIGNMENT_NEUTRAL) || (GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL))
    {
        if (ObtenerIntPersistente(oPC, "TEL_VALLEMISNOR") == TRUE)
        {
          if (nLevel>=8) return TRUE;
        }
    }
  }
  return FALSE;
}
