/// ----------------------------------------------------------------------------
/// @system  CNR Harvesting
/// @file    cnr_i_skin
/// @author  Dhraax
/// @brief   Grant hides by activating an equipped knife on an ordinary corpse.
/// modified by: Dhraax
/// ----------------------------------------------------------------------------
#include "cnr_i_stack"

const string CNR_SKIN_KNIFE = "cnr_t_desollador";
const string CNR_SKIN_CREATURE = "PIEL";
const string CNR_SKIN_READY = "CNR_SKIN_READY";
const string CNR_SKIN_LEFT = "CNR_SKIN_LEFT";
const string CNR_SKIN_BUSY = "CNR_SKIN_BUSY";
const string CNR_SKIN_USES = "CNR_USOS";
const int CNR_SKIN_DELIVERIES = 3;
const float CNR_SKIN_COOLDOWN = 10.0;

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

/// @brief Resolve the hide resource encoded by PIEL.
/// @param nPiel The creature's PIEL value.
/// @returns A hide resref for values 1-10, otherwise an empty string.
string CnrSkin_Material(int nPiel);

/// @brief Resolve the harvesting tier encoded by PIEL.
/// @param nPiel The creature's PIEL value.
/// @returns A tier from 1-4, otherwise zero.
int CnrSkin_Tier(int nPiel);

/// @brief Roll the existing hide quantity for one delivery.
/// @param nTier The hide tier.
/// @returns 1d4 at tiers 1-2, 2d4 at tier 3, or 3d4 at tier 4.
int CnrSkin_Amount(int nTier);

/// @brief Deliver hides on one knife activation without changing corpse cleanup.
/// @param oPC The activating player.
/// @param oKnife The actual activated knife, equipped in either hand.
/// @param oTarget The dead creature or its existing linked loot bag.
void CnrSkin_Activate(object oPC, object oKnife, object oTarget);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

string CnrSkin_Material(int nPiel)
{
    switch (nPiel)
    {
        case 1:  return "cnr_m_pi_roedor";
        case 2:  return "cnr_m_pi_herbiv";
        case 3:  return "cnr_m_pi_bestia";
        case 4:  return "cnr_m_pi_bestiag";
        case 5:  return "cnr_m_pi_mitica";
        case 6:  return "cnr_m_pi_miticag";
        case 7:  return "cnr_m_pi_dracof";
        case 8:  return "cnr_m_pi_dracoh";
        case 9:  return "cnr_m_pi_dracoa";
        case 10: return "cnr_m_pi_dracor";
    }
    return "";
}

int CnrSkin_Tier(int nPiel)
{
    if (nPiel <= 0)  return 0;
    if (nPiel <= 2)  return 1;
    if (nPiel <= 4)  return 2;
    if (nPiel <= 6)  return 3;
    if (nPiel <= 10) return 4;
    return 0;
}

int CnrSkin_Amount(int nTier)
{
    if (nTier >= 4) return d4(3);
    if (nTier == 3) return d4(2);
    return d4();
}

/// @brief Count loose hide units for synchronous delivery verification.
/// @param oPC The receiving player.
/// @param sMaterial The hide tag, identical to its resource name.
/// @returns The total matching units in the player's direct inventory.
int CnrSkin_CountHides(object oPC, string sMaterial)
{
    int iCount = 0;
    object oItem = GetFirstItemInInventory(oPC);
    while (GetIsObjectValid(oItem))
    {
        if (GetTag(oItem) == sMaterial)
        {
            iCount += GetItemStackSize(oItem);
        }
        oItem = GetNextItemInInventory(oPC);
    }
    return iCount;
}

/// @brief Grant the entire roll in chunks of ten or roll back new units.
/// @param oPC The receiving player.
/// @param sMaterial The hide resource and tag.
/// @param iAmount The full rolled quantity.
/// @returns TRUE only when every rolled unit reached the player's inventory.
int CnrSkin_GiveHides(object oPC, string sMaterial, int iAmount)
{
    int iBefore = CnrSkin_CountHides(oPC, sMaterial);
    int iRemaining = iAmount;
    while (iRemaining > 0)
    {
        int iChunk = (iRemaining > 10) ? 10 : iRemaining;
        object oCreated = CreateItemOnObject(sMaterial, oPC, iChunk);
        if (!GetIsObjectValid(oCreated))
        {
            break;
        }
        iRemaining -= iChunk;
    }

    int iAdded = CnrSkin_CountHides(oPC, sMaterial) - iBefore;
    if (iRemaining == 0 && iAdded == iAmount)
    {
        return TRUE;
    }

    // Creation may merge into existing stacks. Remove only the added units.
    object oItem = GetFirstItemInInventory(oPC);
    while (GetIsObjectValid(oItem) && iAdded > 0)
    {
        object oNext = GetNextItemInInventory(oPC);
        if (GetTag(oItem) == sMaterial)
        {
            int iStack = GetItemStackSize(oItem);
            if (iStack > iAdded)
            {
                SetItemStackSize(oItem, iStack - iAdded);
                iAdded = 0;
            }
            else
            {
                DestroyObject(oItem);
                iAdded -= iStack;
            }
        }
        oItem = oNext;
    }
    return FALSE;
}

