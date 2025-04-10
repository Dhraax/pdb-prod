//::///////////////////////////////////////////////
//:: FileName if_solturanigrom
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 24/04/2006 12:32:28
//:://////////////////////////////////////////////
int StartingConditional()
{

    // Restricción basada en la clase de personaje
    int iPassed = 0;
    if((GetLevelByClass(CLASS_TYPE_PALE_MASTER, GetPCSpeaker()) >= 3)||GetHasFeat(FEAT_SPELL_FOCUS_NECROMANCY, GetPCSpeaker()))
        iPassed = 1;
    if(iPassed == 0)
        return FALSE;

    return TRUE;
}
