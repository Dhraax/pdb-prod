#include "mti_libreria"
void main()
{
object oPC = GetPCSpeaker();

GuardarIntPersistente(oPC, "QUEST_IMN_FORM", 1);

// Dar los objetos al que habla
CreateItemOnObject("llavedelestablod", GetPCSpeaker(), 1);
}
