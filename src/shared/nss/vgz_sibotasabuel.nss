//::///////////////////////////////////////////////
//:: FileName ukiconj_si_maghe
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 11/07/2007 1:27:41
//:://////////////////////////////////////////////
#include "mti_libreria"
int StartingConditional()
{

    // Restricción basada en la clase de personaje
    object oPC = GetPCSpeaker();
    int iPassed = 0;
    if(GetItemPossessedBy(oPC,"_botasdelabuelete") != OBJECT_INVALID && ObtenerIntPersistente(oPC,"vgz_lustrabotasabuelete") == 0)
        iPassed = 1;
    if(iPassed == 0)
        return FALSE;

    return TRUE;
}
