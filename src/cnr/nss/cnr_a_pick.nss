/// ----------------------------------------------------------------------------
/// @system  CNR Crafting
/// @file    cnr_a_pick
/// @author  Dhraax
/// @brief   Selects list line "idx": descend, pick a product, or open the
///          detail.
/// modified by: Dhraax
/// ----------------------------------------------------------------------------

#include "cnr_i_craft"

void main()
{
    object oPC = GetPCSpeaker();
    int nIdx = StringToInt(GetScriptParam("idx"));
    int nId  = CnrCraft_GetListId(oPC, nIdx);

    if (nId <= 0)
    {
        return;
    }

    // What the id means is decided by the list it came from, never guessed
    // from leftover state.
    int nMode = GetLocalInt(oPC, CNR_VAR_LISTMODE);

    if (nMode == CNR_LIST_VARIANTS)
    {
        // One of the products this recipe offers. It is only remembered here;
        // whether the recipe really offers it is asked again, of the database,
        // before anything is charged.
        SetLocalInt(oPC, CNR_VAR_VARIANT, nId);
        SetLocalInt(oPC, CNR_VAR_LISTMODE, CNR_LIST_NONE);
        CnrCraft_SetDetailToken(oPC, GetLocalObject(oPC, CNR_VAR_PLACEABLE));
        return;
    }

    // Navigating always leaves the detail screen.
    DeleteLocalInt(oPC, CNR_VAR_RECIPE);
    DeleteLocalInt(oPC, CNR_VAR_VARIANT);
    DeleteLocalString(oPC, CNR_VAR_VGROUP);

    if (nMode == CNR_LIST_RECIPES)
    {
        CnrCraft_SelectRecipe(oPC, nId);

        // A recipe that offers a group asks what to make before it shows the
        // detail; one with a fixed product goes straight there, as always.
        SetLocalInt(oPC, CNR_VAR_PAGE, 0);
        if (CnrCraft_ListVariants(oPC) > 0)
        {
            CnrCraft_SetSlotTokens(oPC);
            return;
        }

        CnrCraft_SetDetailToken(oPC, GetLocalObject(oPC, CNR_VAR_PLACEABLE));
        return;
    }

    // A category with children keeps browsing; a leaf shows its recipes.
    SetLocalInt(oPC, CNR_VAR_PAGE, 0);
    if (CnrCraft_ListCategories(oPC, nId) == 0)
    {
        CnrCraft_ListRecipes(oPC, nId, 0);
    }

    CnrCraft_SetSlotTokens(oPC);
}
