/// ----------------------------------------------------------------------------
/// @system  CNR Crafting
/// @file    cnr_a_back
/// @author  Dhraax
/// @brief   Goes up one level.
/// modified by: Dhraax
/// ----------------------------------------------------------------------------

#include "cnr_i_craft"

void main()
{
    object oPC = GetPCSpeaker();
    int nMode = GetLocalInt(oPC, CNR_VAR_LISTMODE);
    int iRecipePage = GetLocalInt(oPC, CNR_VAR_RECIPE_PAGE);

    // From the list of products of a recipe, back means the recipe list, not
    // the categories: the crafter picked a metal and wants another metal, or
    // wants to look at the list again.
    if (nMode == CNR_LIST_VARIANTS)
    {
        DeleteLocalInt(oPC, CNR_VAR_RECIPE);
        DeleteLocalInt(oPC, CNR_VAR_VARIANT);
        DeleteLocalString(oPC, CNR_VAR_VGROUP);
        SetLocalInt(oPC, CNR_VAR_PAGE, iRecipePage);
        CnrCraft_ListRecipes(oPC, GetLocalInt(oPC, CNR_VAR_CATEGORY), iRecipePage);
        CnrCraft_SetSlotTokens(oPC);
        return;
    }

    int bWasOnDetail = GetLocalInt(oPC, CNR_VAR_RECIPE) > 0;

    DeleteLocalInt(oPC, CNR_VAR_RECIPE);
    DeleteLocalInt(oPC, CNR_VAR_VARIANT);
    DeleteLocalString(oPC, CNR_VAR_VGROUP);
    SetLocalInt(oPC, CNR_VAR_PAGE, 0);

    // One rung at a time. From a recipe's detail, back is the recipe list it
    // was picked from; from that list, the categories; and from the categories,
    // out to the action menu, which is what an empty list means.
    if (bWasOnDetail)
    {
        SetLocalInt(oPC, CNR_VAR_PAGE, iRecipePage);
        CnrCraft_ListRecipes(oPC, GetLocalInt(oPC, CNR_VAR_CATEGORY), iRecipePage);
        CnrCraft_SetSlotTokens(oPC);
        return;
    }

    if (nMode == CNR_LIST_RECIPES)
    {
        CnrCraft_ListCategories(oPC, 0);
        CnrCraft_SetSlotTokens(oPC);
        return;
    }

    CnrCraft_ClearList(oPC);
}
