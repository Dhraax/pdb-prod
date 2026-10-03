/// ----------------------------------------------------------------------------
/// @system  CNR Almacen
/// @file    sapo_alma_cerr
/// @brief   Close a consistent material session after reconciling pending moves.
/// modified by: Dhraax
/// ----------------------------------------------------------------------------

#include "cnr_i_store"

void main()
{
    object oActor = GetLastClosedBy();
    if (GetIsObjectValid(oActor)
        && oActor != GetLocalObject(OBJECT_SELF, "user"))
    {
        return;
    }
    AlmClose(OBJECT_SELF);
}
