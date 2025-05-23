#include "mti_libreria"
void main()
{
  object oPC = GetPCSpeaker();

  // Dar algunos PX al que habla
  GiveXPToCreature(GetPCSpeaker(), 3000);

  // Eliminar objetos del inventario del jugador.
  object oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "CollardeKrein");
  if(GetIsObjectValid(oItemToTake) != 0) DestroyObject(oItemToTake);

  GuardarIntPersistente(oPC, "ESMEL_QUEST_LLORONA", 2);
  AdjustAlignment(oPC, ALIGNMENT_GOOD, 5);
}

