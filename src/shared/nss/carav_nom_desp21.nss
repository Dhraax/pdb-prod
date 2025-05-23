#include "mti_libreria"
void main()
{
object oPC = GetPCSpeaker();

GiveGoldToCreature(oPC, 2000);
GiveXPToCreature(oPC, 300);

GuardarIntPersistente(oPC,"DESPELLEJADOR_FINAL_GUAY",2);
}
