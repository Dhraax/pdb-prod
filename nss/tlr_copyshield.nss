//::///////////////////////////////////////////////
//:: Tailoring - Copy Shield
//:: tlr_copyshield.nss
//::
//:://////////////////////////////////////////////
/*
    Copy the model's shield appearance to PC's shield
*/
//:://////////////////////////////////////////////
//:: Created By: Stacy L. Ropella
//:: from Mandragon's mil_tailor
//:://////////////////////////////////////////////


object oPC = GetPCSpeaker();

object CopyItemAppearance(object oSourceShield, object oTarget);
void Seguridad (object oPC, object oItem, object oItemAnterior, object oItemEquipado);
void main()
{
    object oNPCItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, OBJECT_SELF);
    object oPCItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);

    //int iCost = FloatToInt(IntToFloat(GetGoldPieceValue(oPCItem)) * 0.2f);
    //int iCost = GetGoldPieceValue(oNPCItem) + FloatToInt(IntToFloat(GetGoldPieceValue(oPCItem)) * 0.2f);
    int iCost = GetLocalInt(OBJECT_SELF, "CURRENTPRICE");
    if (GetGold(oPC) < iCost)
    {
        SendMessageToPC(oPC, "This shield costs " + IntToString(iCost) + " gold to copy!");
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

object CopyItemAppearance(object oSourceShield, object oCurrent)
{
    int iSourceShieldValue;
    object oNew;

////// Copy To Item

    oNew = CopyItem(oCurrent, GetPCSpeaker(), TRUE);
    DestroyObject(oCurrent);


////// Copy Design
    // Shield
    iSourceShieldValue = GetItemAppearance(oSourceShield, ITEM_APPR_TYPE_SIMPLE_MODEL, 0);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, iSourceShieldValue, TRUE);
    DestroyObject(oCurrent);

    return oNew;
}
