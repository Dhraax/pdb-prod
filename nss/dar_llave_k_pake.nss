#include "mti_libreria"
#include "nw_i0_tool"
void main()
{
object oPC = GetPCSpeaker();

GuardarIntPersistente(oPC, "QUEST_TOMBI", 2);

// Dar algunos PX al que habla
SetXP(oPC, GetXP(oPC) + 500);

// Dar los objetos al que habla
CreateItemOnObject("criptadegambiton", GetPCSpeaker(), 1);

// Eliminar objetos del inventario del jugador.
object oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "Paquete_tombi");
if(GetIsObjectValid(oItemToTake) == TRUE) DestroyObject(oItemToTake);
}
