#include "mti_libreria"
void main()
{
object oPC = GetPCSpeaker();

GuardarIntPersistente(oPC, "QUEST_TOMBI", 1);

// Dar los objetos al que habla
CreateItemOnObject("paquete_tombi", GetPCSpeaker(), 1);
}
