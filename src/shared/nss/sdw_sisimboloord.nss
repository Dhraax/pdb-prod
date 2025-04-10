//::///////////////////////////////////////////////
//:: FileName vgz_mont_simont1
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 26/01/2008 19:31:20
//:://////////////////////////////////////////////
#include "mti_libreria"
int StartingConditional()
{
object oPC =GetPCSpeaker();
object oSimbolo = GetItemPossessedBy(oPC,"simbolodelaorden");
    if(oSimbolo == OBJECT_INVALID)
    return FALSE;

    return TRUE;
}
