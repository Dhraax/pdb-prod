/// ----------------------------------------------------------------------------
/// @system  CNR Recycling
/// @file    cnr_i_recycle
/// @author  Dhraax
/// @brief   Recipe-component refunds and tier-based gold payouts.
/// ----------------------------------------------------------------------------

#include "nwnx_sql"
#include "cnr_i_product"

const string CNR_REC_PENDING = "CNR_REC_PENDING";
const string CNR_REC_LOCK = "CNR_REC_LOCK";
const string CNR_REC_ITEM = "CNR_REC_ITEM";
const string CNR_REC_PLAN = "CNR_REC_PLAN";
const string CNR_REC_QUANTITY = "CNR_REC_QUANTITY";
const string CNR_REC_NEXT = "CNR_REC_NEXT";
const int CNR_REC_TOKEN = 22401;
const float CNR_REC_SEAL_SECONDS = 6.0f;

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

/// @brief Read the single input stack and validate its crafting tier.
/// @param oMachine Recycling placeable.
/// @returns Input item, or OBJECT_INVALID for empty, multiple or invalid inputs.
object CnrRec_Input(object oMachine);

/// @brief Build the payout for the input's current recipe ID.
/// @param oItem Crafted input stack.
/// @returns G|gold or M|resref|quantity|name; rows; empty on query failure.
string CnrRec_Plan(object oItem);

/// @brief Render a previously calculated payout.
/// @param sPlan Serialized payout.
/// @returns Player-facing payout description.
string CnrRec_Describe(string sPlan);

/// @brief Clear conversation state and briefly suppress leftover use events.
/// @param oPC Player leaving the recycler conversation.
/// @param oMachine Recycling placeable.
void CnrRec_Seal(object oPC, object oMachine);

/// @brief Remove staged payout objects after an unsuccessful staging operation.
/// @param oHead Head of the staged-item linked list.
void CnrRec_Discard(object oHead);

/// @brief Create the full material payout away from inventories before charging.
/// @param sPlan Material payout.
/// @param oPC Player receiving the materials.
/// @returns Head of staged items, or OBJECT_INVALID after cleaning up a failure.
object CnrRec_Stage(string sPlan, object oPC);

/// @brief Confirm an unchanged preview and pay exactly once.
/// @param oPC Player confirming recycling.
/// @param oMachine Recycling placeable.
void CnrRec_Recycle(object oPC, object oMachine);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

object CnrRec_Input(object oMachine)
{
    object oItem = GetFirstItemInInventory(oMachine);
    if (!GetIsObjectValid(oItem)
        || GetIsObjectValid(GetNextItemInInventory(oMachine)))
    {
        return OBJECT_INVALID;
    }
    int iTier = GetLocalInt(oItem, CNR_PRODUCT_TIER);
    return (iTier >= 1 && iTier <= 4) ? oItem : OBJECT_INVALID;
}

string CnrRec_Plan(object oItem)
{
    int iQuantity = GetItemStackSize(oItem);
    if (!NWNX_SQL_PrepareQuery(
        "SELECT output_qty FROM cnr_recipe WHERE recipe_id = ? LIMIT 1"))
    {
        return "";
    }
    NWNX_SQL_PreparedInt(0, GetLocalInt(oItem, CNR_PRODUCT_RECIPE));
    if (!NWNX_SQL_ExecutePreparedQuery())
    {
        return "";
    }
    if (!NWNX_SQL_ReadyToReadNextRow())
    {
        return "G|" + IntToString(
            1000 * GetLocalInt(oItem, CNR_PRODUCT_TIER) * iQuantity);
    }
    NWNX_SQL_ReadNextRow();
    int iOutput = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
    if (iOutput <= 0)
    {
        return "";
    }

    if (!NWNX_SQL_PrepareQuery(
        "SELECT component_tag, qty - retain_on_success,"
        + " IFNULL(display_name, component_tag)"
        + " FROM cnr_recipe_component WHERE recipe_id = ? ORDER BY sort_order"))
    {
        return "";
    }
    NWNX_SQL_PreparedInt(0, GetLocalInt(oItem, CNR_PRODUCT_RECIPE));
    if (!NWNX_SQL_ExecutePreparedQuery())
    {
        return "";
    }

    string sPlan = "M|";
    while (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        // Positive integer division floors once per component for this stack.
        int iRefund = (StringToInt(NWNX_SQL_ReadDataInActiveRow(1))
                       * iQuantity) / (4 * iOutput);
        if (iRefund > 0)
        {
            sPlan += NWNX_SQL_ReadDataInActiveRow(0) + "|"
                  + IntToString(iRefund) + "|"
                  + NWNX_SQL_ReadDataInActiveRow(2) + ";";
        }
    }
    return sPlan;
}

string CnrRec_Describe(string sPlan)
{
    if (GetStringLeft(sPlan, 2) == "G|")
    {
        return GetStringRight(sPlan, GetStringLength(sPlan) - 2)
             + " monedas de oro.";
    }
    string sRest = GetStringRight(sPlan, GetStringLength(sPlan) - 2);
    if (sRest == "")
    {
        return "Ningun material: todas las cantidades se redondean a cero.";
    }
    string sText = "Materiales devueltos (25%, redondeado hacia abajo):";
    while (sRest != "")
    {
        int iEnd = FindSubString(sRest, ";");
        string sRow = GetStringLeft(sRest, iEnd);
        sRest = GetStringRight(sRest, GetStringLength(sRest) - iEnd - 1);
        int iBar = FindSubString(sRow, "|");
        sRow = GetStringRight(sRow, GetStringLength(sRow) - iBar - 1);
        iBar = FindSubString(sRow, "|");
        sText += "\n  " + GetStringLeft(sRow, iBar) + " x "
               + GetStringRight(sRow, GetStringLength(sRow) - iBar - 1);
    }
    return sText;
}

