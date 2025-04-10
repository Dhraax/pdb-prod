/*PIRATA COMPRA OBJETOS*/
#include "mti_libreria"
void main()
{
object oPC = GetPCSpeaker();
object oSangre = GetItemPossessedBy(oPC,"NW_IT_MSMLMISC06");
int iSangre = ObtenerIntPersistente(oPC,"vgz_cs_dientedebodak");

if(oSangre == OBJECT_INVALID)
{
SendMessageToPC(oPC,"*No tienes suficientes dientes de bodak!*");
return;
}

DestroyObject(oSangre);
GuardarIntPersistente(oPC,"vgz_cs_dientedebodak",iSangre + 1);

GiveGoldToCreature(oPC,100);

}

//::////////////////////////////////////////////////////////////////////////:://

