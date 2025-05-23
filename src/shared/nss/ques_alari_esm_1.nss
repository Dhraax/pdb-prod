#include "mti_libreria"
void main()
{
object oPC = GetPCSpeaker();
GuardarIntPersistente(oPC, "QUEST_ALARICO_ESMEL", 1);
}

