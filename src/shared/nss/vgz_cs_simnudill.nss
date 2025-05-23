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
    if(!(ObtenerIntPersistente(GetPCSpeaker(),"vgz_cs_nudillohecho") == 0))
        return FALSE;
    else if (!(ObtenerIntPersistente(GetPCSpeaker(),"vgz_cs_nudillo") >= 50))
        return FALSE;

    return TRUE;
}
