//::///////////////////////////////////////////////
//:: FileName sute_her_c_t_15
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 07/11/2006 19:52:16
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

    // Comprobar si el PJ que habla tiene los objetos en su inventario
    if(!HasItem(GetPCSpeaker(), "lingoteMithril"))
        return FALSE;

    return TRUE;
}
