//::///////////////////////////////////////////////
//:: FileName vgz_cs_siraton
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 21/01/2008 15:07:24
//:://////////////////////////////////////////////
#include "mti_libreria"
int StartingConditional()
{

    // Inspeccionar las variables locales
    object oPC = GetPCSpeaker();
    if((ObtenerIntPersistente(oPC,"cs_ratones") == 0)  || (ObtenerIntPersistente(oPC,"cs_ratones") >= 7))
        return FALSE;

    return TRUE;
}
