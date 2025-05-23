#include "mti_libreria"
void main()
{
object oPC = GetPCSpeaker();

GuardarIntPersistente(oPC,"cs_ninfaespejo",4);
GiveXPToCreature(oPC,1500);
CreateItemOnObject(" ",oPC);

}
