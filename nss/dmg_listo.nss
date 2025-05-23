#include "x2_inc_itemprop"

void main()
{
object oContenedor = GetObjectByTag("spawn_encuentros");
int iDmg= GetLocalInt(oContenedor,"Dmg");
int iDamage = GetLocalInt(oContenedor,"Daño");

object oPC = GetPCSpeaker();
switch(iDamage)
{
  case 0:
  {
  itemproperty ipAdd = ItemPropertyDamageBonus(iDamage, iDmg);
  IPSafeAddItemProperty(GetItemInSlot(GetLocalInt(oContenedor,"Sel"), oPC), ipAdd, 0.0, 2);
  }
  break;
  case 1:
  {
  itemproperty ipAdd = ItemPropertyDamageBonus(iDamage, iDmg);
  IPSafeAddItemProperty(GetItemInSlot(GetLocalInt(oContenedor,"Sel"), oPC), ipAdd, 0.0, 2);
  }
  break;
  case 2:
  {
  itemproperty ipAdd = ItemPropertyDamageBonus(iDamage, iDmg);
  IPSafeAddItemProperty(GetItemInSlot(GetLocalInt(oContenedor,"Sel"), oPC), ipAdd, 0.0, 2);
  }
  break;
  case 4:
  {
  itemproperty ipAdd = ItemPropertyDamageBonus(iDamage, iDmg);
  IPSafeAddItemProperty(GetItemInSlot(GetLocalInt(oContenedor,"Sel"), oPC), ipAdd, 0.0, 2);
  }
  break;
  case 5:
  {
  itemproperty ipAdd = ItemPropertyDamageBonus(iDamage, iDmg);
  IPSafeAddItemProperty(GetItemInSlot(GetLocalInt(oContenedor,"Sel"), oPC), ipAdd, 0.0, 2);
  }
  break;
  case 6:
  {
  itemproperty ipAdd = ItemPropertyDamageBonus(iDamage, iDmg);
  IPSafeAddItemProperty(GetItemInSlot(GetLocalInt(oContenedor,"Sel"), oPC), ipAdd, 0.0, 2);
  }
  break;
  case 7:{
  itemproperty ipAdd = ItemPropertyDamageBonus(iDamage, iDmg);
  IPSafeAddItemProperty(GetItemInSlot(GetLocalInt(oContenedor,"Sel"), oPC), ipAdd, 0.0, 2);
  }
  break;
  case 8:
  {
  itemproperty ipAdd = ItemPropertyDamageBonus(iDamage, iDmg);
  IPSafeAddItemProperty(GetItemInSlot(GetLocalInt(oContenedor,"Sel"), oPC), ipAdd, 0.0, 2);
  }
  break;
  case 9:
  {
  itemproperty ipAdd = ItemPropertyDamageBonus(iDamage, iDmg);
  IPSafeAddItemProperty(GetItemInSlot(GetLocalInt(oContenedor,"Sel"), oPC), ipAdd, 0.0, 2);
  }
  break;
  case 10:
  {
  itemproperty ipAdd = ItemPropertyDamageBonus(iDamage, iDmg);
  IPSafeAddItemProperty(GetItemInSlot(GetLocalInt(oContenedor,"Sel"), oPC), ipAdd, 0.0, 2);
  }
  break;
  case 11:
  {
  itemproperty ipAdd = ItemPropertyDamageBonus(iDamage, iDmg);
  IPSafeAddItemProperty(GetItemInSlot(GetLocalInt(oContenedor,"Sel"), oPC), ipAdd, 0.0, 2);
  }
  break;
  case 12:
  {
  itemproperty ipAdd = ItemPropertyDamageBonus(iDamage, iDmg);
  IPSafeAddItemProperty(GetItemInSlot(GetLocalInt(oContenedor,"Sel"), oPC), ipAdd, 0.0, 2);
  }
  break;
  case 13:
  {
  itemproperty ipAdd = ItemPropertyDamageBonus(iDamage, iDmg);
  IPSafeAddItemProperty(GetItemInSlot(GetLocalInt(oContenedor,"Sel"), oPC), ipAdd, 0.0, 2);
  }
  break;

}
}
