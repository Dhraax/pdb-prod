/// ----------------------------------------------------------------------------
/// @system  CNR Almacen
/// @file    sapo_alma_abr2
/// @brief   Keep the opening bound to the visible chest that owns this session.
/// modified by: Dhraax
/// ----------------------------------------------------------------------------

#include "cnr_i_store"

void main()
{
    object oPC = GetLastOpenedBy();
    if (oPC != GetLocalObject(OBJECT_SELF, "user")
        || !GetLocalInt(OBJECT_SELF, ALM_READY)
        || GetLocalInt(OBJECT_SELF, ALM_FAULT)
        || GetLocalInt(OBJECT_SELF, "alm_closed"))
    {
        NWNX_Player_OpenInventory(oPC, OBJECT_SELF, FALSE);
        return;
    }
    SetLocalInt(OBJECT_SELF, "alm_opened", TRUE);
    DeleteLocalInt(OBJECT_SELF, "alm_gui_closed");
    object oVisible = GetLocalObject(OBJECT_SELF, "chest_use");
    SetLocalString(oVisible, "abridor", GetName(oPC, TRUE));
}
