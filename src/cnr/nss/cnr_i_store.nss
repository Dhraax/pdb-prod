/// ----------------------------------------------------------------------------
/// @system  CNR Material Store
/// @file    cnr_i_store
/// @author  Dhraax
/// @brief   Account real chest deltas instead of post-merge event item sizes.
/// ----------------------------------------------------------------------------

#include "sapo_cons_alma"
#include "mti_libreria"
#include "nwnx_item"
#include "nwnx_player"

const int ALM_STACK = 10;
const int ALM_FEE = 5;
const int ALM_INT_MAX = 2147483647;
const string ALM_SESSION = "CNR_ALM_SESSION";
const string ALM_BUSY = "CNR_ALM_BUSY";
// Retire the legacy persistent lock without changing any material balances.
const string ALM_FAULT = "CNR_ALM_BLOCKED_V2";
const string ALM_READY = "CNR_ALM_READY";

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

/// @brief Find an accepted material by its blueprint resref.
/// @param oChest Initialized material chest.
/// @param oItem Item to classify; containers are never materials.
/// @returns Catalogue index, or zero for an unsupported item.
int AlmIndex(object oChest, object oItem);

/// @brief Count actual units of one material directly inside a container.
/// @param oChest Initialized material chest supplying the catalogue lookup.
/// @param oContainer Inventory to inspect.
/// @param iIndex Material catalogue index.
/// @returns Total units, or -1 for an invalid stack or integer overflow.
int AlmCount(object oChest, object oContainer, int iIndex);

/// @brief Record current chest counts in one inventory pass.
/// @param oChest Initialized material chest.
/// @returns TRUE for valid counts, FALSE on invalid stacks or overflow.
int AlmScan(object oChest);

/// @brief Show a bounded stack only when none of that material remains.
/// @param oChest Initialized material chest; internal mutation guard is set.
/// @param iIndex Material catalogue index.
/// @param iBalance Verified persistent balance.
/// @returns TRUE if the created count is within the requested balance.
int AlmShow(object oChest, int iIndex, int iBalance);

/// @brief Return exactly the transferred units, including units merged in bags.
/// @param oChest Initialized material chest; internal mutation guard is set.
/// @param oSource Source inventory, optionally a player's bag.
/// @param oTarget Destination inventory.
/// @param iIndex Material catalogue index.
/// @param iAmount Maximum units to move.
/// @param iDepth Remaining permitted container nesting depth.
/// @returns Actual units moved; a short return means rollback failed.
int AlmMoveUnits(object oChest, object oSource, object oTarget,
    int iIndex, int iAmount, int iDepth = 16);

/// @brief Quarantine inconsistent state without supplying further stacks.
/// @param oChest Material chest to retain for inspection.
/// @param sReason Non-sensitive diagnostic code.
/// @param oActor Optional other character whose chest window must also close.
void AlmBlock(object oChest, string sReason, object oActor = OBJECT_INVALID);

/// @brief Reconcile actual inventory changes once; optionally refill empty rows.
/// @param oChest Material chest.
/// @param oActor Character that caused the inventory change.
/// @param iRefill TRUE for ordinary events, FALSE while closing.
void AlmProcess(object oChest, object oActor, int iRefill);

/// @brief Reconcile pending movements and close only a consistent session.
/// @param oChest Material chest.
void AlmClose(object oChest);

/// @brief Determine whether an initialized chest still has an active owner.
/// @param oChest Material session chest.
/// @returns TRUE only for an attached player nearby with an open session.
int AlmSessionActive(object oChest);

/// @brief Reconcile and release an old session from a fresh use or heartbeat.
/// @param oChest Existing session, possibly abandoned or interrupted.
/// @returns TRUE after cleanup, FALSE when quantity state requires quarantine.
/// Never call this from an inventory callback or a nested close callback.
int AlmRecoverSession(object oChest);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

int AlmIndex(object oChest, object oItem)
{
    if (!GetIsObjectValid(oItem)
        || GetIsObjectValid(GetFirstItemInInventory(oItem)))
    {
        return 0;
    }
    return GetLocalInt(oChest, "alm_res_" + GetStringLowerCase(GetResRef(oItem)));
}

