//::///////////////////////////////////////////////
//:: FileName vgz_cs_ninfassi1
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 22/01/2008 1:46:51
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

    // Comprobar si el PJ que habla tiene los objetos en su inventario
    if(!HasItem(GetPCSpeaker(), "espejodeplatasilver"))
        return FALSE;

    return TRUE;
}
