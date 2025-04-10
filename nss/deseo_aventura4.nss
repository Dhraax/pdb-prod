#include "mti_libreria"
int StartingConditional()
{
  object oPC = GetPCSpeaker();
  object oPergamino = GetItemPossessedBy(oPC, "pergaminodelcrom");
  object oMartillo = GetItemPossessedBy(oPC, "martillo_tronante");
  object oTahali = GetItemPossessedBy(oPC, "tahali_escarcha");
  object oGuantes = GetItemPossessedBy(oPC, "NW_IT_MBRACER013");

  if(oPergamino != OBJECT_INVALID && oMartillo != OBJECT_INVALID &&
     oTahali != OBJECT_INVALID && oGuantes != OBJECT_INVALID) return TRUE;
  return FALSE;
}
