//::///////////////////////////////////////////////
//:: FileName sute_her_c_t_lib
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 07/11/2006 18:48:45
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

    // Comprobar si el PJ que habla no tiene los objetos en su inventario
    if(HasItem(GetPCSpeaker(), "libroHerboristeria"))
        return FALSE;

    return TRUE;
}
