#include "mti_libreria"
void main()
{
  object oPC = GetPCSpeaker();
  GuardarIntPersistente(oPC, "LITHQUESTHADA", 5);
  SetXP(oPC, GetXP(oPC) + 400);
  CreateItemOnObject("nw_it_gem012", oPC);

  object oPolvoHada = GetItemPossessedBy(oPC, "NW_IT_MSMLMISC19");
  DestroyObject(oPolvoHada);
}
