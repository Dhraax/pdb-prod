/// ----------------------------------------------------------------------------
/// @system  CNR Crafting
/// @file    cnr_device_ou
/// @author  David Bobeck 06Apr03
/// modified by: Dhraax
/// @brief   Opens a database-backed inventory crafting station after the player
///          closes its inventory. No legacy recipe fallback is supported.
/// ----------------------------------------------------------------------------

#include "cnr_i_craft"

const string CNR_VAR_PENDING_STATION = "CNR_PENDING_STATION";

void main()
{
    object oPC = GetLastUsedBy();
    object oStation = OBJECT_SELF;

    if (!GetIsPC(oPC))
    {
        return;
    }

    if (CnrCraft_OpenStation(oPC, oStation) <= 0)
    {
        DeleteLocalObject(oPC, CNR_VAR_PENDING_STATION);
        SendMessageToPC(oPC,
            "Esta estacion no esta registrada en el sistema de oficios: "
            + GetTag(oStation));
        return;
    }

    // Inventory placeables fire OnUsed once while opening and again after
    // closing. The first event leaves the inventory available for components;
    // the second event opens the catalogue conversation.
    if (GetLocalObject(oPC, CNR_VAR_PENDING_STATION) != oStation)
    {
        SetLocalObject(oPC, CNR_VAR_PENDING_STATION, oStation);
        return;
    }
    DeleteLocalObject(oPC, CNR_VAR_PENDING_STATION);

    SetLocalObject(oPC, CNR_VAR_PLACEABLE, oStation);
    SetLocalInt(oPC, CNR_VAR_PARENT, 0);
    DeleteLocalInt(oPC, CNR_VAR_RECIPE);
    DeleteLocalInt(oPC, CNR_VAR_VARIANT);
    DeleteLocalString(oPC, CNR_VAR_VGROUP);
    CnrCraft_ListCategories(oPC, 0);
    AssignCommand(oPC,
        ActionStartConversation(oStation, "cnr_c_station", TRUE, FALSE));
}
