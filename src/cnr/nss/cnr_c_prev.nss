/// ----------------------------------------------------------------------------
/// @system  CNR Crafting
/// @file    cnr_c_prev
/// @author  Dhraax
/// @brief   Shows [previous page] when not on the first one.
/// ----------------------------------------------------------------------------

#include "cnr_i_craft"

int StartingConditional()
{
    return GetLocalInt(GetPCSpeaker(), CNR_VAR_PAGE) > 0;
}
