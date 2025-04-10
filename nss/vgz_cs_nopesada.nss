#include "mti_libreria"
void main()
{
  object oPC = GetEnteringObject();
  object oArmadura = GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);

  if(GetArmorType(oArmadura) > 5)
  {
      SendMessageToPC(oPC,"*Estas aguas son demasiado profundas para continuar con armadura pesada*");
  }
}