int AlmCount(object oChest, object oContainer, int iIndex)
{
    int iTotal = 0;
    object oItem = GetFirstItemInInventory(oContainer);
    while (GetIsObjectValid(oItem))
    {
        if (AlmIndex(oChest, oItem) == iIndex)
        {
            int iUnits = GetItemStackSize(oItem);
            if (iUnits < 1 || iUnits > ALM_INT_MAX - iTotal)
            {
                return -1;
            }
            iTotal += iUnits;
        }
        oItem = GetNextItemInInventory(oContainer);
    }
    return iTotal;
}

int AlmScan(object oChest)
{
    int iIndex;
    for (iIndex = 1; iIndex <= NUM_DIST_INGRED; iIndex++)
    {
        SetLocalInt(oChest, "alm_now_" + IntToString(iIndex), 0);
    }
    object oItem = GetFirstItemInInventory(oChest);
    while (GetIsObjectValid(oItem))
    {
        iIndex = AlmIndex(oChest, oItem);
        if (iIndex > 0)
        {
            string sKey = "alm_now_" + IntToString(iIndex);
            int iTotal = GetLocalInt(oChest, sKey);
            int iUnits = GetItemStackSize(oItem);
            if (iUnits < 1 || iUnits > ALM_INT_MAX - iTotal)
            {
                return FALSE;
            }
            SetLocalInt(oChest, sKey, iTotal + iUnits);
        }
        oItem = GetNextItemInInventory(oChest);
    }
    return TRUE;
}

int AlmShow(object oChest, int iIndex, int iBalance)
{
    if (iBalance < 0 || AlmCount(oChest, oChest, iIndex) != 0)
    {
        return FALSE;
    }
    if (iBalance == 0)
    {
        return TRUE;
    }
    int iWanted = iBalance;
    if (iWanted > ALM_STACK)
    {
        iWanted = ALM_STACK;
    }
    string sResref = GetLocalArrayString(oChest, "sTagIngOficio", iIndex);
    CreateItemOnObject(sResref, oChest, iWanted);
    // The creation result can be a merged object. Only the inventory count
    // establishes how many units were created, including base-item clamping.
    int iActual = AlmCount(oChest, oChest, iIndex);
    return iActual >= 0 && iActual <= iWanted;
}

int AlmMoveUnits(object oChest, object oSource, object oTarget,
    int iIndex, int iAmount, int iDepth)
{
    if (iDepth < 1 || iAmount < 1 || !GetIsObjectValid(oSource)
        || !GetIsObjectValid(oTarget))
    {
        return 0;
    }
    int iMoved = 0;
    object oItem = GetFirstItemInInventory(oSource);
    while (GetIsObjectValid(oItem) && iMoved < iAmount)
    {
        object oNext = GetNextItemInInventory(oSource);
        if (AlmIndex(oChest, oItem) == iIndex)
        {
            int iStack = GetItemStackSize(oItem);
            int iTake = iAmount - iMoved;
            if (iTake > iStack)
            {
                iTake = iStack;
            }
            int iBefore = AlmCount(oChest, oTarget, iIndex);
            if (iBefore < 0 || iTake < 1)
            {
                return iMoved;
            }
            if (iTake == iStack)
            {
                NWNX_Item_MoveTo(oItem, oTarget, TRUE);
            }
            else
            {
                // Split only the units owed. Never copy a post-merge stack:
                // it can also contain units the player owned beforehand.
                string sResref = GetLocalArrayString(oChest, "sTagIngOficio", iIndex);
                object oSplit = CreateObject(OBJECT_TYPE_ITEM, sResref, GetLocation(oChest));
                if (!GetIsObjectValid(oSplit))
                {
                    return iMoved;
                }
                // Ground staging must never be collectible, even if delivery
                // reports success without actually acquiring the item.
                SetUseableFlag(oSplit, FALSE);
                SetItemStackSize(oSplit, iTake);
                if (GetItemStackSize(oSplit) != iTake)
                {
                    DestroyObject(oSplit);
                    return iMoved;
                }
                // Remove the split units from the source before delivery.
                // A successful move followed by an unexpected count must not
                // leave both the original units and the delivered split.
                SetItemStackSize(oItem, iStack - iTake);
                if (GetItemStackSize(oItem) != iStack - iTake)
                {
                    SetUseableFlag(oSplit, FALSE);
                    DestroyObject(oSplit);
                    return iMoved;
                }
                NWNX_Item_MoveTo(oSplit, oTarget, TRUE);
                if (GetIsObjectValid(oSplit)
                    && GetItemPossessor(oSplit) == OBJECT_INVALID)
                {
                    // Restore the source only when the split never left the
                    // ground. A merged/invalid split may already be delivered.
                    SetUseableFlag(oSplit, FALSE);
                    DestroyObject(oSplit);
                    SetItemStackSize(oItem, iStack);
                    return iMoved;
                }
                int iAdded = AlmCount(oChest, oTarget, iIndex) - iBefore;
                if (iAdded != iTake)
                {
                    return iMoved;
                }
            }
            int iActual = AlmCount(oChest, oTarget, iIndex) - iBefore;
            if (iActual != iTake)
            {
                return iMoved;
            }
            iMoved += iActual;
        }
        else if (GetIsObjectValid(GetFirstItemInInventory(oItem)))
        {
            iMoved += AlmMoveUnits(oChest, oItem, oTarget,
                iIndex, iAmount - iMoved, iDepth - 1);
        }
        oItem = oNext;
    }
    return iMoved;
}

