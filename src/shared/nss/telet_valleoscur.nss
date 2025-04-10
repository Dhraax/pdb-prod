#include "mti_libreria"

int StartingConditional()
{
  object oPC = GetPCSpeaker();
  string sSubraza = GetStringLowerCase(GetSubRace(oPC));
  int iDrowSuperficie = ObtenerIntPersistente(oPC, "DROWSUPERFICIE");
  int iSemidrowSuperficie = ObtenerIntPersistente(oPC, "SEMIDROWSUPERFICIE");

  if(ObtenerIntPersistente(oPC, "TEL_VALLEOSCURO") == TRUE &&
    ((sSubraza == "drow" && iDrowSuperficie == 0) ||
     (sSubraza == "semidrow" && iSemidrowSuperficie == 0) ||
      sSubraza == "duergar"   || sSubraza == "svirfneblin" ||
      sSubraza == "githyanki" || sSubraza == "orog")) return TRUE;

  return FALSE;
}
