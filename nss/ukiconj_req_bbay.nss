//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 10/07/2007 3:33:45
//:://////////////////////////////////////////////
int StartingConditional()
{
    if(!(GetAbilityScore(GetPCSpeaker(), ABILITY_WISDOM, TRUE) > 15))
        return FALSE;
    if(!(GetSkillRank(SKILL_CONCENTRATION, GetPCSpeaker(), TRUE) > 4))
        return FALSE;
    // Restricción basada en la clase de personaje
    int iPassed = 0;
    if(GetLevelByClass(CLASS_TYPE_DRUID, GetPCSpeaker()) >= 4)
        iPassed = 1;
    if(iPassed == 0)
        return FALSE;

    return TRUE;
}
