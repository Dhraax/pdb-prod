//::///////////////////////////////////////////////
//:: FileName if_magohechicrip
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 03/03/2006 21:32:51
//:://////////////////////////////////////////////
int StartingConditional()
{

    // Restricción basada en la clase de personaje
    int iPassed = 0;
    if(GetLevelByClass(CLASS_TYPE_SORCERER, GetPCSpeaker()) >= 1)
        iPassed = 1;
    if((iPassed == 0) && (GetLevelByClass(CLASS_TYPE_WIZARD, GetPCSpeaker()) >= 1))
        iPassed = 1;
    if((iPassed == 0) && (GetLevelByClass(CLASS_TYPE_PALE_MASTER, GetPCSpeaker()) >= 1))
        iPassed = 1;
    if((iPassed == 0) && (GetLevelByClass(CLASS_TYPE_CLERIC, GetPCSpeaker()) >= 1))
        iPassed = 1;
    if(iPassed == 0)
        return FALSE;

    return TRUE;
}
