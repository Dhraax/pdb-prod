//::///////////////////////////////////////////////
//:: FileName ukiconj_req_amdm
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 10/07/2007 3:33:45
//:://////////////////////////////////////////////
int StartingConditional()
{
    object oPC = GetPCSpeaker();

    int iNivelGuerrero = GetLevelByClass(CLASS_TYPE_FIGHTER, oPC);
    int iNivelMdarmas = GetLevelByClass(CLASS_TYPE_WEAPON_MASTER, oPC);

    if(!(GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE) >= 16))
        return FALSE;
    if(!(GetAbilityScore(oPC, ABILITY_DEXTERITY, TRUE) >= 12))
        return FALSE;
    // Restricción basada en la clase de personaje
    int iPassed = 0;
    if(iNivelGuerrero + iNivelMdarmas >= 10)
        iPassed = 1;
    if(iPassed == 0)
        return FALSE;

    return TRUE;
}
