/// ----------------------------------------------------------------------------
/// @system  CNR Crafting
/// @file    cnr_a_page
/// @author  Dhraax
/// @brief   Moves one page forward or back.
/// modified by: Dhraax
/// ----------------------------------------------------------------------------

#include "cnr_i_craft"

void main()
{
    object oPC = GetPCSpeaker();
    int nStep = StringToInt(GetScriptParam("idx"));
    int nPage = GetLocalInt(oPC, CNR_VAR_PAGE) + nStep;

    if (nPage < 0)
    {
        nPage = 0;
    }

    // Reload the list that is actually on screen. Reading a "browsing recipes"
    // flag instead answered wrong on the variant screen, which is entered from
    // the recipe list and therefore inherited it: paging there refilled the
    // slots with recipes while the screen still asked which product to make.
    switch (GetLocalInt(oPC, CNR_VAR_LISTMODE))
    {
        case CNR_LIST_VARIANTS:
            SetLocalInt(oPC, CNR_VAR_PAGE, nPage);
            CnrCraft_ListVariants(oPC);
            break;

        case CNR_LIST_RECIPES:
            CnrCraft_ListRecipes(oPC, GetLocalInt(oPC, CNR_VAR_CATEGORY), nPage);
            break;

        case CNR_LIST_CATEGORIES:
            SetLocalInt(oPC, CNR_VAR_PAGE, nPage);
            CnrCraft_ListCategories(oPC, GetLocalInt(oPC, CNR_VAR_PARENT));
            break;
    }

    CnrCraft_SetSlotTokens(oPC);
}
