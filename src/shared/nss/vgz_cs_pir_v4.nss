/*PIRATA COMPRA OBJETOS*/
#include "mti_libreria"
void main()
{
object oPJ = GetPCSpeaker();
object oObj = GetFirstItemInInventory(oPJ);

//::////////////////////////////////////////////////////////////////////////:://
/*OJOS DE RAKSHASHA*/
string sTag = "NW_IT_MSMLMISC09";
int iPrecio = 20;
int iOro = 0;
int iStack = 0;

while(GetIsObjectValid(oObj))
    {
     if(GetTag(oObj) == sTag)
        {
         iStack = GetNumStackedItems(oObj);//Numero de objetos apilados
         int iSangre = ObtenerIntPersistente(oPJ,"vgz_cs_ojoderakshasha");
         if(iStack < 2){ iOro+= iPrecio; GuardarIntPersistente(oPJ,"vgz_cs_ojoderakshasha",iSangre + 1);}
         else{ iOro+= (iPrecio*iStack); GuardarIntPersistente(oPJ,"vgz_cs_ojoderakshasha",iSangre + iStack);}
         DestroyObject(oObj);
        }
     oObj = GetNextItemInInventory(oPJ);
    }

//::////////////////////////////////////////////////////////////////////////:://
GiveGoldToCreature(oPJ,iOro);
}
