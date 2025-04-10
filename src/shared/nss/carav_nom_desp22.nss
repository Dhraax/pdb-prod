#include "mti_libreria"
void main()
{
object oPC = GetPCSpeaker();

GiveXPToCreature(oPC, 500);
AdjustAlignment(oPC, ALIGNMENT_GOOD, 5);

GuardarIntPersistente(oPC,"DESPELLEJADOR_FINAL_GUAY",2);
}
