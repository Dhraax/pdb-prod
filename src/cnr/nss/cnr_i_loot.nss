/// ----------------------------------------------------------------------------
/// @system  CNR
/// @file    cnr_i_loot
/// @author  Dhraax
/// @brief   The one place that marks generated loot for the essence extractor.
///
///          The module has two treasure generators that do not know about each
///          other. pb_tesoros_inc builds ordinary creature and chest loot and
///          works in ranks 1 to 5. The pb_tesoro_* libraries build boss-chest
///          loot and work in hit dice, naming the piece from thresholds that
///          happen to produce the same five ranks in the same five colours.
///
///          Both have to stamp the same variable or half the loot in the game
///          is silently worthless at the extractor, which is exactly what
///          happened. This holds the rule once so neither copy can drift.
///
///          What the extractor does with each rank is in cnr_i_extract.
/// ----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//                                  Constants
// -----------------------------------------------------------------------------

/// Read by cnr_i_extract as CNR_EXT_VAR_TIER. Holds the loot rank, 1 to 5.
///
/// The rank itself, not rank minus one: rank 1, the plain grey piece, has to be
/// tellable from "no variable at all", and GetLocalInt cannot tell a stored
/// zero from a name that was never set.
const string CNR_LOOT_VAR_TIER = "CNR_LOOT_TIER";

/// Set to TRUE on a container before a generator fills it: a corpse, a chest
/// or a boss chest. Only what lands in one is loot. Shop stock is created with
/// iTienda and quest rewards are created on the player, so neither is marked.
const string CNR_LOOT_VAR_SOURCE = "CNR_LOOT_SOURCE";

// -----------------------------------------------------------------------------
//                             Function Prototypes
// -----------------------------------------------------------------------------

/// @brief Whether a piece can be worn or wielded at all.
/// @param oItem The item to test.
/// @returns TRUE when its base type has at least one equipable slot.
int CnrLoot_IsEquipment(object oItem);

/// @brief The loot rank a boss chest's hit-dice band corresponds to.
/// @param nDG The hit dice the chest was filled for.
/// @returns 1 grey, 2 light blue, 3 dark blue, 4 legendary, 5 titanic.
int CnrLoot_RankFromDG(int nDG);

/// @brief Mark one generated piece with the rank it was created at.
/// @param oItem The piece just created.
/// @param iRank Its loot rank, 1 to 5. Anything else marks nothing.
///
/// Only equipment is marked. Gold, gems, scrolls, potions and junk hold no
/// essence and are left alone, so the extractor says so rather than eating
/// them.
void CnrLoot_Mark(object oItem, int iRank);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

int CnrLoot_IsEquipment(object oItem)
{
    if (!GetIsObjectValid(oItem))
    {
        return FALSE;
    }

    string sSlots = GetStringLowerCase(
        Get2DAString("baseitems", "EquipableSlots", GetBaseItemType(oItem)));
    if (sSlots == "" || sSlots == "****")
    {
        return FALSE;
    }
    if (GetStringLeft(sSlots, 2) == "0x")
    {
        sSlots = GetStringRight(sSlots, GetStringLength(sSlots) - 2);
    }

    int iIndex;
    for (iIndex = 0; iIndex < GetStringLength(sSlots); iIndex++)
    {
        if (GetSubString(sSlots, iIndex, 1) != "0")
        {
            return TRUE;
        }
    }
    return FALSE;
}

int CnrLoot_RankFromDG(int nDG)
{
    // The same bands nombrarObjeto uses to colour the name, so the mark and
    // the word a player reads can never disagree.
    if (nDG <= 9)  { return 1; }
    if (nDG <= 19) { return 2; }
    if (nDG <= 29) { return 3; }
    if (nDG <= 39) { return 4; }
    return 5;
}

void CnrLoot_Mark(object oItem, int iRank)
{
    if (!GetIsObjectValid(oItem) || iRank < 1 || iRank > 5)
    {
        return;
    }
    if (!CnrLoot_IsEquipment(oItem))
    {
        return;
    }

    SetLocalInt(oItem, CNR_LOOT_VAR_TIER, iRank);
}
