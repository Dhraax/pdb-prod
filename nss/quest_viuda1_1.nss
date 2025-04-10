#include "mti_libreria"

void main()
{
object oPC = GetPCSpeaker();
GuardarIntPersistente(oPC, "quest_viuda", 1);
}
