//::///////////////////////////////////////////////
//:: FileName hen_resu2
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 06/04/2019 18:53:23
//:://////////////////////////////////////////////
int StartingConditional()
{

    // Restrict based on the player's class
    int iPassed = 0;
    if(GetLevelByClass(49, GetPCSpeaker()) >= 1)
        iPassed = 1;
    if((iPassed == 0) && (GetLevelByClass(44, GetPCSpeaker()) >= 1))
        iPassed = 1;
    if((iPassed == 0) && (GetLevelByClass(CLASS_TYPE_FIGHTER, GetPCSpeaker()) >= 16))
        iPassed = 1;
    if(iPassed == 0)
        return FALSE;

    return TRUE;
}
