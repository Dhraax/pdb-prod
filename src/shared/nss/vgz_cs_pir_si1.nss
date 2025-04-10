/*PIRATA COMPRA OBJETOS*/
#include "mti_libreria"
void main()
{
object oPC = GetPCSpeaker();
object oSangre = GetItemPossessedBy(oPC,"NW_IT_MSMLMISC17");
int iSangre = ObtenerIntPersistente(oPC,"vgz_cs_sangrededragon");

if(oSangre == OBJECT_INVALID)
{
SendMessageToPC(oPC,"*No tienes suficiente sangre de dragon!*");
return;
}

DestroyObject(oSangre);
GuardarIntPersistente(oPC,"vgz_cs_sangrededragon",iSangre + 1);

GiveGoldToCreature(oPC,250);

}

//::////////////////////////////////////////////////////////////////////////:://

