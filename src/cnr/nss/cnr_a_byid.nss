/// ----------------------------------------------------------------------------
/// @system  CNR Crafting
/// @file    cnr_a_byid
/// @author  Dhraax
/// @brief   Opens the recipe whose id the player typed.
/// modified by: Dhraax
/// ----------------------------------------------------------------------------

#include "cnr_i_craft"

void main()
{
    object oPC = GetPCSpeaker();
    int nId = GetLocalInt(oPC, CNR_VAR_TYPED_ID);

    if (nId <= 0 || !CnrCraft_SelectRecipe(oPC, nId))
    {
        // Nothing is left half-selected behind a rejected id.
        DeleteLocalInt(oPC, CNR_VAR_RECIPE);
        DeleteLocalInt(oPC, CNR_VAR_VARIANT);
        DeleteLocalString(oPC, CNR_VAR_VGROUP);
        SendMessageToPC(oPC, "No existe ninguna receta con ese ID.");
        return;
    }

    // A typed id gets the same treatment as one picked from the list: a recipe
    // that offers several products asks which one first. Without this the id
    // route dropped straight onto the detail of a recipe with no product
    // chosen, where Fabricar could only answer that one had to be chosen and
    // the screen offered no way to do it.
    SetLocalInt(oPC, CNR_VAR_PAGE, 0);
    if (CnrCraft_ListVariants(oPC) > 0)
    {
        CnrCraft_SetSlotTokens(oPC);
        return;
    }

    CnrCraft_SetDetailToken(oPC, GetLocalObject(oPC, CNR_VAR_PLACEABLE));
}
