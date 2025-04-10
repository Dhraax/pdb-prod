/*PIRATA COMPRA OBJETOS*/
#include "mti_libreria"
void main()
{
object oPC = GetPCSpeaker();
object oSangre = GetItemPossessedBy(oPC,"NW_IT_MSMLMISC10");
int iSangre = ObtenerIntPersistente(oPC,"vgz_cs_lenguadeslaad");

if(oSangre == OBJECT_INVALID)
{
SendMessageToPC(oPC,"*No tienes suficientes lenguas de slaad!*");
return;
}

DestroyObject(oSangre);
GuardarIntPersistente(oPC,"vgz_cs_lenguadeslaad",iSangre + 1);

GiveGoldToCreature(oPC,150);

}

//::////////////////////////////////////////////////////////////////////////:://

