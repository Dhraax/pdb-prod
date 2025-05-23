#include "nwnx_item"

object oPC = GetPCSpeaker();

object CopyItemAppearance(object oSource, object oTarget);
int CompareAC(object oFirst, object oSecond);
string GetCachedACBonus(string sFile, int iRow);

void main()
{
    object oNPCItem = GetItemInSlot(INVENTORY_SLOT_CLOAK, OBJECT_SELF);
    object oPCItem = GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC);

    //Copiamos la apariencia del item del PNJ.
    string sAparienciaActual = NWNX_Item_GetEntireItemAppearance(oNPCItem);
    //Le aplicamos la apariencia al item que tiene puesto el PJ ahora mismo.
    NWNX_Item_RestoreItemAppearance(oPCItem,sAparienciaActual);
    //Copiamos el item del PJ en el PJ.
    object oCopiaPC = CopyItem(oPCItem, OBJECT_INVALID, TRUE);
    //Ponemos un enfriamiento al editar este item.
    SetLocalInt(oCopiaPC, "mil_EditingItem", TRUE);
    //Destruimos el item desactualizado.
    DestroyObject(oPCItem);

    //Equipamos el item nuevo.
    DelayCommand(0.5f, AssignCommand(oPC, ActionEquipItem(oCopiaPC, INVENTORY_SLOT_CLOAK)));

    //Volvemos a dejar que se pueda editar.
    DelayCommand(3.0f, DeleteLocalInt(oCopiaPC, "mil_EditingItem"));
}
