#include "mti_libreria"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int iModo = StringToInt(GetScriptParam("Modo"));

    if(iModo == 1)
    {
        object oNPCItem = GetItemInSlot(INVENTORY_SLOT_CHEST, OBJECT_SELF);
        object oPCItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
        int iAC = GetArmorType(oNPCItem);
        string sOut = "<c þ >CA: " + IntToString(iAC) + "</c>\n";
        sOut += "(Nota: Solo podrás copiar armaduras con tu misma CA.)\n";
        sOut += "\n¿Desea continuar con el cambio?";
        SetCustomToken(9876, sOut);
        return TRUE;
    }
    if(iModo == 2)
    {
        object oNPCItem = GetItemInSlot(INVENTORY_SLOT_CHEST, OBJECT_SELF);
        int iAC = GetArmorType(oNPCItem);
        string sOut = "<c þ >CA actual: " + IntToString(iAC) + "</c>";
        SetCustomToken(9876, sOut);
        return TRUE;
    }
    return FALSE;
}
