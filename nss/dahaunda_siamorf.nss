//::///////////////////////////////////////////////
//:: FileName dahaunda_siamorf
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 09/02/2006 16:43:50
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

    // Comprobar si el PJ que habla tiene los objetos en su inventario
    if(!HasItem(GetPCSpeaker(), "Siamorfhe"))
        return TRUE;

    return FALSE;
}
