//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 10/07/2007 3:33:45
//:://////////////////////////////////////////////
int StartingConditional()
{
    if(!(GetAbilityScore(GetPCSpeaker(), ABILITY_WISDOM, TRUE) > 9))
        return FALSE;
        if(!(GetAbilityScore(GetPCSpeaker(), ABILITY_INTELLIGENCE, TRUE) > 16))
        return FALSE;
    if(!(GetSkillRank(SKILL_CONCENTRATION, GetPCSpeaker(), TRUE) > 7))
        return FALSE;

    return TRUE;
}