void CnrSkin_Activate(object oPC, object oKnife, object oTarget)
{
    if (!GetIsPC(oPC) || GetIsDead(oPC) || !GetIsObjectValid(oKnife)
        || GetTag(oKnife) != CNR_SKIN_KNIFE)
    {
        return;
    }
    if (oKnife != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)
        && oKnife != GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC))
    {
        SendMessageToPC(oPC, "Equipa el cuchillo de desollar que estas activando.");
        return;
    }

    object oCorpse = oTarget;
    if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
    {
        oCorpse = GetLocalObject(oTarget, "corpse_object");
    }
    if (!GetIsObjectValid(oCorpse)
        || GetObjectType(oCorpse) != OBJECT_TYPE_CREATURE || !GetIsDead(oCorpse))
    {
        SendMessageToPC(oPC, "Selecciona el cadaver de una criatura.");
        return;
    }
    if (GetArea(oPC) != GetArea(oCorpse) || GetDistanceBetween(oPC, oCorpse) > 3.0)
    {
        SendMessageToPC(oPC, "Acercate al cadaver para desollarlo.");
        return;
    }

    int iPiel = GetLocalInt(oCorpse, CNR_SKIN_CREATURE);
    string sMaterial = CnrSkin_Material(iPiel);
    if (sMaterial == "")
    {
        SendMessageToPC(oPC, "Esta criatura no tiene piel aprovechable.");
        return;
    }
    if (!GetLocalInt(oCorpse, CNR_SKIN_READY))
    {
        SetLocalInt(oCorpse, CNR_SKIN_READY, TRUE);
        SetLocalInt(oCorpse, CNR_SKIN_LEFT, CNR_SKIN_DELIVERIES);
    }
    int iLeft = GetLocalInt(oCorpse, CNR_SKIN_LEFT);
    if (iLeft <= 0)
    {
        SendMessageToPC(oPC, "Ya no queda nada aprovechable en el cadaver.");
        return;
    }
    if (GetLocalInt(oCorpse, CNR_SKIN_BUSY))
    {
        SendMessageToPC(oPC, "Debes esperar diez segundos entre entregas de este cadaver.");
        return;
    }

    int iTier = CnrSkin_Tier(iPiel);
    // Lock before granting items; failed deliveries spend no cooldown or wear.
    SetLocalInt(oCorpse, CNR_SKIN_BUSY, TRUE);
    if (!CnrSkin_GiveHides(oPC, sMaterial, CnrSkin_Amount(iTier)))
    {
        DeleteLocalInt(oCorpse, CNR_SKIN_BUSY);
        SendMessageToPC(oPC, "No te cabe nada mas.");
        return;
    }
    SetLocalInt(oCorpse, CNR_SKIN_LEFT, iLeft - 1);
    DelayCommand(CNR_SKIN_COOLDOWN, DeleteLocalInt(oCorpse, CNR_SKIN_BUSY));
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 1.5));
    if (iLeft == 1)
    {
        SendMessageToPC(oPC, "Has aprovechado todo lo que este cadaver daba.");
    }

    int iUses = GetLocalInt(oKnife, CNR_SKIN_USES);
    if (iUses <= 0)
    {
        iUses = 40;
    }
    iUses -= (iTier >= 4) ? 3 : ((iTier == 3) ? 2 : 1);
    if (iUses <= 0)
    {
        SendMessageToPC(oPC, "Tu cuchillo de desollar se ha roto.");
        CnrStack_BreakTool(oKnife, CNR_SKIN_USES);
    }
    else
    {
        SetLocalInt(oKnife, CNR_SKIN_USES, iUses);
    }
}