void AlmBlock(object oChest, string sReason, object oActor)
{
    SetLocalInt(oChest, ALM_FAULT, TRUE);
    object oPC = GetLocalObject(oChest, "user");
    SetLocalInt(oPC, ALM_FAULT, TRUE);
    object oVariables = GetItemPossessedBy(oPC, CONTENEDOR_VARIABLES);
    if (GetIsObjectValid(oVariables))
    {
        SetLocalInt(oVariables, ALM_FAULT, TRUE);
    }
    SetLocked(oChest, TRUE);
    SetUseableFlag(oChest, FALSE);
    // A persisted owner quarantine must not deny the shared store to others.
    object oVisible = GetLocalObject(oChest, "chest_use");
    if (GetIsPC(oPC) && GetIsObjectValid(oVariables)
        && GetLocalInt(oVariables, ALM_FAULT)
        && GetLocalObject(oVisible, ALM_SESSION) == oChest)
    {
        DeleteLocalInt(oVisible, "abierto");
        DeleteLocalObject(oVisible, ALM_SESSION);
    }
    if (GetIsPC(oPC))
    {
        NWNX_Player_OpenInventory(oPC, oChest, FALSE);
    }
    if (GetIsPC(oActor) && oActor != oPC)
    {
        NWNX_Player_OpenInventory(oActor, oChest, FALSE);
    }
    WriteTimestampedLogEntry("CNR material store quarantined: " + sReason);
    SendMessageToPC(oPC, "El almacen se ha bloqueado por seguridad. Avisa a un DM.");
}

