/// ----------------------------------------------------------------------------
/// @system  CNR Harvesting
/// @file    cnr_skin_death
/// @author  Dhraax
/// @brief Preserve the original death flow and mark the existing corpse.
/// modified by: Dhraax
/// ----------------------------------------------------------------------------
#include "cnr_i_skin"
#include "corpse_functions"

void main()
{
    corpse_InitializeCorpse(OBJECT_SELF);
    CnrSkin_SpawnCorpse(OBJECT_SELF);
}
