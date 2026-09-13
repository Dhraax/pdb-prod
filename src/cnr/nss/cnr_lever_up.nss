/// ----------------------------------------------------------------------------
/// @system  CNR Crafting
/// @file    cnr_lever_up
/// @author  Dhraax
/// @brief   Lever conversation: moves the trade one level up.
/// ----------------------------------------------------------------------------

#include "cnr_i_lever"

void main()
{
    CnrLever_Move(GetPCSpeaker(), OBJECT_SELF, 1);
}
