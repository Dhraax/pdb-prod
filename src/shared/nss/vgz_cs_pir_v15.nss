/*PIRATA COMPRA OBJETOS*/
#include "mti_libreria"
void main()
{
object oPJ = GetPCSpeaker();
object oObj = GetFirstItemInInventory(oPJ);

//::////////////////////////////////////////////////////////////////////////:://
/*HUEVO DE DRAGON*/
string sTag = "HuevosdeDragn";
int iPrecio = 300;
int iOro = 0;
int iStack = 0;

while(GetIsObjectValid(oObj))
    {
     if(GetTag(oObj) == sTag)
        {
         iStack = GetNumStackedItems(oObj);//Numero de objetos apilados
         int iSangre = ObtenerIntPersistente(oPJ,"vgz_cs_huevodedragon");
         if(iStack < 2){ iOro+= iPrecio; GuardarIntPersistente(oPJ,"vgz_cs_huevodedragon",iSangre + 1);}
         else{ iOro+= (iPrecio*iStack); GuardarIntPersistente(oPJ,"vgz_cs_huevodedragon",iSangre + iStack);}
         DestroyObject(oObj);
        }
     oObj = GetNextItemInInventory(oPJ);
    }

//::////////////////////////////////////////////////////////////////////////:://
GiveGoldToCreature(oPJ,iOro);
}
