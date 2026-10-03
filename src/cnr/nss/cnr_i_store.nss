/// ----------------------------------------------------------------------------
/// @system  CNR Material Store
/// @file    cnr_i_store
/// @author  Dhraax
/// @brief   Account real chest deltas without persistent character lockouts.
/// modified by: Dhraax
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
// Only the transient chest may pause; neither character nor variable item does.
const string ALM_FAULT = "CNR_ALM_PAUSED";
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

/// @brief Pause only an unfinished chest operation without banning its owner.
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
/// @returns TRUE after cleanup, FALSE while the chest still has pending work.
/// Never call this from an inventory callback or a nested close callback.
int AlmRecoverSession(object oChest);

/// @brief Resolve the original variable item, including a temporarily moved item.
/// @param oChest Owner-bound material chest.
/// @returns Original variable item, or OBJECT_INVALID if unavailable.
object AlmVariables(object oChest);

/// @brief Reclaim a bounded quantity from one rejected material object.
/// @param oChest Catalogue source.
/// @param oItem Rejected item, in an inventory or on the ground.
/// @param iIndex Material index.
/// @param iAmount Maximum units to reclaim.
/// @returns Actual reclaimed units, with whole deletion marked before scheduling.
int AlmReclaimItem(object oChest, object oItem, int iIndex, int iAmount);

/// @brief Remove only rejected material units when physical return cannot fit.
/// @param oChest Material catalogue source.
/// @param oSource Source inventory, including nested bags.
/// @param iIndex Material index.
/// @param iAmount Maximum units to reclaim into the unchanged stored balance.
/// @param iDepth Remaining container depth.
/// @returns Actual reclaimed units; no replacement objects are created.
int AlmReclaim(object oChest, object oSource, int iIndex, int iAmount, int iDepth = 16);

/// @brief Complete one recorded saldo write exactly once after an interruption.
/// @param oChest Material chest carrying the pending operation.
/// @returns TRUE when the write, fee and snapshot are confirmed.
int AlmFinish(object oChest);

/// @brief Record a balance/snapshot transition before writing the variable item.
/// @param oChest Material chest.
/// @param iIndex Material index.
/// @param iBalance New balance derived from actual net transferred units.
/// @param iSeen Current physical chest quantity.
/// @param iFee Withdrawal fee, zero for a rejected or deposited movement.
/// @returns TRUE after confirmation, FALSE with retryable chest-local state.
int AlmCommit(object oChest, int iIndex, int iBalance, int iSeen, int iFee = 0);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

