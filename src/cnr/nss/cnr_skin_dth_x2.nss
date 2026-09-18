/// ----------------------------------------------------------------------------
/// @system  CNR Harvesting
/// @file    cnr_skin_dth_x2
/// @author  Dhraax
/// @brief Preserve the original death flow and mark the existing corpse.
/// modified by: Dhraax
/// ----------------------------------------------------------------------------
#include "cnr_i_skin"
#include "corpse_functions"

void main()
{
    ExecuteScript("x2_def_ondeath", OBJECT_SELF);
    corpse_InitializeCorpse(OBJECT_SELF);
    CnrSkin_SpawnCorpse(OBJECT_SELF);
}
