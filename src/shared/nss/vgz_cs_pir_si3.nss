/*PIRATA COMPRA OBJETOS*/
#include "mti_libreria"
void main()
{
object oPC = GetPCSpeaker();
object oSangre = GetItemPossessedBy(oPC,"NW_IT_MSMLMISC19");
int iSangre = ObtenerIntPersistente(oPC,"vgz_cs_polvodefata");

if(oSangre == OBJECT_INVALID)
{
SendMessageToPC(oPC,"*No tienes suficiente polvo de fata!*");
return;
}

DestroyObject(oSangre);
GuardarIntPersistente(oPC,"vgz_cs_polvodefata",iSangre + 1);

GiveGoldToCreature(oPC,80);

}

//::////////////////////////////////////////////////////////////////////////:://

