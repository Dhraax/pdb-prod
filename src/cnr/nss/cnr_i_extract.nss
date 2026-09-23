/// ----------------------------------------------------------------------------
/// @system  CNR Arcane
/// @file    cnr_i_extract
/// @author  Dhraax
/// modified by: Dhraax
/// @brief   The extraction machine: breaks loot items and returns the essences
///          they held.
///
///          THE DROP TABLE IS THE switch (iTier) INSIDE CnrExt_Break, AND
///          NOWHERE ELSE. One CnrExt_Roll call per line, reading
///          (pool, die, chance): "1dDie essences could come out of that pool,
///          and each one lands on its own chance". To rebalance, change those
///          numbers and nothing else.
///
///              tier 1  Roll(1, 3, 60)
///              tier 2  Roll(1, 3, 50)  Roll(2, 3, 60)
///              tier 3  Roll(1, 3, 50)  Roll(2, 3, 50)  Roll(3, 2, 20)
///              tier 4  Roll(1, 4, 50)  Roll(2, 3, 60)  Roll(3, 2, 35)
///                      Roll(4, 2, 17)
///
///          The average of one line is (die + 1) / 2 * chance. What that adds
///          up to, per item broken:
///
///              broken        t1     t2     t3     t4    total
///              light blue  1.20      -      -      -     1.20
///              dark blue   1.00   1.20      -      -     2.20
///              legendary   1.00   1.00   0.30      -     2.30
///              titanic     1.25   1.20   0.53   0.26     3.23
///
///          Which is where the rates the design asks for come from: 3.9
///          titanic items per titanic essence, those same four leaving about
///          two legendary ones on the way, and 3.3 legendary items per
///          legendary essence. An item never yields above its own tier.
///
///          The same table, with the reasoning behind the numbers, is in
///          documentation/oficios/cnr/arcane-plan.md section 7. If one of the
///          two changes, change the other.
///
///          The loot generator marks equipment with CNR_LOOT_TIER. This
///          include trusts that classification and refuses unidentified or
///          already enchanted items before counting or breaking them.
/// ----------------------------------------------------------------------------

#include "nwnx_sql"

// -----------------------------------------------------------------------------
//                                  Constants
// -----------------------------------------------------------------------------

/// Stamped by the loot generator, holding the extraction tier, 1 to 4.
const string CNR_EXT_VAR_TIER = "CNR_LOOT_TIER";

/// Left by the enchantment itself. An enchanted item is never broken.
const string CNR_EXT_VAR_ENCHANTED = "CNR_ENCANTADO";

/// Remembers, on the player, that the machine's first OnUsed already went by.
const string CNR_EXT_VAR_PENDING = "CNR_EXT_PENDING";

/// Set on the machine while it must ignore OnUsed entirely.
const string CNR_EXT_VAR_LOCK = "CNR_EXT_LOCK";

/// How long the machine stays deaf after a conversation ends.
const float CNR_EXT_SEAL_SECONDS = 6.0f;

/// Chance, per broken item, of also yielding one crystal.
const int CNR_EXT_CRYSTAL_CHANCE = 20;

/// How many crystals exist. Their resrefs are cnr_c_1..6.
const int CNR_EXT_CRYSTAL_COUNT = 6;

/// How many items the machine takes in one go. Three, and it refuses the whole
/// job when there are more rather than doing part of it: the essences do not
/// stack, so a big batch buries the backpack, and a machine that half-empties
/// itself is worse than one that says no.
const int CNR_EXT_BATCH_CAP = 3;

/// Where the running tally lives while a batch is being broken: one int per
/// resref plus the list of resrefs touched. Nothing survives the script.
const string CNR_EXT_TALLY = "CNR_EXT_TALLY_";
const string CNR_EXT_TALLY_LIST = "CNR_EXT_TALLY_LIST";

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

/// @brief Shuts the machine up for a few seconds after a conversation ends.
/// @param oPC Who was talking.
/// @param oMachine The extractor placeable.
void CnrExt_Seal(object oPC, object oMachine);

