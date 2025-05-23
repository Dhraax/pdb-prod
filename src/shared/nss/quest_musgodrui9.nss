#include "mti_libreria"

void main()
{
  object oPC = GetPCSpeaker();
  object oCabeza = GetItemPossessedBy(oPC, "q_cabezatroll");

  GuardarIntPersistente(oPC, "QUEST_MUSGO_ARCHIDRUIDA", 5);
  DestroyObject(oCabeza);
  GiveXPToCreature(oPC, 1500);
  GiveGoldToCreature(oPC, 2500);
}
