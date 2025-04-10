/*PIRATA COMPRA OBJETOS*/
#include "mti_libreria"
void main()
{
object oPC = GetPCSpeaker();
object oSangre = GetItemPossessedBy(oPC,"NW_IT_MSMLMISC09");
int iSangre = ObtenerIntPersistente(oPC,"vgz_cs_ojoderakshasha");

if(oSangre == OBJECT_INVALID)
{
SendMessageToPC(oPC,"*No tienes suficientes ojos de rakshasha!*");
return;
}

DestroyObject(oSangre);
GuardarIntPersistente(oPC,"vgz_cs_ojoderakshasha",iSangre + 1);

GiveGoldToCreature(oPC,20);

}

//::////////////////////////////////////////////////////////////////////////:://

