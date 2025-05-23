//::///////////////////////////////////////////////
//:: Name: Q Can Craft Shields?
//:: FileName: q2_im_can_cs
//:: Website: http://www.qnwn.net
//:: Contact: projectq@qnwn.net
//:://////////////////////////////////////////////
/*
    Project Q - Release 1.5

    Return TRUE when
        - Has a valid shield in the left hand  AND
        - Shield is NOT plot

    Based on an original script by BioWare
*/
//:://////////////////////////////////////////////
//:: Created By: pstemarie
//:: Created On: 21 Dec 2011
//:://////////////////////////////////////////////

#include "x2_inc_itemprop"

#include "q_inc_switches"

int StartingConditional()
{
    if (GetModuleSwitchValue(MODULE_SWITCH_DISABLE_CRAFT_SKILLS_MENU) == TRUE)
    {
        return FALSE;
    }

    object oW = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,GetPCSpeaker());
    if (!GetIsObjectValid(oW))
    {
        return FALSE;
    }
    else if (GetPlotFlag(oW))
    {
        return FALSE;
    }
    int iShield = (( GetBaseItemType(oW) == BASE_ITEM_SMALLSHIELD ) ||
                   ( GetBaseItemType(oW) == BASE_ITEM_LARGESHIELD ) ||
                   ( GetBaseItemType(oW) == BASE_ITEM_TOWERSHIELD ));
    if (!iShield)
    {
        return FALSE;
    }

    if (!GetHasSkill(SKILL_CRAFT_ARMOR,GetPCSpeaker()))
    {
        return FALSE;
    }
    return TRUE;
}
