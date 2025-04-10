
//::///////////////////////////////////////////////
//:: FileName saberpopular_normal
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Asyel
//:: Created On: 26/03/2009 22:57:22
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

    if (GetSkillRank(SKILL_LORE, GetPCSpeaker()) + d10() >= 15)
    {
       return TRUE;
    }
       return FALSE;


    // Realizar las pruebas de habilidad
   /* if(!(AutoDC(45, SKILL_LORE, GetPCSpeaker())))
        return FALSE;

    return TRUE;   */
}


