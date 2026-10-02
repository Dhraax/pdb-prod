/// ----------------------------------------------------------------------------
/// @system  CNR Almacen
/// @file    sapo_alma_beat
/// @brief   Close an abandoned material session using the same accounting path.
/// modified by: Dhraax
/// ----------------------------------------------------------------------------

#include "cnr_i_store"

void main()
{
    object oPC = GetLocalObject(OBJECT_SELF, "user");
    if (!GetIsObjectValid(oPC) || GetArea(OBJECT_SELF) != GetArea(oPC))
    {
        AlmClose(OBJECT_SELF);
    }
}
