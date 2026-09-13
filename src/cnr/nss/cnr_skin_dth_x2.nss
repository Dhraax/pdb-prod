/// ----------------------------------------------------------------------------
/// @system  CNR Harvesting
/// @file    cnr_skin_dth_x2
/// @author  Dhraax
/// @brief   OnDeath of a skinnable creature that ran x2_def_ondeath. It leaves
///          the corpse and then hands over to the original handler, which is
///          part of the game and is not overridden here.
/// ----------------------------------------------------------------------------
#include "cnr_i_skin"

void main()
{
    CnrSkin_SpawnCorpse(OBJECT_SELF);
    ExecuteScript("x2_def_ondeath", OBJECT_SELF);
}
