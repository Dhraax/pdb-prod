//::///////////////////////////////////////////////
//:: Tailoring - Copy Main Weapon
//:: tlr_copymain.nss
//::
//:://////////////////////////////////////////////
/*
    Copy the model's weapon appearance to the
    PC's weapon
*/
//:://////////////////////////////////////////////
//:: Created By: Stacy L. Ropella
//:: from Mandragon's mil_tailor
//:://////////////////////////////////////////////

object oPC = GetPCSpeaker();

object CopyItemAppearance(object oSourceWeap, object oTarget);

void Seguridad (object oPC, object oItem, object oItemAnterior, object oItemEquipado);

void main()
{
    object oNPCItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);
    object oPCItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

    //int iCost = FloatToInt(IntToFloat(GetGoldPieceValue(oPCItem)) * 0.2f);
    //int iCost = GetGoldPieceValue(oNPCItem) + FloatToInt(IntToFloat(GetGoldPieceValue(oPCItem)) * 0.2f);
    int iCost = GetLocalInt(OBJECT_SELF, "CURRENTPRICE");
    if (GetGold(oPC) < iCost)
    {
        SendMessageToPC(oPC, "This weapon costs " + IntToString(iCost) + " gold to copy!");
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


object CopyItemAppearance(object oSourceWeap, object oCurrent)
{

    int iSourceWeapValue;
    object oNew;

////// Copy To Item
    oNew = CopyItem(oCurrent, GetPCSpeaker(), TRUE);
    DestroyObject(oCurrent);

////// Copy Colors
    // Top
    iSourceWeapValue = GetItemAppearance(oSourceWeap, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_TOP);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_TOP, iSourceWeapValue, TRUE);
    DestroyObject(oCurrent);

    // Middle
    iSourceWeapValue = GetItemAppearance(oSourceWeap, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_MIDDLE);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_MIDDLE, iSourceWeapValue, TRUE);
    DestroyObject(oCurrent);

    // Bottom
    iSourceWeapValue = GetItemAppearance(oSourceWeap, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_BOTTOM);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_BOTTOM, iSourceWeapValue, TRUE);
    DestroyObject(oCurrent);

////// Copy Design
    // Top
    iSourceWeapValue = GetItemAppearance(oSourceWeap, ITEM_APPR_TYPE_WEAPON_MODEL, ITEM_APPR_WEAPON_MODEL_TOP);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_WEAPON_MODEL, ITEM_APPR_WEAPON_MODEL_TOP, iSourceWeapValue, TRUE);
    DestroyObject(oCurrent);

    // Middle
    iSourceWeapValue = GetItemAppearance(oSourceWeap, ITEM_APPR_TYPE_WEAPON_MODEL, ITEM_APPR_WEAPON_MODEL_MIDDLE);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_WEAPON_MODEL, ITEM_APPR_WEAPON_MODEL_MIDDLE, iSourceWeapValue, TRUE);
    DestroyObject(oCurrent);

    // Bottom
    iSourceWeapValue = GetItemAppearance(oSourceWeap, ITEM_APPR_TYPE_WEAPON_MODEL, ITEM_APPR_WEAPON_MODEL_BOTTOM);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_WEAPON_MODEL, ITEM_APPR_WEAPON_MODEL_BOTTOM, iSourceWeapValue, TRUE);
    DestroyObject(oCurrent);

    return oNew;
}