/// @brief Extraction tier of an identified, unenchanted marked loot item.
/// @param oItem Item to examine.
/// @returns 1 to 4, or 0 when it cannot be broken. Loot rank 1, the grey one,
///     is left out on purpose: extraction starts at light blue.
int CnrExt_Tier(object oItem);

/// @brief How many items are inside, breakable or not.
/// @param oMachine The extractor placeable.
/// @returns The item count.
int CnrExt_CountItems(object oMachine);

/// @brief How many of the items inside can be broken.
/// @param oMachine The extractor placeable.
/// @returns The breakable count.
int CnrExt_CountBreakable(object oMachine);

/// @brief Count the loot inside that cannot be processed until it is identified.
/// @param oMachine Extraction machine holding the items.
/// @returns How many stamped pieces inside are still unidentified.
int CnrExt_CountUnidentified(object oMachine);

/// @brief The first breakable item inside.
/// @param oMachine The extractor placeable.
/// @returns The item, or OBJECT_INVALID when none is left.
object CnrExt_GetNext(object oMachine);

/// @brief Loads a tier's essence pool onto the module if it is not there yet.
/// @param iTier Pool tier, 1 to 4.
/// @returns How many essences the pool holds, as a string.
string CnrExt_Pool(int iTier);

/// @brief One essence drawn at random from a tier's pool.
/// @param iTier Pool tier, 1 to 4.
/// @returns Its resref, or an empty string when the pool is empty.
string CnrExt_RandomEssence(int iTier);

/// @brief Books one more of a resref onto the running tally.
/// @param oPC Who will receive it.
/// @param sResRef What was rolled.
void CnrExt_Book(object oPC, string sResRef);

/// @brief Turns the tally into items and empties it.
/// @param oPC Who receives them.
/// @returns How many were lost because the inventory was full.
int CnrExt_Hand(object oPC);

/// @brief One roll of the drop table: N possible, each with its own chance.
/// @param oPC Who receives the essences.
/// @param iTier Which pool they come from.
/// @param iDie How many could appear, 1dN.
/// @param iChance Chance of each one, as a percentage.
/// @returns How many were booked.
int CnrExt_Roll(object oPC, int iTier, int iDie, int iChance);

/// @brief Breaks one item and books its essences.
/// @param oPC Who receives the material.
/// @param oMachine The extractor placeable.
/// @param oItem The item to destroy.
/// @param bAlone TRUE when this is the whole job: it hands the material over
///     and reports. A batch passes FALSE and does both once at the end.
/// @returns How many essences came out; the crystal is not counted here.
int CnrExt_Break(object oPC, object oMachine, object oItem, int bAlone = TRUE);

/// @brief Breaks everything that can be broken, one item at a time.
/// @param oPC Who receives the material.
/// @param oMachine The extractor placeable.
/// @returns How many items were destroyed.
int CnrExt_BreakAll(object oPC, object oMachine);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

void CnrExt_Seal(object oPC, object oMachine)
{
    // Called from both dialogue options, and this is the only thing that stops
    // the machine talking in circles.
    //
    // When the conversation ends the engine finishes the use it had queued,
    // which opens and closes the container, which is the pair of OnUsed events
    // that starts a conversation. So the machine talks, ends, reopens, talks
    // again, forever. Sealing it on the way out means those two events arrive
    // while it is deaf and are thrown away, and the half-finished toggle on
    // the player goes with them so the next real use starts from zero.
    SetLocalInt(oMachine, CNR_EXT_VAR_LOCK, TRUE);
    DeleteLocalObject(oPC, CNR_EXT_VAR_PENDING);
    DelayCommand(CNR_EXT_SEAL_SECONDS,
                 DeleteLocalInt(oMachine, CNR_EXT_VAR_LOCK));
}

