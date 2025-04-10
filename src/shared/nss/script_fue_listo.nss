
#include "x2_inc_itemprop"


void main()
{
object oContenedor = GetObjectByTag("spawn_encuentros");

int iHab = GetLocalInt(oContenedor,"Ench");
int iCarac = GetLocalInt(oContenedor,"Caracteristica");
object oPC=GetPCSpeaker();
//object oSel = GetItemInSlot(GetLocalInt(oContenedor,"Sel"), oPC);

switch (iCarac){

  case 1:
  {
  itemproperty ipAddStrength=ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR, iHab);
  IPSafeAddItemProperty(GetItemInSlot(GetLocalInt(oContenedor,"Sel"), oPC), ipAddStrength);
  }
  break;

  case 2: SpeakString("¡Has escogido destreza!");
  {
  itemproperty ipAddDex=ItemPropertyAbilityBonus(IP_CONST_ABILITY_DEX, iHab);
  IPSafeAddItemProperty(GetItemInSlot(GetLocalInt(oContenedor,"Sel"), oPC), ipAddDex);
  }
  break;

  case 3: SpeakString("¡Has escogido constitución!");
  {
  itemproperty ipAddCon=ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, iHab);
  IPSafeAddItemProperty(GetItemInSlot(GetLocalInt(oContenedor,"Sel"), oPC), ipAddCon);
  }
  break;

  case 4: SpeakString("¡Has escogido sabiduría!");
  {
  itemproperty ipAddWis=ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS, iHab);
  IPSafeAddItemProperty(GetItemInSlot(GetLocalInt(oContenedor,"Sel"), oPC), ipAddWis);
  }
  break;

  case 5: SpeakString("¡Has escogido inteligencia!");
   {
  itemproperty ipAddInt=ItemPropertyAbilityBonus(IP_CONST_ABILITY_INT, iHab);
  IPSafeAddItemProperty(GetItemInSlot(GetLocalInt(oContenedor,"Sel"), oPC), ipAddInt);
  }
  break;

  case 6: SpeakString("¡Has escogido carisma!");
  {
  itemproperty ipAddCar=ItemPropertyAbilityBonus(IP_CONST_ABILITY_CHA, iHab);
  IPSafeAddItemProperty(GetItemInSlot(GetLocalInt(oContenedor,"Sel"), oPC), ipAddCar);
  }
  break;
}


//SetLocalInt(oContenedor,"Ench",0);
}
