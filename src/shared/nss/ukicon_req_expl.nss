//::///////////////////////////////////////////////
//:: FileName ukiconj_req_amdm
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 10/07/2007 3:33:45
//:://////////////////////////////////////////////
int StartingConditional()
{
    if(!(GetAbilityScore(GetPCSpeaker(), ABILITY_INTELLIGENCE, TRUE) > 13))
        return FALSE;
    if(!(GetAbilityScore(GetPCSpeaker(), ABILITY_WISDOM, TRUE) > 9))
        return FALSE;
    if(!(GetSkillRank(SKILL_SPELLCRAFT, GetPCSpeaker(), TRUE) > 9))
        return FALSE;
    if(!(GetSkillRank(SKILL_CONCENTRATION, GetPCSpeaker(), TRUE) > 9))
        return FALSE;
    if(!(GetAlignmentGoodEvil(GetPCSpeaker()) == ALIGNMENT_EVIL))
        return FALSE;
    // Restricción basada en la clase de personaje
    int iPassed = 0;
    if(GetLevelByClass(CLASS_TYPE_PALE_MASTER, GetPCSpeaker()) >= 3)
        iPassed = 1;
    if(iPassed == 0)
        return FALSE;

    return TRUE;
}
