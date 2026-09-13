/// ----------------------------------------------------------------------------
/// @system  CNR Crafting
/// @file    cnr_lever_down
/// @author  Dhraax
/// @brief   Lever conversation: moves the trade one level down.
/// ----------------------------------------------------------------------------

#include "cnr_i_lever"

void main()
{
    CnrLever_Move(GetPCSpeaker(), OBJECT_SELF, -1);
}
