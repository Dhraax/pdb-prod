//::///////////////////////////////////////////////
//:: FileName tiendanocturna
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 06/05/2007 15:05:26
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

    // Comprobar si el PJ que habla tiene los objetos en su inventario
    if((!GetIsDay()) ||
    (GetIsDM(GetLastSpeaker())))
        return FALSE;

    return TRUE;
}
