/// ----------------------------------------------------------------------------
/// @system  CNR Harvesting
/// @file    cnr_skin_dth_ch
/// @author  Dhraax
/// @brief Preserve the original death flow and mark the existing corpse.
/// modified by: Dhraax
/// ----------------------------------------------------------------------------
#include "cnr_i_skin"
#include "corpse_functions"

void main()
{
    ExecuteScript("nw_ch_ac7", OBJECT_SELF);
    corpse_InitializeCorpse(OBJECT_SELF);
    CnrSkin_SpawnCorpse(OBJECT_SELF);
}
