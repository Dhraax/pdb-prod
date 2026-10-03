/// ----------------------------------------------------------------------------
/// @system  CNR Almacen
/// @file    sapo_alma_beat
/// @brief   Close an abandoned material session using the same accounting path.
/// modified by: Dhraax
/// ----------------------------------------------------------------------------

#include "cnr_i_store"

void main()
{
    if (!AlmSessionActive(OBJECT_SELF))
    {
        AlmRecoverSession(OBJECT_SELF);
    }
}
