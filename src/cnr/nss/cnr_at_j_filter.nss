/// ----------------------------------------------------------------------------
/// @system  CNR Tradeskill Journal
/// @file    cnr_at_j_filter
/// @author  Dhraax
/// @brief   Toggle whether crafting menus show recipes above the current level.
/// ----------------------------------------------------------------------------

#include "cnr_i_setting"

void main()
{
    object oPC = GetPCSpeaker();
    int nCurrent = CnrSetting_GetInt(
        oPC,
        CNR_SETTING_SHOW_ABOVE_LEVEL,
        FALSE
    );

    if (!CnrSetting_SetInt(
        oPC,
        CNR_SETTING_SHOW_ABOVE_LEVEL,
        !nCurrent
    ))
    {
        SendMessageToPC(oPC, "No se pudo guardar la preferencia de recetas.");
    }
}
