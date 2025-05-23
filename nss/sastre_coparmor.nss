#include "nwnx_item"
#include "mti_libreria"

int CompareAC(object oFirst, object oSecond);
string GetCachedACBonus(string sFile, int iRow);

void main()
{
    object oPC = GetPCSpeaker();
    object oNPCItem = GetItemInSlot(INVENTORY_SLOT_CHEST, OBJECT_SELF);
    object oPCItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    //CA de la armadura del PNJ.
    int CAPNJ = GetArmorType(oNPCItem);
    //CA de la armadura del PJ.
    int CAPJ = GetArmorType(oPCItem);
    //Si ambas CAs no coinciden, cancelamos.
    if (CAPNJ != CAPJ)
    {
        SendMessageToPC(oPC, "<c´$$> Solo puedes cambiar armaduras con la misma CA base.</c>");
        return;
    }

    //Copiamos la apariencia del item del PNJ.
    string sAparienciaActual = NWNX_Item_GetEntireItemAppearance(oNPCItem);
    //Le aplicamos la apariencia al item que tiene puesto el PJ ahora mismo.
    NWNX_Item_RestoreItemAppearance(oPCItem,sAparienciaActual);
    //Copiamos el item del PJ en el PJ.
    object oCopiaPC = CopyItem(oPCItem, OBJECT_INVALID, TRUE);
    SetLocalInt(oCopiaPC, "mil_EditingItem",TRUE);
    //Destruimos el item desactualizado.
    DestroyObject(oPCItem);

    //Equipamos el item nuevo.
    DelayCommand(0.5f, AssignCommand(oPC, ActionEquipItem(oCopiaPC, INVENTORY_SLOT_CHEST)));

    // Set armor editable again
    DelayCommand(3.0f, DeleteLocalInt(oCopiaPC, "mil_EditingItem"));
}

