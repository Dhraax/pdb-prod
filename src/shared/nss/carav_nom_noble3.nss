#include "mti_libreria"

void main()
{
object oPC = GetPCSpeaker();

CreateItemOnObject("llavedelacriptad", GetPCSpeaker(), 1);
GuardarIntPersistente(oPC,"QUEST_CARAVASAR_LUXARROL",1);
}
