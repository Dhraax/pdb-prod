/*PIRATA COMPRA OBJETOS*/
#include "mti_libreria"
void main()
{
object oPC = GetPCSpeaker();
object oSangre = GetItemPossessedBy(oPC,"NW_IT_MSMLMISC13");
int iSangre = ObtenerIntPersistente(oPC,"vgz_cs_nudillo");

if(oSangre == OBJECT_INVALID)
{
SendMessageToPC(oPC,"*No tienes suficientes nudillos de esqueleto!*");
return;
}

DestroyObject(oSangre);
GuardarIntPersistente(oPC,"vgz_cs_nudillo",iSangre + 1);

GiveGoldToCreature(oPC,50);

}

//::////////////////////////////////////////////////////////////////////////:://

