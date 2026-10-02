/// ----------------------------------------------------------------------------
/// @system  CNR Almacen
/// @file    sapo_alma_abr2
/// @brief   Keep the opening bound to the visible chest that owns this session.
/// modified by: Dhraax
/// ----------------------------------------------------------------------------

#include "nwnx_player"

void main()
{
    object oPC = GetLastOpenedBy();
    if (oPC != GetLocalObject(OBJECT_SELF, "user"))
    {
        NWNX_Player_OpenInventory(oPC, OBJECT_SELF, FALSE);
        return;
    }
    object oVisible = GetLocalObject(OBJECT_SELF, "chest_use");
    SetLocalString(oVisible, "abridor", GetName(oPC, TRUE));
}
