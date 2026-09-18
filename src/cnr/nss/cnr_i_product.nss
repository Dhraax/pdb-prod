/// ----------------------------------------------------------------------------
/// @system  CNR Crafting
/// @file    cnr_i_product
/// @author  Dhraax
/// @brief   Recipe identity and tier stored on newly crafted outputs.
/// ----------------------------------------------------------------------------

const string CNR_PRODUCT_RECIPE = "CNR_CRAFT_RECIPE";
const string CNR_PRODUCT_TIER = "CNR_CRAFT_TIER";

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

/// @brief Store recipe identity, tier and required output flags.
/// @param oItem Newly created crafting output.
/// @param iRecipe Recipe ID captured for the attempt.
/// @param iTier Recipe tier captured for the attempt.
void CnrProduct_Stamp(object oItem, int iRecipe, int iTier);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

void CnrProduct_Stamp(object oItem, int iRecipe, int iTier)
{
    SetLocalInt(oItem, CNR_PRODUCT_RECIPE, iRecipe);
    SetLocalInt(oItem, CNR_PRODUCT_TIER, iTier);
    SetIdentified(oItem, TRUE);
    SetStolenFlag(oItem, TRUE);
}