int CnrExt_Tier(object oItem)
{
    if (!GetIsObjectValid(oItem))
    {
        return 0;
    }
    if (GetLocalInt(oItem, CNR_EXT_VAR_ENCHANTED))
    {
        return 0;
    }

    // The loot rank the generator stamped: 1 grey, 2 light blue, 3 dark blue,
    // 4 legendary, 5 titanic. Anything else is not loot and holds no essence.
    //
    // Being identified is NOT asked here. An unidentified piece is loot all
    // the same; it simply cannot be processed yet, and the machine says so
    // instead of pretending the item is worthless.
    int iRank = GetLocalInt(oItem, CNR_EXT_VAR_TIER);
    return (iRank >= 1 && iRank <= 5) ? iRank : 0;
}

int CnrExt_CountUnidentified(object oMachine)
{
    int iTotal = 0;
    object oItem = GetFirstItemInInventory(oMachine);
    while (GetIsObjectValid(oItem))
    {
        if (CnrExt_Tier(oItem) > 0 && !GetIdentified(oItem))
        {
            iTotal++;
        }
        oItem = GetNextItemInInventory(oMachine);
    }
    return iTotal;
}

int CnrExt_CountItems(object oMachine)
{
    int iTotal = 0;
    object oItem = GetFirstItemInInventory(oMachine);
    while (GetIsObjectValid(oItem))
    {
        iTotal++;
        oItem = GetNextItemInInventory(oMachine);
    }
    return iTotal;
}

int CnrExt_CountBreakable(object oMachine)
{
    int iTotal = 0;
    object oItem = GetFirstItemInInventory(oMachine);
    while (GetIsObjectValid(oItem))
    {
        if (CnrExt_Tier(oItem) > 0 && GetIdentified(oItem))
        {
            iTotal++;
        }
        oItem = GetNextItemInInventory(oMachine);
    }
    return iTotal;
}

object CnrExt_GetNext(object oMachine)
{
    object oItem = GetFirstItemInInventory(oMachine);
    while (GetIsObjectValid(oItem))
    {
        if (CnrExt_Tier(oItem) > 0 && GetIdentified(oItem))
        {
            return oItem;
        }
        oItem = GetNextItemInInventory(oMachine);
    }
    return OBJECT_INVALID;
}

string CnrExt_Pool(int iTier)
{
    // Cached on the module, one local per essence plus a count, so drawing one
    // is a single lookup instead of walking a joined string. A batch of fifty
    // items is thousands of draws; at ~50 string operations each that walk was
    // the difference between comfortable and hitting the instruction limit.
    // The pool only changes when the catalogue is regenerated, which never
    // happens mid-session.
    object oModule = GetModule();
    string sKey    = "CNR_EXT_POOL_" + IntToString(iTier);

    int iCount = GetLocalInt(oModule, sKey + "_N");
    if (iCount > 0)
    {
        return IntToString(iCount);
    }

    if (!NWNX_SQL_PrepareQuery(
        "SELECT DISTINCT essence_resref FROM cnr_arcane_property WHERE tier = ?"))
    {
        return "0";
    }

    NWNX_SQL_PreparedInt(0, iTier);

    if (!NWNX_SQL_ExecutePreparedQuery())
    {
        return "0";
    }

    while (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        SetLocalString(oModule, sKey + "_" + IntToString(iCount),
                       NWNX_SQL_ReadDataInActiveRow(0));
        iCount++;
    }

    SetLocalInt(oModule, sKey + "_N", iCount);
    return IntToString(iCount);
}

string CnrExt_RandomEssence(int iTier)
{
    // The tier belongs to the pool, not to the essence: one essence may sit in
    // two pools, and then it drops through both routes.
    int iCount = StringToInt(CnrExt_Pool(iTier));
    if (iCount <= 0)
    {
        return "";
    }

    return GetLocalString(GetModule(),
        "CNR_EXT_POOL_" + IntToString(iTier) + "_" + IntToString(Random(iCount)));
}

