#include "nw_i0_tool"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    string sIdioma = GetLocalString (OBJECT_SELF, "IDIOMA");

    if(HasItem(oPC, sIdioma))
        {
        return TRUE;
        }
    else{
        return FALSE;
        }
}
