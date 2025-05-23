//::///////////////////////////////////////////////
//:: FileName if_lentemichelle
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 16/03/2006 17:56:35
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

    // Comprobar si el PJ que habla tiene los objetos en su inventario
    if(!HasItem(GetPCSpeaker(), "golemfeliz"))
        return FALSE;

    return TRUE;
}