void CnrExt_Book(object oPC, string sResRef)
{
    // Rolling fifty titanic items is over a thousand possible essences. Made
    // one at a time that is a thousand engine calls; booked first and handed
    // over as stacks it is one call per distinct essence, around thirty in the
    // worst case. Same result, a fraction of the work.
    int iHad = GetLocalInt(oPC, CNR_EXT_TALLY + sResRef);
    if (iHad == 0)
    {
        SetLocalString(oPC, CNR_EXT_TALLY_LIST,
            GetLocalString(oPC, CNR_EXT_TALLY_LIST) + sResRef + ";");
    }
    SetLocalInt(oPC, CNR_EXT_TALLY + sResRef, iHad + 1);
}

int CnrExt_Hand(object oPC)
{
    string sRest = GetLocalString(oPC, CNR_EXT_TALLY_LIST);
    DeleteLocalString(oPC, CNR_EXT_TALLY_LIST);

    int iLost = 0;
    while (sRest != "")
    {
        int iEnd = FindSubString(sRest, ";");
        if (iEnd < 0)
        {
            break;
        }
        string sResRef = GetStringLeft(sRest, iEnd);
        sRest = GetStringRight(sRest, GetStringLength(sRest) - iEnd - 1);

        int iCount = GetLocalInt(oPC, CNR_EXT_TALLY + sResRef);
        DeleteLocalInt(oPC, CNR_EXT_TALLY + sResRef);
        if (iCount <= 0)
        {
            continue;
        }

        // Asking for more than the base item stacks silently drops the rest,
        // so the first one is made alone and its own row in baseitems.2da says
        // how big a stack may be. Essences do not stack today, and then this
        // hands them over one by one exactly as before; the day they do, the
        // same code makes them in tens.
        object oFirst = CreateItemOnObject(sResRef, oPC, 1);
        if (!GetIsObjectValid(oFirst))
        {
            iLost += iCount;
            continue;
        }

        int iMax = StringToInt(Get2DAString("baseitems", "Stacking",
                                            GetBaseItemType(oFirst)));
        if (iMax < 1)
        {
            iMax = 1;
        }

        int iLeft = iCount - 1;
        while (iLeft > 0)
        {
            int iChunk = (iLeft > iMax) ? iMax : iLeft;
            if (!GetIsObjectValid(CreateItemOnObject(sResRef, oPC, iChunk)))
            {
                iLost += iLeft;
                break;
            }
            iLeft -= iChunk;
        }
    }

    if (iLost > 0)
    {
        SendMessageToPC(oPC, "No te caben " + IntToString(iLost)
            + " esencias: haz sitio antes de seguir.");
    }
    return iLost;
}

int CnrExt_Roll(object oPC, int iTier, int iDie, int iChance)
{
    int iHowMany = Random(iDie) + 1;

    int iGiven = 0;
    int i;
    for (i = 0; i < iHowMany; i++)
    {
        if (Random(100) >= iChance)
        {
            continue;
        }
        string sResRef = CnrExt_RandomEssence(iTier);
        if (sResRef == "")
        {
            continue;
        }
        CnrExt_Book(oPC, sResRef);
        iGiven++;
    }
    return iGiven;
}

