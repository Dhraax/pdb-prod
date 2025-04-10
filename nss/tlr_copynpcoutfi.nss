//::///////////////////////////////////////////////
//:: Tailor - Copy NPC Outfit TO PC
//:: tlr_copynpcoutfi.nss
//:: Copyright (c) 2003 Jake E. Fitch
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Jake E. Fitch (Milambus Mandragon)
//:: Created On: March 9, 2004
//:://////////////////////////////////////////////

object oPC = GetPCSpeaker();

object CopyItemAppearance(object oSource, object oTarget);
int CompareAC(object oFirst, object oSecond);

// Get a Cached 2DA string.  If its not cached read it from the 2DA file and cache it.
string GetCachedACBonus(string sFile, int iRow);

void Seguridad (object oPC, object oItem, object oItemAnterior, object oItemEquipado);

void main()
{
    object oNPCItem = GetItemInSlot(INVENTORY_SLOT_CHEST, OBJECT_SELF);
    object oPCItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);

    //int iCost = GetGoldPieceValue(oNPCItem) + FloatToInt(IntToFloat(GetGoldPieceValue(oPCItem)) * 0.2f);
    int iCost = GetLocalInt(OBJECT_SELF, "CURRENTPRICE");

    if (GetGold(oPC) < iCost) {
        SendMessageToPC(oPC, "¡Este atuendo cuesta " + IntToString(iCost) + " monedas de oro copiarlo!");
        return;
    }

    if (!CompareAC(oNPCItem, oPCItem)) {
        SendMessageToPC(oPC, "Sólo puedes copiar apariencias de objetos con los mismos valores de CA.");
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
    // Belt
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_BELT);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_BELT, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Left Bicep
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LBICEP);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LBICEP, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Left Foot
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LFOOT);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LFOOT, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Left Forearm
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LFOREARM);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LFOREARM, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Left Hand
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LHAND);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LHAND, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Left Shin
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LSHIN);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LSHIN, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Left Shoulder
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LSHOULDER);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LSHOULDER, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Left Thigh
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LTHIGH);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LTHIGH, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Neck
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_NECK);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_NECK, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Pelvis
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_PELVIS);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_PELVIS, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Right Bicep
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RBICEP);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RBICEP, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Right Foot
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RFOOT);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RFOOT, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Right Forearm
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RFOREARM);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RFOREARM, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Right Hand
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RHAND);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RHAND, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Right Shin
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RSHIN);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RSHIN, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Right Shoulder
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RSHOULDER);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RSHOULDER, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Right Thigh
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RTHIGH);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RTHIGH, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Robe
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_ROBE);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_ROBE, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    // Torso
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO, iSourceValue, TRUE);
    DestroyObject(oCurrent);

    return oNew;
}

int CompareAC(object oFirst, object oSecond) {
    int iFirstApp = GetItemAppearance(oFirst, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO);
    int iSecondApp = GetItemAppearance(oSecond, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO);

    string sFirstAC = GetCachedACBonus("parts_chest", iFirstApp);
    string sSecondAC = GetCachedACBonus("parts_chest", iSecondApp);

    return (StringToInt(sFirstAC) == StringToInt(sSecondAC));
}

string GetCachedACBonus(string sFile, int iRow) {
    string sACBonus = GetLocalString(GetModule(), sFile + IntToString(iRow));

    if (sACBonus == "") {
        sACBonus = Get2DAString(sFile, "ACBONUS", iRow);

        if (sACBonus == "") {
            sACBonus = "-1";

            string sCost = Get2DAString(sFile, "COSTMODIFIER", iRow);
            if (sCost == "" ) sACBonus = "-2";
        }

        SetLocalString(GetModule(), sFile + IntToString(iRow), sACBonus);
    }

    return sACBonus;
}