void AlmProcess(object oChest, object oActor, int iRefill)
{
    if (GetLocalInt(oChest, ALM_BUSY) || !GetLocalInt(oChest, ALM_READY))
    {
        return;
    }
    SetLocalInt(oChest, ALM_BUSY, TRUE);
    object oPC = GetLocalObject(oChest, "user");
    // Unsupported objects and bags are moved intact, never copied or emptied.
    object oItem = GetFirstItemInInventory(oChest);
    while (GetIsObjectValid(oItem))
    {
        object oNext = GetNextItemInInventory(oChest);
        if (AlmIndex(oChest, oItem) == 0)
        {
            // Existing rejected objects must never be handed to another user.
            if (oActor != oPC)
            {
                AlmBlock(oChest, "foreign-unsupported", oActor);
                DeleteLocalInt(oChest, ALM_BUSY);
                return;
            }
            NWNX_Item_MoveTo(oItem, oActor, TRUE);
            if (GetIsObjectValid(oItem) && GetItemPossessor(oItem) != oActor)
            {
                AlmBlock(oChest, "unsupported-return", oActor);
                DeleteLocalInt(oChest, ALM_BUSY);
                return;
            }
            SendMessageToPC(oActor, "No puedes guardar ese objeto en el almacen.");
        }
        oItem = oNext;
    }
    if (!AlmScan(oChest))
    {
        AlmBlock(oChest, "invalid-count", oActor);
        DeleteLocalInt(oChest, ALM_BUSY);
        return;
    }
    int iIndex;
    for (iIndex = 1; iIndex <= NUM_DIST_INGRED; iIndex++)
    {
        string sSuffix = IntToString(iIndex);
        int iBefore = GetLocalInt(oChest, "alm_seen_" + sSuffix);
        int iAfter = GetLocalInt(oChest, "alm_now_" + sSuffix);
        int iDelta = iAfter - iBefore;
        if (iDelta == 0)
        {
            continue;
        }
        string sVariable = GetLocalArrayString(oChest, "sVarIngOficio", iIndex);
        int iBalance = ObtenerIntPersistente(oPC, sVariable);
        object oVariables = GetItemPossessedBy(oPC, CONTENEDOR_VARIABLES);
        int iValid = GetIsPC(oPC) && oActor == oPC
            && GetLocalObject(oPC, ALM_SESSION) == oChest
            && GetIsObjectValid(oVariables)
            && !GetLocalInt(oChest, ALM_FAULT)
            && !GetLocalInt(oPC, ALM_FAULT)
            && !GetLocalInt(oVariables, ALM_FAULT)
            && iBalance >= 0
            && iBalance == GetLocalInt(oChest, "alm_balance_" + sSuffix);
        int iAffordable = TRUE;
        if (iDelta < 0)
        {
            int iTaken = -iDelta;
            iValid = iValid && iTaken <= iBalance && iTaken <= ALM_INT_MAX / ALM_FEE;
            if (iValid)
            {
                iAffordable = GetGold(oPC) >= iTaken * ALM_FEE;
            }
        }
        else
        {
            iValid = iValid && iDelta <= ALM_INT_MAX - iBalance;
        }
        if (!iValid || !iAffordable)
        {
            int iReturned;
            int iNeeded;
            if (iDelta > 0)
            {
                iNeeded = iDelta;
                iReturned = AlmMoveUnits(oChest, oChest, oActor, iIndex, iNeeded);
            }
            else
            {
                iNeeded = -iDelta;
                iReturned = AlmMoveUnits(oChest, oActor, oChest, iIndex, iNeeded);
            }
            if (iReturned != iNeeded || !iValid)
            {
                AlmBlock(oChest, "rollback-or-state", oActor);
                DeleteLocalInt(oChest, ALM_BUSY);
                return;
            }
            SendMessageToPC(oPC, "Necesitas " + IntToString(iNeeded * ALM_FEE)
                + " po para sacar " + IntToString(iNeeded) + ".");
            SetLocalInt(oChest, "alm_seen_" + sSuffix, AlmCount(oChest, oChest, iIndex));
            continue;
        }
        // Persist exactly the physical delta before any new display is made.
        int iNewBalance = iBalance + iDelta;
        GuardarIntPersistente(oPC, sVariable, iNewBalance);
        if (!GetIsObjectValid(GetItemPossessedBy(oPC, CONTENEDOR_VARIABLES))
            || ObtenerIntPersistente(oPC, sVariable) != iNewBalance)
        {
            if (iDelta < 0)
            {
                AlmMoveUnits(oChest, oActor, oChest, iIndex, -iDelta);
            }
            else
            {
                AlmMoveUnits(oChest, oChest, oActor, iIndex, iDelta);
            }
            AlmBlock(oChest, "persistence-readback", oActor);
            DeleteLocalInt(oChest, ALM_BUSY);
            return;
        }
        SetLocalInt(oChest, "alm_balance_" + sSuffix, iNewBalance);
        string sName = GetLocalArrayString(oChest, "sNomIngOficio", iIndex);
        if (iDelta < 0)
        {
            TakeGoldFromCreature(-iDelta * ALM_FEE, oPC, TRUE);
            SendMessageToPC(oPC, "Sacado: " + sName + " x" + IntToString(-iDelta));
            // A partial withdrawal leaves its remaining units in place.
            if (iRefill && iAfter == 0 && !AlmShow(oChest, iIndex, iNewBalance))
            {
                AlmBlock(oChest, "refill-count", oActor);
                DeleteLocalInt(oChest, ALM_BUSY);
                return;
            }
        }
        else
        {
            // Retain the deposited units as the display. Destroying a merged
            // object would remove previously displayed units as well.
            SendMessageToPC(oPC, "Almacenado: " + sName + " x" + IntToString(iDelta));
        }
        SetLocalInt(oChest, "alm_seen_" + sSuffix, AlmCount(oChest, oChest, iIndex));
    }
    DeleteLocalInt(oChest, ALM_BUSY);
}

