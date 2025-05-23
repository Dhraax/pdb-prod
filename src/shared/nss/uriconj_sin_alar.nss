
#include "nw_i0_tool"

int StartingConditional()
{

    // Comprobar si el PJ que habla tiene los objetos en su inventario
    if(HasItem(GetPCSpeaker(), "sute_s_alarm"))
        return FALSE;

    return TRUE;
}
