//::///////////////////////////////////////////////
//:: FileName pb_x_si_mag_hech
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 03/08/2005 13:20:50
//:://////////////////////////////////////////////
int StartingConditional()
{

    // Restricción basada en la clase de personaje
    int iPassed = 0;
    if(GetLevelByClass(CLASS_TYPE_CLERIC, GetPCSpeaker()) >= 1)
        iPassed = 1;
    if((iPassed == 0) && (GetLevelByClass(CLASS_TYPE_DRUID, GetPCSpeaker()) >= 1))
        iPassed = 1;
    if(iPassed == 0)
        return FALSE;

    return TRUE;
}
