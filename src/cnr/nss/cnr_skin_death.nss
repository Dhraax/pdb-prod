/// ----------------------------------------------------------------------------
/// @system  CNR Harvesting
/// @file    cnr_skin_death
/// @author  Dhraax
/// @brief   OnDeath of a skinnable creature whose blueprint had no death script
///          of its own. It only leaves the corpse.
/// ----------------------------------------------------------------------------
#include "cnr_i_skin"

void main()
{
    CnrSkin_SpawnCorpse(OBJECT_SELF);
}
