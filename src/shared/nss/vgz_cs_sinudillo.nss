//::///////////////////////////////////////////////
//:: FileName vgz_cs_sicalaver
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 19/01/2008 16:07:42
//:://////////////////////////////////////////////
#include "mti_libreria"
int StartingConditional()
{

    // Inspeccionar las variables locales
    if(!(GetItemPossessedBy(GetPCSpeaker(),"NW_IT_MSMLMISC13") != OBJECT_INVALID))
        return FALSE;

    return TRUE;
}
