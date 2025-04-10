#include "mti_libreria"
void main()
{
  object oPC = GetPCSpeaker();
  object oYelmo = GetItemPossessedBy(oPC, "esm_yelmo_mazm");

  if(oYelmo != OBJECT_INVALID) DestroyObject(oYelmo);
  GuardarIntPersistente(oPC, "ESM_PALACIOMAZMORRAS", 2);
  SetXP(oPC, GetXP(oPC) + 3000);
  GiveGoldToCreature(oPC, 15000);
  CreateItemOnObject("esm_escudo_mazm", oPC);
}
