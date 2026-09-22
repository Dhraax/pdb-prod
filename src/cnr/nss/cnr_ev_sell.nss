/// ----------------------------------------------------------------------------
/// @system  CNR
/// @file    cnr_ev_sell
/// @author  Dhraax
/// @brief   Refuse to let a store buy anything a trade made.
///
///          Crafted goods were being sold for real money in any shop that
///          takes stolen stock, which is every shop the ordinary refusals do
///          not reach. This runs before the store decides anything, so what a
///          given shop is willing to accept never comes into it.
///
///          It touches neither the item's value nor its plot flag. Lowering
///          the value would move the minimum level to equip, because the
///          engine derives that from the cost, and the plot flag would pin the
///          piece inside the inventory. This refuses the sale and leaves the
///          item exactly as it was: the owner can still drop it, destroy it or
///          hand it to another player.
///
///          Subscribed in wrap_on_mod_load, once, at module load.
/// ----------------------------------------------------------------------------

#include "nwnx_events"

/// Stamped on every crafted product by cnr_i_craft, which defines it as
/// CNR_VAR_OFICIO. It holds the profession that made the piece.
const string CNR_SELL_VAR_OFICIO = "CNR_OFICIO";

void main()
{
    object oItem = StringToObject(NWNX_Events_GetEventData("ITEM"));
    if (!GetIsObjectValid(oItem))
    {
        return;
    }

    if (GetLocalInt(oItem, CNR_SELL_VAR_OFICIO) <= 0)
    {
        return;
    }

    NWNX_Events_SkipEvent();
    SendMessageToPC(
        OBJECT_SELF,
        "Nadie compra aquí el trabajo de un artesano. "
        + GetName(oItem) + " sigue siendo tuyo."
    );
}
