/// ----------------------------------------------------------------------------
/// @system  CNR Almacen
/// @file    sapo_alma_dist
/// @author  Monti
/// @brief   Reconcile material units actually added to or removed from the chest.
/// modified by: Dhraax
/// ----------------------------------------------------------------------------

#include "cnr_i_store"

void main()
{
    AlmProcess(OBJECT_SELF, GetLastDisturbed(), TRUE);
}
