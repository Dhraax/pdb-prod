//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 10/07/2007 3:33:45
//:://////////////////////////////////////////////
int StartingConditional()
{
    if(!(GetAbilityScore(GetPCSpeaker(), ABILITY_WISDOM, TRUE) > 9))
        return FALSE;
    if(!(GetAbilityScore(GetPCSpeaker(), ABILITY_CHARISMA, TRUE) > 9))
        return FALSE;
    if(!(GetSkillRank(SKILL_CONCENTRATION, GetPCSpeaker(), TRUE) > 9))
        return FALSE;
        if(!(GetSkillRank(SKILL_SPELLCRAFT, GetPCSpeaker(), TRUE) > 9))
        return FALSE;
    // Restricción basada en la clase de personaje
    int iPassed = 0;
    if(GetLevelByClass(CLASS_TYPE_SORCERER, GetPCSpeaker()) >= 12)
        iPassed = 1;
    if((iPassed == 0) && (GetLevelByClass(CLASS_TYPE_WIZARD, GetPCSpeaker()) >= 12))
        iPassed = 1;
    if(iPassed == 0)
        return FALSE;

    return TRUE;
}
