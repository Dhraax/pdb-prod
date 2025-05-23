#include "mti_libreria"
void main()
{
  object oPC = GetPCSpeaker();
  GiveXPToCreature(oPC, 1500);
  CreateItemOnObject("llav_sune_jefa_", oPC, 1);
  GuardarIntPersistente(oPC, "QUEST_MAGA_ZS", 4);
  object oItemToTake = GetItemPossessedBy(oPC, "vinopurskulcosex");
  if(GetIsObjectValid(oItemToTake) != 0)  DestroyObject(oItemToTake);
}
