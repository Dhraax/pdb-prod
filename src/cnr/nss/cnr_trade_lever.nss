/// ----------------------------------------------------------------------------
/// @system  CNR Crafting
/// @file    cnr_trade_lever
/// @author  Dhraax
/// @brief   OnUsed of the seven test levers. Opens their conversation.
/// modified by: Dhraax
///
///          It used to raise the trade a level on the spot, which made going
///          back down impossible without a DM. Now it asks.
/// ----------------------------------------------------------------------------

#include "cnr_i_lever"

void main()
{
    object oPC = GetLastUsedBy();
    object oLever = OBJECT_SELF;

    if (!GetIsPC(oPC))
    {
        return;
    }

    int nTrade = CnrLever_Trade(oLever);
    if (nTrade <= 0)
    {
        return;
    }

    string sTrade = CnrLever_TradeName(oLever);
    int nLevel = CnrDetermineTradeskillLevel(
        CnrGetTradeskillXPByType(oPC, nTrade));

    SetCustomToken(CNR_LEVER_TOKEN,
        "Palanca de pruebas: " + sTrade + ".\n\nAhora mismo tienes nivel "
        + IntToString(nLevel) + ".");

    // Dropping the queued use action first, the same reason the extractor
    // does: otherwise the engine finishes the use when the talk ends and
    // fires OnUsed all over again.
    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC,
        ActionStartConversation(oLever, "cnr_c_lever", FALSE, FALSE));
}
