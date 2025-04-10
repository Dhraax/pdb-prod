#include "mti_libreria"
void main()
{
object oPC = GetPCSpeaker();

GuardarIntPersistente(oPC,"cs_ninfaespejo",2);
AdjustAlignment(oPC,ALIGNMENT_GOOD,5);
GiveXPToCreature(oPC,500);
CreateItemOnObject("cs_llaveestahada",oPC);

}
