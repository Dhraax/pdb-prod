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

object oPC = GetLastUsedBy();
object oPase = GetItemPossessedBy (oPC, "pasedelacofradia");
int iBuscar = GetSkillRank (SKILL_SEARCH, oPC, FALSE);

    if( (oPase != OBJECT_INVALID) || (iBuscar >= 15))
    return TRUE;

    return FALSE;
}
