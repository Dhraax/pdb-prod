/*PIRATA COMPRA OBJETOS*/
#include "mti_libreria"
void main()
{
object oPC = GetPCSpeaker();
object oSangre = GetItemPossessedBy(oPC,"HuevosdeDragn");
int iSangre = ObtenerIntPersistente(oPC,"vgz_cs_huevodedragon");

if(oSangre == OBJECT_INVALID)
{
SendMessageToPC(oPC,"*No tienes suficiente sangre de dragon!*");
return;
}

DestroyObject(oSangre);
GuardarIntPersistente(oPC,"vgz_cs_huevodedragon",iSangre + 1);

GiveGoldToCreature(oPC,300);

}

//::////////////////////////////////////////////////////////////////////////:://

