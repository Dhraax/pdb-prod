/// ----------------------------------------------------------------------------
/// @system CNR_OFICIOS
/// @file ofi_abre_tienda
/// @author  Dhraax
/// @brief   Opens the store a profession master is linked to.
///
/// One script for every master. The store tag arrives as the conversation
/// action parameter "tienda", so adding a profession needs a dialogue and a
/// placed store, not another script.
/// ----------------------------------------------------------------------------

#include "nw_i0_plot"

void main()
{
    object oPC = GetPCSpeaker();
    string sTienda = GetScriptParam("tienda");

    if (sTienda == "")
    {
        PrintString("[OFICIOS] ofi_abre_tienda sin parametro 'tienda'");
        return;
    }

    object oTienda = GetObjectByTag(sTienda);
    if (!GetIsObjectValid(oTienda))
    {
        PrintString("[OFICIOS] tienda no encontrada: " + sTienda);
        SendMessageToPC(oPC, "Ahora mismo no tengo genero que ofrecerte.");
        return;
    }

    gplotAppraiseOpenStore(oTienda, oPC);
}
