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
    int iHora = GetTimeHour() ;
    // Comprobar si es horario laborar, o si es DM o si es vampiro el que vende (la variable VAMPITIENDA es 1)
    /*if (((iHora > 6)&&(iHora < 23)) ||
        (GetIsDM(GetLastSpeaker()))||
        (GetLocalInt (OBJECT_SELF, "VAMPITIENDA")==1))
        return FALSE; */
    //Si no son ni las 3, ni las 4, si es un DM o es una tienda con la variable VAMPITIENDA.
    if (iHora != 4 && iHora != 3 ||
        (GetIsDM(GetLastSpeaker()))||
        (GetLocalInt (OBJECT_SELF, "VAMPITIENDA")==1))
        return FALSE;
    else
    {
        return TRUE;
    }
}