int AlmIndex(object oChest, object oItem)
{
    if (!GetIsObjectValid(oItem) || GetLocalInt(oItem, "CNR_ALM_DISCARD")
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
    SetLocalInt(oChest, "alm_refill_limit", iWanted);
    SetLocalInt(oChest, "alm_refill_count", -1);
    SetLocalInt(oChest, "alm_refill_index", iIndex);
    CreateItemOnObject(sResref, oChest, iWanted);
    int iActual = AlmCount(oChest, oChest, iIndex);
    SetLocalInt(oChest, "alm_refill_count", iActual);
    if (iActual < 0 || iActual > iWanted)
    {
        return FALSE;
    }
    SetLocalInt(oChest, "alm_seen_" + IntToString(iIndex), iActual);
    DeleteLocalInt(oChest, "alm_refill_index");
    return TRUE;
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
                int iAdded = AlmCount(oChest, oTarget, iIndex) - iBefore;
                if (GetIsObjectValid(oSplit)
                    && GetItemPossessor(oSplit) == OBJECT_INVALID)
                {
                    SetUseableFlag(oSplit, FALSE);
                    DestroyObject(oSplit);
                    if (iAdded >= 0 && iAdded <= iTake)
                    {
                        // Restore only undelivered units, even after partial delivery.
                        SetItemStackSize(oItem, iStack - iAdded);
                        return iMoved + iAdded;
                    }
                    return iMoved;
                }
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

object AlmVariables(object oChest)
{
    object oVariables = GetLocalObject(oChest, "alm_variables");
    if (!GetIsObjectValid(oVariables))
    {
        oVariables = GetItemPossessedBy(GetLocalObject(oChest, "user"), CONTENEDOR_VARIABLES);
    }
    return oVariables;
}

int AlmReclaimItem(object oChest, object oItem, int iIndex, int iAmount)
{
    if (iAmount < 1 || AlmIndex(oChest, oItem) != iIndex)
    {
        return 0;
    }
    int iStack = GetItemStackSize(oItem);
    if (iStack < 1)
    {
        return 0;
    }
    if (iAmount >= iStack)
    {
        SetLocalInt(oItem, "CNR_ALM_DISCARD", TRUE);
        SetUseableFlag(oItem, FALSE);
        DestroyObject(oItem);
        return iStack;
    }
    SetItemStackSize(oItem, iStack - iAmount);
    int iActual = iStack - GetItemStackSize(oItem);
    if (iActual < 0 || iActual > iAmount)
    {
        return 0;
    }
    return iActual;
}

int AlmReclaim(object oChest, object oSource, int iIndex, int iAmount, int iDepth)
{
    if (!GetIsObjectValid(oSource) || iAmount < 1 || iDepth < 1)
    {
        return 0;
    }
    int iRemoved = 0;
    object oItem = GetFirstItemInInventory(oSource);
    while (GetIsObjectValid(oItem) && iRemoved < iAmount)
    {
        object oNext = GetNextItemInInventory(oSource);
        if (AlmIndex(oChest, oItem) == iIndex)
        {
            iRemoved += AlmReclaimItem(oChest, oItem, iIndex, iAmount - iRemoved);
        }
        else if (GetIsObjectValid(GetFirstItemInInventory(oItem)))
        {
            iRemoved += AlmReclaim(oChest, oItem, iIndex, iAmount - iRemoved, iDepth - 1);
        }
        oItem = oNext;
    }
    return iRemoved;
}

int AlmFinish(object oChest)
{
    int iIndex = GetLocalInt(oChest, "alm_tx_index");
    if (iIndex == 0)
    {
        return TRUE;
    }
    object oVariables = AlmVariables(oChest);
    if (!GetIsObjectValid(oVariables))
    {
        return FALSE;
    }
    string sVariable = GetLocalArrayString(oChest, "sVarIngOficio", iIndex);
    int iOld = GetLocalInt(oChest, "alm_tx_old");
    int iNew = GetLocalInt(oChest, "alm_tx_new");
    int iLive = GetLocalInt(oVariables, sVariable);
    if (iLive != iOld && iLive != iNew)
    {
        return FALSE;
    }
    if (iLive != iNew)
    {
        SetLocalInt(oVariables, sVariable, iNew);
        if (GetLocalInt(oVariables, sVariable) != iNew)
        {
            return FALSE;
        }
    }
    object oOwner = GetLocalObject(oChest, "user");
    int iFee = GetLocalInt(oChest, "alm_tx_fee");
    if (iFee > 0)
    {
        int iGold = GetLocalInt(oChest, "alm_tx_gold");
        if (GetGold(oOwner) == iGold)
        {
            if (iGold < iFee)
            {
                return FALSE;
            }
            TakeGoldFromCreature(iFee, oOwner, TRUE);
        }
        else if (GetGold(oOwner) != iGold - iFee)
        {
            return FALSE;
        }
    }
    string sSuffix = IntToString(iIndex);
    SetLocalInt(oChest, "alm_balance_" + sSuffix, iNew);
    SetLocalInt(oChest, "alm_seen_" + sSuffix, GetLocalInt(oChest, "alm_tx_seen"));
    DeleteLocalInt(oChest, "alm_tx_index");
    return TRUE;
}

int AlmCommit(object oChest, int iIndex, int iBalance, int iSeen, int iFee)
{
    object oVariables = AlmVariables(oChest);
    if (!GetIsObjectValid(oVariables) || iBalance < 0 || iSeen < 0)
    {
        return FALSE;
    }
    string sVariable = GetLocalArrayString(oChest, "sVarIngOficio", iIndex);
    SetLocalInt(oChest, "alm_tx_old", GetLocalInt(oVariables, sVariable));
    SetLocalInt(oChest, "alm_tx_new", iBalance);
    SetLocalInt(oChest, "alm_tx_seen", iSeen);
    SetLocalInt(oChest, "alm_tx_fee", iFee);
    SetLocalInt(oChest, "alm_tx_gold", GetGold(GetLocalObject(oChest, "user")));
    // Publish after all transition fields exist, before writing the saldo.
    SetLocalInt(oChest, "alm_tx_index", iIndex);
    return AlmFinish(oChest);
}

void AlmBlock(object oChest, string sReason, object oActor)
{
    SetLocalInt(oChest, ALM_FAULT, TRUE);
    SetLocked(oChest, TRUE);
    SetUseableFlag(oChest, FALSE);
    object oOwner = GetLocalObject(oChest, "user");
    if (GetIsPC(oOwner))
    {
        NWNX_Player_OpenInventory(oOwner, oChest, FALSE);
    }
    if (GetIsPC(oActor) && oActor != oOwner)
    {
        NWNX_Player_OpenInventory(oActor, oChest, FALSE);
    }
    WriteTimestampedLogEntry("CNR material store operation paused: " + sReason);
    SendMessageToPC(oOwner, "La operacion no se ha completado. Vuelve a abrir el almacen para reintentar.");
}

void AlmProcess(object oChest, object oActor, int iRefill)
{
    if (GetLocalInt(oChest, ALM_BUSY) || !GetLocalInt(oChest, ALM_READY))
    {
        return;
    }
    SetLocalInt(oChest, ALM_BUSY, TRUE);
    object oPC = GetLocalObject(oChest, "user");
    object oVariables = AlmVariables(oChest);
    if (!GetIsPC(oPC) || !GetIsObjectValid(oVariables) || !AlmFinish(oChest)
        || !AlmScan(oChest))
    {
        AlmBlock(oChest, "pending-write-or-count", oActor);
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
        int iBalance = GetLocalInt(oVariables, sVariable);
        int iValid = oActor == oPC && GetLocalObject(oPC, ALM_SESSION) == oChest
            && iBalance >= 0;
        if (iDelta < 0)
        {
            iValid = iValid && -iDelta <= iBalance && -iDelta <= ALM_INT_MAX / ALM_FEE;
        }
        else
        {
            iValid = iValid && iDelta <= ALM_INT_MAX - iBalance;
        }
        int iAffordable = iDelta >= 0 || (iValid && GetGold(oPC) >= -iDelta * ALM_FEE);
        int iFee = 0;
        if (!iValid || !iAffordable)
        {
            int iReclaimed = 0;
            if (iDelta > 0)
            {
                AlmMoveUnits(oChest, oChest, oActor, iIndex, iDelta);
            }
            else
            {
                // Reclaim a dropped event item before considering original
                // units already carried by the player.
                object oDropped = GetInventoryDisturbItem(oChest);
                if (GetLastDisturbed(oChest) == oActor
                    && GetIsObjectValid(oDropped)
                    && GetItemPossessor(oDropped) == OBJECT_INVALID)
                {
                    iReclaimed = AlmReclaimItem(oChest, oDropped, iIndex, -iDelta);
                }
                AlmMoveUnits(oChest, oActor, oChest, iIndex, -iDelta - iReclaimed);
            }
            iAfter = AlmCount(oChest, oChest, iIndex);
            if (iAfter < 0)
            {
                AlmBlock(oChest, "return-count", oActor);
                DeleteLocalInt(oChest, ALM_BUSY);
                return;
            }
            iDelta = iAfter - iBefore + iReclaimed;
            if (iDelta < 0)
            {
                // If the return cannot fit, reclaim only the borrowed units.
                // Their balance stays stored; no copied replacement is given.
                iDelta += AlmReclaim(oChest, oActor, iIndex, -iDelta);
            }
            if (iDelta == 0)
            {
                SetLocalInt(oChest, "alm_seen_" + sSuffix, iAfter);
                SendMessageToPC(oActor, "No se ha realizado el movimiento. Comprueba el oro y el objeto.");
                if (iRefill && iAfter == 0 && iBalance > 0
                    && !AlmShow(oChest, iIndex, iBalance))
                {
                    AlmBlock(oChest, "return-refill", oActor);
                    DeleteLocalInt(oChest, ALM_BUSY);
                    return;
                }
                continue;
            }
            // An incomplete return is not a full refund: account its actual
            // remaining transfer before any later refill or reopening.
            WriteTimestampedLogEntry("CNR material store accounted residual return units");
        }
        else if (iDelta < 0)
        {
            iFee = -iDelta * ALM_FEE;
        }
        if (iBalance < 0 || (iDelta < 0 && -iDelta > iBalance)
            || (iDelta > 0 && iDelta > ALM_INT_MAX - iBalance))
        {
            AlmBlock(oChest, "unsettled-limit", oActor);
            DeleteLocalInt(oChest, ALM_BUSY);
            return;
        }
        int iNewBalance = iBalance + iDelta;
        if (!AlmCommit(oChest, iIndex, iNewBalance, iAfter, iFee))
        {
            AlmBlock(oChest, "pending-write", oActor);
            DeleteLocalInt(oChest, ALM_BUSY);
            return;
        }
        string sName = GetLocalArrayString(oChest, "sNomIngOficio", iIndex);
        SendMessageToPC(oPC, sName + IntToString(iNewBalance));
        if (iRefill && iAfter == 0 && !AlmShow(oChest, iIndex, iNewBalance))
        {
            AlmBlock(oChest, "refill-count", oActor);
            DeleteLocalInt(oChest, ALM_BUSY);
            return;
        }
    }
    // Rejected real objects are returned after accepted material deltas settle.
    // Failure to fit an object is not a character ban and cannot skip a debit.
    object oItem = GetFirstItemInInventory(oChest);
    while (GetIsObjectValid(oItem))
    {
        object oNext = GetNextItemInInventory(oChest);
        if (AlmIndex(oChest, oItem) == 0 && !GetLocalInt(oItem, "CNR_ALM_DISCARD"))
        {
            object oRecipient = GetLocalObject(oItem, "CNR_ALM_RETURN_TO");
            if (!GetIsObjectValid(oRecipient))
            {
                oRecipient = oPC;
                if (oActor != oPC && GetLastDisturbed(oChest) == oActor
                    && GetInventoryDisturbItem(oChest) == oItem)
                {
                    oRecipient = oActor;
                    SetLocalObject(oItem, "CNR_ALM_RETURN_TO", oActor);
                }
            }
            NWNX_Item_MoveTo(oItem, oRecipient, TRUE);
            SendMessageToPC(oRecipient, "No puedes guardar ese objeto. Si sigue en el cajon, retiralo o libera espacio.");
        }
        oItem = oNext;
    }
    DeleteLocalInt(oChest, ALM_FAULT);
    DeleteLocalInt(oChest, ALM_BUSY);
}

void AlmClose(object oChest)
{
    if (!GetIsObjectValid(oChest) || GetLocalInt(oChest, ALM_BUSY))
    {
        return;
    }
    object oPC = GetLocalObject(oChest, "user");
    int iInitializing = !GetLocalInt(oChest, ALM_READY) && !GetLocalInt(oChest, "alm_closed");
    if (!GetLocalInt(oChest, "alm_closed") && !iInitializing)
    {
        AlmProcess(oChest, oPC, FALSE);
        if (GetLocalInt(oChest, ALM_FAULT) || GetLocalInt(oChest, ALM_BUSY))
        {
            return;
        }
    }
    SetLocalInt(oChest, ALM_BUSY, TRUE);
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
    int iPending = FALSE;
    object oItem = GetFirstItemInInventory(oChest);
    while (GetIsObjectValid(oItem))
    {
        object oNext = GetNextItemInInventory(oChest);
        if (!GetLocalInt(oItem, "CNR_ALM_DISCARD"))
        {
            if (iInitializing || AlmIndex(oChest, oItem) > 0)
            {
                SetLocalInt(oItem, "CNR_ALM_DISCARD", TRUE);
                DestroyObject(oItem);
            }
            else
            {
                object oRecipient = GetLocalObject(oItem, "CNR_ALM_RETURN_TO");
                if (!GetIsObjectValid(oRecipient))
                {
                    oRecipient = oPC;
                }
                NWNX_Item_MoveTo(oItem, oRecipient, TRUE);
                if (GetIsObjectValid(oItem) && GetItemPossessor(oItem) == oChest)
                {
                    iPending = TRUE;
                }
            }
        }
        oItem = oNext;
    }
    SetLocalInt(oChest, "alm_returns", iPending);
    DeleteLocalInt(oChest, ALM_BUSY);
    if (iPending)
    {
        SendMessageToPC(oPC, "Libera espacio y vuelve a usar un almacen para recuperar el objeto rechazado.");
        return;
    }
    if (GetLocalObject(oPC, ALM_SESSION) == oChest)
    {
        DeleteLocalObject(oPC, ALM_SESSION);
    }
    DestroyObject(oChest);
}

int AlmSessionActive(object oChest)
{
    if (!GetIsObjectValid(oChest) || GetLocalInt(oChest, "alm_closed")
        || GetLocalInt(oChest, "alm_gui_closed")
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
    // Fresh use/heartbeat can resume a recorded write, never a second debit.
    SetLocalInt(oChest, ALM_BUSY, TRUE);
    if (!AlmFinish(oChest))
    {
        AlmBlock(oChest, "retry-write");
        return FALSE;
    }
    int iRefill = GetLocalInt(oChest, "alm_refill_index");
    if (iRefill > 0)
    {
        int iCreated = GetLocalInt(oChest, "alm_refill_count");
        if (iCreated < 0 || iCreated > GetLocalInt(oChest, "alm_refill_limit"))
        {
            AlmBlock(oChest, "retry-refill");
            return FALSE;
        }
        // Keep the captured creation count: any later withdrawal is a delta.
        SetLocalInt(oChest, "alm_seen_" + IntToString(iRefill), iCreated);
        DeleteLocalInt(oChest, "alm_refill_index");
    }
    DeleteLocalInt(oChest, ALM_BUSY);
    DeleteLocalInt(oChest, ALM_FAULT);
    AlmClose(oChest);
    return GetLocalInt(oChest, "alm_closed") && !GetLocalInt(oChest, "alm_returns");
}
