
//::///////////////////////////////////////////////
//:: FileName avistar_normal
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Asyel
//:: Created On: 26/03/2009 22:57:22
//:://////////////////////////////////////////////


int StartingConditional()
{

    if (GetSkillRank(SKILL_SPOT, GetPCSpeaker()) + d10()  >= 10)
    {
       return TRUE;
    }
       return FALSE;



    // Realizar las pruebas de habilidad

    /*if(!(AutoDC(35, SKILL_APPRAISE, GetPCSpeaker())))
        return FALSE;

    return TRUE;     */
}

