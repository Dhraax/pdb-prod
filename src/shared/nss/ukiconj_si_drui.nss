//::///////////////////////////////////////////////
//:: FileName ukiconj_si_maghe
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 11/07/2007 1:27:41
//:://////////////////////////////////////////////
int StartingConditional()
{

    // Restricción basada en la clase de personaje
    int iPassed = 0;
    if(GetLevelByClass(CLASS_TYPE_DRUID, GetPCSpeaker()) >= 1)
        iPassed = 1;
    if(iPassed == 0)
        return FALSE;

    return TRUE;
}
