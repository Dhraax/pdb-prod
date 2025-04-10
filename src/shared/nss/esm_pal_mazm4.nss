#include "mti_libreria"
int StartingConditional()
{
  object oPC = GetPCSpeaker();
  object oYelmo = GetItemPossessedBy(oPC, "esm_yelmo_mazm");
  int iVariable = ObtenerIntPersistente(oPC, "ESM_PALACIOMAZMORRAS");

  if(iVariable == 1 && oYelmo != OBJECT_INVALID) return TRUE;
  return FALSE;
}
