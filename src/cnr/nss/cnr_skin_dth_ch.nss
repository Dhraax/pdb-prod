/// ----------------------------------------------------------------------------
/// @system  CNR Harvesting
/// @file    cnr_skin_dth_ch
/// @author  Dhraax
/// @brief   OnDeath of a skinnable creature that ran nw_ch_ac7, the henchman
///          and familiar handler. It leaves the corpse and then hands over.
/// ----------------------------------------------------------------------------
#include "cnr_i_skin"

void main()
{
    CnrSkin_SpawnCorpse(OBJECT_SELF);
    ExecuteScript("nw_ch_ac7", OBJECT_SELF);
}
