/// ----------------------------------------------------------------------------
/// @system  CNR
/// @file    cnr_chest_inf
/// @author  Dhraax
/// @brief   Endless material chest. Goes on OnInvDisturbed.
///
///          When someone takes stock out, a copy is put back at once.
///
///          Only the chest's own stock is replaced, and that is the whole
///          point of the CNR_STOCK mark. Copying back whatever was removed
///          would be a duplication machine: drop any item in, take it out, and
///          the chest hands you a copy of it, forever. Placed stock carries
///          the mark, CopyItem keeps it on the replacements, and nothing a
///          player brings in ever has it.
///
///          This replaces plc_inf_start / plc_inf_stop, which did the same by
///          polling: opening the chest started a loop that every 0.2s walked
///          the whole inventory and, for each slot, walked it again to see
///          whether that slot's item was still there. That is O(n^2) five
///          times a second for as long as the chest is open - with the arcane
///          chest's hundred-odd items, over fifty thousand comparisons a
///          second, per open chest.
///
///          Here there is no loop, no stored state and no pair of events to
///          keep in step: one check and one copy, only when stock is taken.
/// modified by: Dhraax
/// ----------------------------------------------------------------------------

/// Marks an item as belonging to the chest's stock.
const string CNR_CHEST_VAR_STOCK = "CNR_STOCK";

/// Marks crafted test pieces accepted by the arcane table.
const string CNR_CHEST_VAR_TRADE = "CNR_OFICIO";

/// Marks loot samples accepted by the arcane extractor.
const string CNR_CHEST_VAR_LOOT_TIER = "CNR_LOOT_TIER";

void main()
{
    if (GetInventoryDisturbType() != INVENTORY_DISTURB_TYPE_REMOVED)
    {
        return;
    }

    object oItem = GetInventoryDisturbItem();
    if (!GetIsObjectValid(oItem))
    {
        return;
    }

    if (!GetLocalInt(oItem, CNR_CHEST_VAR_STOCK))
    {
        // Not ours. Whatever the player brought in, they take back out.
        return;
    }

    // Never copy arbitrary locals from the item the player just acquired.
    // The module acquisition event writes its per-CD-key transfer marker on
    // that object; copying every local put the marker back in the chest and
    // made the next test character destroy the material as contraband.
    object oCopy = CopyItem(oItem, OBJECT_SELF, FALSE);
    if (!GetIsObjectValid(oCopy))
    {
        PrintString("[CNR] Failed to replenish test stock " + GetTag(oItem));
        return;
    }

    // These are the complete intentional locals carried by the six test
    // chests. Keep the allowlist explicit so an acquisition or quest marker
    // cannot become permanent stock again.
    SetLocalInt(oCopy, CNR_CHEST_VAR_STOCK, TRUE);

    int iTrade = GetLocalInt(oItem, CNR_CHEST_VAR_TRADE);
    if (iTrade > 0)
    {
        SetLocalInt(oCopy, CNR_CHEST_VAR_TRADE, iTrade);
    }

    int iLootTier = GetLocalInt(oItem, CNR_CHEST_VAR_LOOT_TIER);
    if (iLootTier > 0)
    {
        SetLocalInt(oCopy, CNR_CHEST_VAR_LOOT_TIER, iLootTier);
    }
}
