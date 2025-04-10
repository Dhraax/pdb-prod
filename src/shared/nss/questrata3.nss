#include "mti_libreria"
void main()
{
object oPC = GetPCSpeaker();
GuardarIntPersistente(oPC, "QUEST_MUR_RATA", 1);
}