void AlmClose(object oChest)
{
    if (!GetIsObjectValid(oChest))
    {
        return;
    }
    object oPC = GetLocalObject(oChest, "user");
    if (!GetLocalInt(oChest, "alm_closed"))
    {
        AlmProcess(oChest, oPC, FALSE);
        if (GetLocalInt(oChest, ALM_FAULT) || GetLocalInt(oChest, ALM_BUSY))
        {
            return;
        }
    }
    SetLocalInt(oChest, "alm_closed", TRUE);
    SetLocked(oChest, TRUE);
    SetUseableFlag(oChest, FALSE);
    SetLocalInt(oChest, ALM_READY, FALSE);
    if (GetIsPC(oPC) && !GetLocalInt(oChest, "alm_gui_closed"))
    {
        SetLocalInt(oChest, "alm_gui_closed", TRUE);
        NWNX_Player_OpenInventory(oPC, oChest, FALSE);
    }
    object oVisible = GetLocalObject(oChest, "chest_use");
    if (GetLocalObject(oVisible, ALM_SESSION) == oChest)
    {
        DeleteLocalInt(oVisible, "abierto");
        DeleteLocalObject(oVisible, ALM_SESSION);
    }
    if (GetLocalObject(oPC, ALM_SESSION) == oChest)
    {
        DeleteLocalObject(oPC, ALM_SESSION);
    }
    // These are virtual representations of already-accounted holdings.
    // Remove them explicitly before destroying the chest, independently of
    // the engine's container-destruction behavior.
    object oItem = GetFirstItemInInventory(oChest);
    while (GetIsObjectValid(oItem))
    {
        object oNext = GetNextItemInInventory(oChest);
        DestroyObject(oItem);
        oItem = oNext;
    }
    DestroyObject(oChest);
}

int AlmSessionActive(object oChest)
{
    if (!GetIsObjectValid(oChest) || GetLocalInt(oChest, "alm_closed")
        || !GetLocalInt(oChest, ALM_READY) || GetLocalInt(oChest, ALM_FAULT))
    {
        return FALSE;
    }
    object oOwner = GetLocalObject(oChest, "user");
    if (!GetIsPC(oOwner) || GetArea(oOwner) != GetArea(oChest)
        || GetDistanceBetween(oOwner, oChest) > 5.0f
        || GetLocalObject(oOwner, ALM_SESSION) != oChest)
    {
        return FALSE;
    }
    // Physical door/placeable open state is not proof of an inventory GUI.
    // A valid creature reference alone does not establish player membership.
    object oPC = GetFirstPC();
    while (GetIsObjectValid(oPC))
    {
        if (oPC == oOwner)
        {
            return TRUE;
        }
        oPC = GetNextPC();
    }
    return FALSE;
}

int AlmRecoverSession(object oChest)
{
    if (!GetIsObjectValid(oChest))
    {
        return TRUE;
    }
    if (GetLocalInt(oChest, ALM_FAULT))
    {
        return FALSE;
    }
    // A fresh player-use/heartbeat runs after the earlier event has ended.
    // Check interrupted accounting before clearing its leftover re-entry flag.
    if (GetLocalInt(oChest, ALM_BUSY) && GetLocalInt(oChest, ALM_READY)
        && !GetLocalInt(oChest, "alm_closed"))
    {
        if (!AlmScan(oChest))
        {
            AlmBlock(oChest, "recovery-count");
            return FALSE;
        }
        object oOwner = GetLocalObject(oChest, "user");
        object oVariables = GetItemPossessedBy(oOwner, CONTENEDOR_VARIABLES);
        int iIndex;
        for (iIndex = 1; iIndex <= NUM_DIST_INGRED; iIndex++)
        {
            string sSuffix = IntToString(iIndex);
            // An interrupted write may have updated its balance before its
            // physical snapshot. Never account that uncertain delta twice.
            if (GetLocalInt(oChest, "alm_now_" + sSuffix)
                != GetLocalInt(oChest, "alm_seen_" + sSuffix))
            {
                AlmBlock(oChest, "recovery-pending");
                return FALSE;
            }
            if (GetIsPC(oOwner))
            {
                string sVariable = GetLocalArrayString(oChest, "sVarIngOficio", iIndex);
                if (!GetIsObjectValid(oVariables)
                    || ObtenerIntPersistente(oOwner, sVariable)
                        != GetLocalInt(oChest, "alm_balance_" + sSuffix))
                {
                    AlmBlock(oChest, "recovery-balance");
                    return FALSE;
                }
            }
        }
    }
    DeleteLocalInt(oChest, ALM_BUSY);
    AlmClose(oChest);
    return GetLocalInt(oChest, "alm_closed");
}
