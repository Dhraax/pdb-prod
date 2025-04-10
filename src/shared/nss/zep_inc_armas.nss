// ----------------------------------------------------------------------------
// Returns TRUE if oItem is a melee weapon
// ----------------------------------------------------------------------------
int VerSiEsArmaCuerpoACuerpo(object oItem)
{
    //Declare major variables
    int nItem = GetBaseItemType(oItem);

    if((nItem == BASE_ITEM_BASTARDSWORD) ||
      (nItem == BASE_ITEM_BATTLEAXE) ||
      (nItem == BASE_ITEM_DOUBLEAXE) ||
      (nItem == BASE_ITEM_GREATAXE) ||
      (nItem == BASE_ITEM_GREATSWORD) ||
      (nItem == BASE_ITEM_HALBERD) ||
      (nItem == BASE_ITEM_HANDAXE) ||
      (nItem == BASE_ITEM_KAMA) ||
      (nItem == BASE_ITEM_KATANA) ||
      (nItem == BASE_ITEM_KUKRI) ||
      (nItem == BASE_ITEM_LONGSWORD) ||
      (nItem == BASE_ITEM_SCIMITAR) ||
      (nItem == BASE_ITEM_SCYTHE) ||
      (nItem == BASE_ITEM_SICKLE) ||
      (nItem == BASE_ITEM_TWOBLADEDSWORD) ||
      (nItem == BASE_ITEM_CLUB) ||
      (nItem == BASE_ITEM_DAGGER) ||
      (nItem == BASE_ITEM_DIREMACE) ||
      (nItem == BASE_ITEM_HEAVYFLAIL) ||
      (nItem == BASE_ITEM_LIGHTFLAIL) ||
      (nItem == BASE_ITEM_LIGHTHAMMER) ||
      (nItem == BASE_ITEM_LIGHTMACE) ||
      (nItem == BASE_ITEM_MORNINGSTAR) ||
      (nItem == BASE_ITEM_QUARTERSTAFF) ||
      (nItem == BASE_ITEM_MAGICSTAFF) ||
      (nItem == BASE_ITEM_RAPIER) ||
      (nItem == BASE_ITEM_WHIP) ||
      (nItem == BASE_ITEM_SHORTSPEAR) ||
      (nItem == BASE_ITEM_SHORTSWORD) ||
      (nItem == BASE_ITEM_WARHAMMER)  ||
      (nItem == BASE_ITEM_DWARVENWARAXE) ||
      (nItem == BASE_ITEM_TRIDENT) ||
      (nItem == 92)  ||
      (nItem == 210) ||
      (nItem == 214) ||
      (nItem == 300) ||
      (nItem == 301) ||
      (nItem == 302) ||
      (nItem == 303) ||
      (nItem == 304) ||
      (nItem == 305) ||
      (nItem == 308) ||
      (nItem == 309) ||
      (nItem == 310) ||
      (nItem == 312) ||
      (nItem == 313) ||
      (nItem == 316) ||
      (nItem == 317) ||
      (nItem == 318) ||
      (nItem == 319) ||
      (nItem == 320) ||
      (nItem == 321) ||
      (nItem == 322) ||
      (nItem == 323) ||
      (nItem == 324) ||
      (nItem == 330) ||
      (nItem == 510) ||
      (nItem == 511) ||
      (nItem == 512) ||
      (nItem == 513) ||
      (nItem == 514))
   {
        return TRUE;
   }
   return FALSE;
}



object ArmaCuerpoACuerpoObjetivoOEquipada()
{
  object oTarget = GetSpellTargetObject();
  if(GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
  {
    if (VerSiEsArmaCuerpoACuerpo(oTarget))
    {
        return oTarget;
    }
    else
    {
        return OBJECT_INVALID;
    }

  }

  object oWeapon1 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
  if (GetIsObjectValid(oWeapon1) && VerSiEsArmaCuerpoACuerpo(oWeapon1))
  {
    return oWeapon1;
  }

  oWeapon1 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
  if (GetIsObjectValid(oWeapon1) && VerSiEsArmaCuerpoACuerpo(oWeapon1))
  {
    return oWeapon1;
  }

  oWeapon1 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oTarget);
  if (GetIsObjectValid(oWeapon1))
  {
    return oWeapon1;
  }

  oWeapon1 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oTarget);
  if (GetIsObjectValid(oWeapon1))
  {
    return oWeapon1;
  }

  return OBJECT_INVALID;

}

int GetSlashingWeapon2(object oItem)
{
    //Declare major variables
    int nItem = GetBaseItemType(oItem);

    if((nItem == BASE_ITEM_BASTARDSWORD) ||
      (nItem == BASE_ITEM_BATTLEAXE) ||
      (nItem == BASE_ITEM_DOUBLEAXE) ||
      (nItem == BASE_ITEM_GREATAXE) ||
      (nItem == BASE_ITEM_GREATSWORD) ||
      (nItem == BASE_ITEM_HALBERD) ||
      (nItem == BASE_ITEM_HANDAXE) ||
      (nItem == BASE_ITEM_KAMA) ||
      (nItem == BASE_ITEM_KATANA) ||
      (nItem == BASE_ITEM_KUKRI) ||
      (nItem == BASE_ITEM_LONGSWORD)||
      (nItem == BASE_ITEM_SCIMITAR)||
      (nItem == BASE_ITEM_SCYTHE)||
      (nItem == BASE_ITEM_SICKLE)||
      (nItem == BASE_ITEM_TWOBLADEDSWORD) ||
      (nItem == BASE_ITEM_DWARVENWARAXE) ||
      (nItem == BASE_ITEM_THROWINGAXE) ||
      (nItem == BASE_ITEM_WHIP) ||
      (nItem == 305) ||
      (nItem == 313) ||
      (nItem == 316) ||
      (nItem == 319) ||
      (nItem == 320) ||
      (nItem == 321) ||
      (nItem == 323) ||
      (nItem == 324) ||
      (nItem == 330) ||
      (nItem == 511) ||
      (nItem == 512))
   {
        return TRUE;
   }
   return FALSE;
}

//void main(){}
