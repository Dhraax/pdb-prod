#include "mti_libreria"
void main()
{
object oPC = GetPCSpeaker();

GuardarIntPersistente(oPC, "QUEST_ALCALD_IMN", 2);

// Dar un poco de oro al que habla
GiveGoldToCreature(GetPCSpeaker(), 4000);

// Dar algunos PX al que habla
GiveXPToCreature(GetPCSpeaker(), 1500);

// Eliminar objetos del inventario del jugador.
object oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "CabezadelBandido_Imn");
if(GetIsObjectValid(oItemToTake) == TRUE)  DestroyObject(oItemToTake);
}
