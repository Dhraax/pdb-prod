#include "mti_libreria"

void main()
{
  object oPC = GetPCSpeaker();
  object oCabezaDuergar = GetItemPossessedBy(oPC, "cabezadliderduer");

  DestroyObject(oCabezaDuergar);
  GuardarIntPersistente(oPC, "UST_QDUERGAR", 2);
  CreateItemOnObject("wswmls002", oPC);
  GiveXPToCreature(oPC, 2500);
  GiveGoldToCreature(oPC, 5000);
}
