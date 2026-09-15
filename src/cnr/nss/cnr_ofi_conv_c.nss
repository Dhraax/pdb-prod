/// ----------------------------------------------------------------------------
/// @system  CNR Oficios
/// @file    cnr_ofi_conv_c
/// @author  Dhraax
/// @brief   Conversation condition: show the conversion line only to a player
///          who still holds old progression in this trade.
///
///          The trade arrives as the condition parameter "oficio", numbered the
///          way CnrSkill_* numbers them: 1 Herreria, 2 Carpinteria,
///          3 Peleteria, 4 Alquimia, 5 Joyeria, 6 Arcano, 7 Sastreria. One
///          script for every master, like ofi_abre_tienda.
///
///          It reads locals off an item in the player's inventory and never
///          touches the database, so it is cheap enough to run on every line.
/// ----------------------------------------------------------------------------

#include "cnr_i_legacy"

int StartingConditional()
{
    int nSkill = StringToInt(GetScriptParam("oficio"));
    if (nSkill < 1)
    {
        PrintString("[OFICIOS] cnr_ofi_conv_c sin parametro 'oficio'");
        return FALSE;
    }
    return CnrLegacy_HasPending(GetPCSpeaker(), nSkill);
}
