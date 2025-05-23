#include "mti_libreria"

int StartingConditional()
{
  object oPC = GetPCSpeaker();
  object oTarget = GetLocalObject(OBJECT_SELF,"T1_TARGET_OBJECT");
  int iRange = FloatToInt(GetDistanceToObject(oTarget)) * 3;

  SetCustomToken(9869, IntToString(iRange));

  object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);

  if(oArmor != OBJECT_INVALID)
  {
      if(GetArmorType(oArmor) > 3) SetCustomToken(9868," Estás usando una armadura que disminuye notablemente la probabilidad de trepar por la cuerda satisfactoriamente y, por lo tanto, aumenta la probabilidad de fallar y caerse.");
      else SetCustomToken(9868," Tu actual armadura no afecta a la probabilidad de trepar por esta cuerda.");
  }
  else SetCustomToken(9868," El no usar ninguna armadura aumenta la probabilidad de trepar por la cuerda satisfactoriamente.");

  return (oTarget != OBJECT_INVALID);
}
