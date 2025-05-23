#include "x2_inc_itemprop"

void main()
{
  object oContenedor = GetObjectByTag("spawn_encuentros");
  int iReg= GetLocalInt(oContenedor,"Reg");
  object oPC = GetPCSpeaker();
  itemproperty ipAdd = ItemPropertyRegeneration(iReg);
  IPSafeAddItemProperty(GetItemInSlot(GetLocalInt(oContenedor,"Sel"), oPC), ipAdd, 0.0, 0);

}