int CnrExt_Break(object oPC, object oMachine, object oItem, int bAlone = TRUE)
{
    int iTier = CnrExt_Tier(oItem);
    if (iTier <= 0 || !GetIdentified(oItem))
    {
        return 0;
    }

    string sName = GetName(oItem);
    int iTotal = 0;

    // The table from section 7 of the plan, read by loot rank rather than by
    // tier: a titanic piece, rank 5, is worth 1.25 essences of tier 1, 1.20 of
    // tier 2, 0.53 of tier 3 and 0.26 of tier 4, which is where "four titanic
    // items for one titanic essence, and two legendary ones along the way"
    // comes from. An item never yields above the tier below its own rank.
    //
    // The scarce tiers are scarce because of their chance, not because of a
    // cap: with dice this small a cap would do nothing.
    switch (iTier)
    {
        // Rank 1, the plain grey piece. It holds almost nothing and is here so
        // that ordinary loot is never simply refused: about one essence of the
        // lowest kind for every three items broken, and no crystal.
        case 1:
            iTotal += CnrExt_Roll(oPC, 1, 2, 25);
            break;
        case 2:
            iTotal += CnrExt_Roll(oPC, 1, 3, 60);
            break;
        case 3:
            iTotal += CnrExt_Roll(oPC, 1, 3, 50);
            iTotal += CnrExt_Roll(oPC, 2, 3, 60);
            break;
        case 4:
            iTotal += CnrExt_Roll(oPC, 1, 3, 50);
            iTotal += CnrExt_Roll(oPC, 2, 3, 50);
            iTotal += CnrExt_Roll(oPC, 3, 2, 20);
            break;
        case 5:
            iTotal += CnrExt_Roll(oPC, 1, 4, 50);
            iTotal += CnrExt_Roll(oPC, 2, 3, 60);
            iTotal += CnrExt_Roll(oPC, 3, 2, 35);
            iTotal += CnrExt_Roll(oPC, 4, 2, 17);
            break;
    }

    // The crystal comes out of the same act and does not depend on rarity,
    // except that grey loot yields none: minimal has to mean minimal.
    int bCrystal = FALSE;
    if (iTier > 1 && Random(100) < CNR_EXT_CRYSTAL_CHANCE)
    {
        CnrExt_Book(oPC, "cnr_c_"
                         + IntToString(Random(CNR_EXT_CRYSTAL_COUNT) + 1));
        bCrystal = TRUE;
    }

    // Destroying comes last: if anything above fails, the item stays inside.
    DestroyObject(oItem);

    if (bAlone)
    {
        CnrExt_Hand(oPC);
        SendMessageToPC(oPC, sName + ": " + IntToString(iTotal) + " esencia(s)"
            + (bCrystal ? " y un cristal urdímbrico." : "."));
    }

    return iTotal;
}

int CnrExt_BreakAll(object oPC, object oMachine)
{
    // One walk, visiting every item exactly once, taking the next reference
    // before touching the current one.
    //
    // The obvious shape - "find the first breakable, break it, repeat" - is a
    // duplication bug waiting to happen. DestroyObject does not promise the
    // object is gone before the script ends, so the search would keep finding
    // the same item and pay its essences again on every pass. Walking once
    // is correct whether destruction is immediate or deferred, and grabbing
    // oNext first keeps the walk valid in the immediate case.
    // Counted before anything is destroyed: DestroyObject usually takes effect
    // when the script ends, so asking again afterwards would still see the
    // items that are already gone.
    int iBreakable = CnrExt_CountBreakable(oMachine);

    if (iBreakable > CNR_EXT_BATCH_CAP)
    {
        SendMessageToPC(oPC, "La máquina no admite tanto de golpe: solo "
            + IntToString(CNR_EXT_BATCH_CAP) + " objetos por vez. Saca los que "
            + "sobren y vuelve a intentarlo.");
        SendMessageToPC(oPC, "Dentro hay " + IntToString(iBreakable)
            + " objetos de los que extraer esencia.");
        return 0;
    }

    int iDone = 0;
    int iEssences = 0;

    object oItem = GetFirstItemInInventory(oMachine);
    while (GetIsObjectValid(oItem) && iDone < CNR_EXT_BATCH_CAP)
    {
        object oNext = GetNextItemInInventory(oMachine);

        // Unidentified loot stays inside untouched: it holds essence, but it
        // has to be identified before the machine will take it.
        if (CnrExt_Tier(oItem) > 0 && GetIdentified(oItem))
        {
            iEssences += CnrExt_Break(oPC, oMachine, oItem, FALSE);
            iDone++;
        }

        oItem = oNext;
    }

    if (iDone == 0)
    {
        SendMessageToPC(oPC, "No había nada de lo que extraer.");
        return 0;
    }

    // Everything the batch rolled becomes items here, in stacks.
    CnrExt_Hand(oPC);

    SendMessageToPC(oPC, "Extraes " + IntToString(iEssences)
        + (iEssences == 1 ? " esencia de " : " esencias de ")
        + IntToString(iDone)
        + (iDone == 1 ? " objeto." : " objetos."));

    return iDone;
}
