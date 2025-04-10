#include "mti_libreria"

void main()
{
  object oPC = GetPCSpeaker();
  object oNotaDuergar = GetItemPossessedBy(oPC, "duergar_notaques");

  DestroyObject(oNotaDuergar);
  GuardarIntPersistente(oPC, "UST_QDUERGAR", 1);
}
