#include "mti_libreria"

int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int nLevel = GetLevelByPosition(1, oPC) + GetLevelByPosition(2, oPC)+ GetLevelByPosition(3, oPC);
  if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL)
  {
        return TRUE;
  }
  else
  {
    if ((GetAlignmentGoodEvil(oPC) == ALIGNMENT_NEUTRAL) || (GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD))
    {
        if (ObtenerIntPersistente(oPC, "TEL_MURANN") == TRUE)
        {
          if (nLevel>=8) return TRUE;
        }
    }
  }
  string sSubraza = GetStringLowerCase(GetSubRace(oPC));
  if((sSubraza == "elfo")&&(sSubraza == "enano")) return FALSE;
  return FALSE;
}
