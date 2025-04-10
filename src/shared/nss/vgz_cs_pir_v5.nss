/*PIRATA COMPRA OBJETOS*/
#include "mti_libreria"
void main()
{
object oPJ = GetPCSpeaker();
object oObj = GetFirstItemInInventory(oPJ);

//::////////////////////////////////////////////////////////////////////////:://
/*LENGUAS DE SLAAD*/
string sTag = "NW_IT_MSMLMISC10";
int iPrecio = 150;
int iOro = 0;
int iStack = 0;

while(GetIsObjectValid(oObj))
    {
     if(GetTag(oObj) == sTag)
        {
         iStack = GetNumStackedItems(oObj);//Numero de objetos apilados
         int iSangre = ObtenerIntPersistente(oPJ,"vgz_cs_lenguadeslaad");
         if(iStack < 2){ iOro+= iPrecio; GuardarIntPersistente(oPJ,"vgz_cs_lenguadeslaad",iSangre + 1);}
         else{ iOro+= (iPrecio*iStack); GuardarIntPersistente(oPJ,"vgz_cs_lenguadeslaad",iSangre + iStack);}
         DestroyObject(oObj);
        }
     oObj = GetNextItemInInventory(oPJ);
    }

//::////////////////////////////////////////////////////////////////////////:://
GiveGoldToCreature(oPJ,iOro);
}
