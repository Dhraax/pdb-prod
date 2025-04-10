#include "nw_i0_tool"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    string sItemToCheck = GetScriptParam("OBJETO");

    // Comprobar si el PJ que habla tiene el objeto en su inventario
    if(HasItem(oPC, sItemToCheck)) return TRUE;

    return FALSE;
}


