void main()
{
  object oPC = GetLastUsedBy();
  object oPuntoDeRuta = GetNearestObjectByTag("WP_dentrobanopub");

  AssignCommand(oPC, JumpToObject(oPuntoDeRuta));
  AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC)));
  AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_HEAD, oPC)));
  AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_ARMS, oPC)));
  AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC)));
  AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_BELT, oPC)));
  AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC)));
  AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_BOOTS, oPC)));
  AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC)));
  AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC)));
  AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC)));
  AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC)));
  AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC)));
  AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC)));
  AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC)));
  AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_LEFTRING, oPC)));
  AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_NECK, oPC)));
  AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)));
  AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oPC)));
}