void CnrRec_Seal(object oPC, object oMachine)
{
    DeleteLocalObject(oPC, CNR_REC_PENDING);
    DeleteLocalObject(oPC, CNR_REC_ITEM);
    DeleteLocalString(oPC, CNR_REC_PLAN);
    DeleteLocalInt(oPC, CNR_REC_QUANTITY);
    SetLocalInt(oMachine, CNR_REC_LOCK, TRUE);
    DelayCommand(CNR_REC_SEAL_SECONDS, DeleteLocalInt(oMachine, CNR_REC_LOCK));
}

void CnrRec_Discard(object oHead)
{
    while (GetIsObjectValid(oHead))
    {
        object oNext = GetLocalObject(oHead, CNR_REC_NEXT);
        DestroyObject(oHead);
        oHead = oNext;
    }
}

object CnrRec_Stage(string sPlan, object oPC)
{
    string sRest = GetStringRight(sPlan, GetStringLength(sPlan) - 2);
    object oHead = OBJECT_INVALID;
    while (sRest != "")
    {
        int iEnd = FindSubString(sRest, ";");
        string sRow = GetStringLeft(sRest, iEnd);
        sRest = GetStringRight(sRest, GetStringLength(sRest) - iEnd - 1);
        int iBar = FindSubString(sRow, "|");
        string sResRef = GetStringLeft(sRow, iBar);
        sRow = GetStringRight(sRow, GetStringLength(sRow) - iBar - 1);
        int iRemaining = StringToInt(GetStringLeft(sRow, FindSubString(sRow, "|")));
        int iMaxStack = 0;
        while (iRemaining > 0)
        {
            object oMaterial = CreateObject(OBJECT_TYPE_ITEM, sResRef,
                                            GetLocation(oPC));
            if (!GetIsObjectValid(oMaterial))
            {
                CnrRec_Discard(oHead);
                return OBJECT_INVALID;
            }
            if (iMaxStack == 0)
            {
                iMaxStack = StringToInt(Get2DAString("baseitems", "Stacking",
                                                    GetBaseItemType(oMaterial)));
                if (iMaxStack < 1)
                {
                    iMaxStack = 1;
                }
            }
            int iChunk = iRemaining > iMaxStack ? iMaxStack : iRemaining;
            SetItemStackSize(oMaterial, iChunk);
            SetIdentified(oMaterial, TRUE);
            SetStolenFlag(oMaterial, TRUE);
            SetLocalObject(oMaterial, CNR_REC_NEXT, oHead);
            oHead = oMaterial;
            iRemaining -= iChunk;
        }
    }
    return oHead;
}

void CnrRec_Recycle(object oPC, object oMachine)
{
    object oItem = CnrRec_Input(oMachine);
    if (!GetIsObjectValid(oItem)
        || oItem != GetLocalObject(oPC, CNR_REC_ITEM)
        || GetItemStackSize(oItem) != GetLocalInt(oPC, CNR_REC_QUANTITY))
    {
        SendMessageToPC(oPC, "El contenido ha cambiado. Revisa de nuevo el reciclado.");
        return;
    }
    string sPlan = CnrRec_Plan(oItem);
    if (sPlan == "" || sPlan != GetLocalString(oPC, CNR_REC_PLAN))
    {
        SendMessageToPC(oPC, "No se pudo confirmar la salida. No se ha gastado nada.");
        return;
    }

    object oHead = OBJECT_INVALID;
    if (GetStringLeft(sPlan, 2) == "M|" && sPlan != "M|")
    {
        oHead = CnrRec_Stage(sPlan, oPC);
        if (!GetIsObjectValid(oHead))
        {
            SendMessageToPC(oPC, "No se pudieron crear los materiales. El objeto se conserva.");
            return;
        }
    }

    // Destruction is queued; revoke eligibility synchronously before paying.
    SetLocalInt(oItem, CNR_PRODUCT_TIER, 0);
    DeleteLocalObject(oPC, CNR_REC_ITEM);
    DestroyObject(oItem);
    if (GetStringLeft(sPlan, 2) == "G|")
    {
        GiveGoldToCreature(oPC,
            StringToInt(GetStringRight(sPlan, GetStringLength(sPlan) - 2)));
    }
    int iOnGround = FALSE;
    while (GetIsObjectValid(oHead))
    {
        object oNext = GetLocalObject(oHead, CNR_REC_NEXT);
        DeleteLocalObject(oHead, CNR_REC_NEXT);
        if (GetIsObjectValid(CopyItem(oHead, oPC, FALSE)))
        {
            DestroyObject(oHead);
        }
        else
        {
            iOnGround = TRUE;
        }
        oHead = oNext;
    }
    SendMessageToPC(oPC, "Reciclado completado.\n" + CnrRec_Describe(sPlan));
    if (iOnGround)
    {
        SendMessageToPC(oPC, "No caben todos los materiales: recoge los que quedan a tus pies.");
    }
}
