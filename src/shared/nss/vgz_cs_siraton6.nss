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
    object oTejon = GetNearestObjectByTag("cs_tejon",oPC);
    object oArea = GetArea(oTejon);
    if((ObtenerIntPersistente(oPC,"cs_ratones") != 10) || GetArea(oTejon) != GetArea(oPC))
        return FALSE;

    return TRUE;
}
