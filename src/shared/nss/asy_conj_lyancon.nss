//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 11/07/2007 1:45:20
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

    // Comprobar si el PJ que habla tiene los objetos en su inventario
    if(HasItem(GetPCSpeaker(), "asy_detecmuerto"))
        return FALSE;

    return TRUE;
}
