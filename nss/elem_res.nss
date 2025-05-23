#include "x2_inc_itemprop"

void main()
{
object oContenedor = GetObjectByTag("spawn_encuentros");
int iElem= GetLocalInt(oContenedor,"Elemento");
int iVal = GetLocalInt(oContenedor,"elementovalor");
object oPC = GetPCSpeaker();

  itemproperty ipAdd = ItemPropertyDamageResistance(iElem, iVal);
  IPSafeAddItemProperty(GetItemInSlot(GetLocalInt(oContenedor,"Sel"), oPC), ipAdd, 0.0, 2);

}
