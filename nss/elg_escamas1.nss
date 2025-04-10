#include "mti_libreria"

int StartingConditional()
{
  object oPC = GetPCSpeaker();
  string sSubraza = GetStringLowerCase(GetSubRace(oPC));
  int iDrowSuperficie = ObtenerIntPersistente(oPC, "DROWSUPERFICIE");
  int iSemidrowSuperficie = ObtenerIntPersistente(oPC, "SEMIDROWSUPERFICIE");

  if(((sSubraza == "drow" && iDrowSuperficie == 0) ||
      (sSubraza == "semidrow" && iSemidrowSuperficie == 0) ||
       sSubraza == "duergar" || sSubraza == "svirfneblin") &&
       GetItemPossessedBy(oPC, "escama_olatelghi") != OBJECT_INVALID) return TRUE;

  return FALSE;
}
