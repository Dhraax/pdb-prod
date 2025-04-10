//Created by 420 for the CEP
//Copy NPC cloak to PC cloak
//Based on script tlr_copynpchelm.nss by Stacy L. Ropella
object oPC = GetPCSpeaker();

object CopyItemAppearance(object oSource, object oTarget);
int CompareAC(object oFirst, object oSecond);

// Get a Cached 2DA string.  If its not cached read it from the 2DA file and cache it.
string GetCachedACBonus(string sFile, int iRow);
void Seguridad (object oPC, object oItem, object oItemAnterior, object oItemEquipado);
void main()
{
    object oNPCItem = GetItemInSlot(INVENTORY_SLOT_CLOAK, OBJECT_SELF);
    object oPCItem = GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC);

    //int iCost = GetGoldPieceValue(oNPCItem) + FloatToInt(IntToFloat(GetGoldPieceValue(oPCItem)) * 0.2f);
    int iCost = GetLocalInt(OBJECT_SELF, "CURRENTPRICE");

    if (GetGold(oPC) < iCost) {
        SendMessageToPC(oPC, "This outfit costs" + IntToString(iCost) + " gold to copy!");
        return;
    }

    TakeGoldFromCreature(iCost, oPC, TRUE);
    object oOrignal = CopyItem(oPCItem, OBJECT_SELF, TRUE);

    // Copy the appearance
    object oNew = CopyItemAppearance(oNPCItem, oOrignal);
    SetLocalInt(oNew, "mil_EditingItem", TRUE);

    // Copy the armor back to the PC
    object oOnPC = CopyItem(oNew, oPC, TRUE);

    //Se añade un sistema de seguridad.
    DelayCommand(0.5,Seguridad (oPC, oOnPC, oNew, oPCItem));

    //Seguridad antispam
    SetLocalInt(OBJECT_SELF,"MilSeguridad", 1);
    DelayCommand(5.0, DeleteLocalInt(OBJECT_SELF, "MilSeguridad"));
    SendMessageToPC(oPC,"<c´$$>Debes esperar 5 segundos para volver a hablar con el sastre por seguridad.</c>");
}

void Seguridad (object oPC, object oItem, object oItemAnterior, object oItemEquipado)
{
    if(GetItemPossessor(oItem) != oPC)
    {
       object oNuevo = CopyItem(oItemAnterior, oPC, TRUE);
       DelayCommand(0.5, Seguridad (oPC, oNuevo, oItemAnterior, oItemEquipado));
    }
    else if(GetItemPossessor(oItem) == oPC)
    {
        // Equip the armor
        DelayCommand(0.5, AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_CHEST)));
        DestroyObject(oItemEquipado);
        // Set armor editable again
        DelayCommand(3.0, DeleteLocalInt(oItem, "mil_EditingItem"));
    }
    DestroyObject(oItemAnterior);
}

object CopyItemAppearance(object oSource, object oTarget) {
    object oChest = GetObjectByTag("ClothingBuilder");

    int iSourceValue;
    object oCurrent, oNew;

////// Copy To Chest
    oCurrent = oTarget;
    oNew = CopyItem(oCurrent, oChest, TRUE);
    DestroyObject(oCurrent);

////// Copy Colors
    // Cloth 1
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH1);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH1, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Cloth 2
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH2);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH2, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Leather 1
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER1);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER1, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Leather 2
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER2);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER2, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Metal 1
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL1);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL1, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Metal 2
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL2);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL2, iSourceValue, TRUE);
    DestroyObject(oCurrent);


////// Copy Design
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_SIMPLE_MODEL, 0);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    return oNew;
}
