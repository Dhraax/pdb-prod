/// ----------------------------------------------------------------------------
/// @system  CNR Harvesting
/// @file    cnr_i_skin
/// @author  Dhraax
/// @brief   Skinning: the corpse of an animal is a harvesting node like a vein
///          or a tree, and it answers to the same rules.
///
///          The creature already says what it is worth. Its blueprint carries
///          the local int PIEL, and those ten values map one to one, in order,
///          onto the ten leatherworking hides: 1 and 2 are tier 1, 3 and 4
///          tier 2, 5 and 6 tier 3, and 7 to 10 the four dragon hides of tier
///          4. Nothing has to be retagged; the corpse copies the value and the
///          material out of the creature that died.
///
///          Like every other node: no experience, no trade level required, one
///          answer every ten seconds, three deliveries and then it is done.
/// modified by: Dhraax
/// ----------------------------------------------------------------------------
#include "cnr_i_stack"
#include "cnr_i_node"

// -----------------------------------------------------------------------------
//                                  Constants
// -----------------------------------------------------------------------------
/// The knife the player has to hold. Sold by the leatherworking store.
const string CNR_SKIN_KNIFE     = "cnr_t_desollador";
/// What the creature blueprint calls the hide it carries.
const string CNR_SKIN_CREATURE  = "PIEL";
/// Previous attack handler, preserved for a creature raised after death.
const string CNR_SKIN_ATTACK_SCRIPT = "CNR_SKIN_ATTACK_SCRIPT";
/// Deliveries in one corpse. Existing corpse cleanup owns its lifetime.
const int    CNR_SKIN_DELIVERIES = 3;

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

/// @brief The hide a PIEL value stands for.
/// @param nPiel The creature's PIEL value, 1 to 10.
/// @returns The blueprint resref of the hide, or "" when the value is unknown.
string CnrSkin_Material(int nPiel);

/// @brief The tier a PIEL value belongs to.
/// @param nPiel The creature's PIEL value, 1 to 10.
/// @returns 1 to 4, or 0 when the value is unknown.
int CnrSkin_Tier(int nPiel);

/// @brief How many hides one delivery hands over.
/// @param nTier The corpse tier.
/// @returns 1d4 at tiers 1 and 2, 2d4 at tier 3, 3d4 at tier 4.
int CnrSkin_Amount(int nTier);

/// @brief Mark the existing dead creature as skinnable without cloning it.
/// @param oCreature The dead creature. Does nothing when it carries no PIEL.
void CnrSkin_SpawnCorpse(object oCreature);

/// @brief One skinning attempt against a corpse.
/// @param oPC Who is skinning.
/// @param oCorpse The existing dead creature.
void CnrSkin_Strike(object oPC, object oCorpse);

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

void CnrSkin_SpawnCorpse(object oCreature)
{
    int nPiel = GetLocalInt(oCreature, CNR_SKIN_CREATURE);
    string sMaterial = CnrSkin_Material(nPiel);
    if (sMaterial == "")
    {
        return;
    }

    if (!GetIsObjectValid(oCreature) || !GetIsDead(oCreature))
    {
        return;
    }

    object oCorpse = oCreature;
    string sPrevious = GetEventScript(oCorpse, EVENT_SCRIPT_CREATURE_ON_MELEE_ATTACKED);
    if (!SetEventScript(oCorpse, EVENT_SCRIPT_CREATURE_ON_MELEE_ATTACKED, "cnr_skin_hit"))
    {
        PrintString("[CNR] Cannot attach skinning to the existing creature corpse.");
        return;
    }
    if (sPrevious != "cnr_skin_hit")
    {
        SetLocalString(oCorpse, CNR_SKIN_ATTACK_SCRIPT, sPrevious);
    }

    SetIsDestroyable(FALSE, GetLocalInt(oCorpse, "fl_raiseable") > 0, TRUE, oCorpse);

    // The corpse carries everything the strike needs, exactly like a vein.
    SetLocalString(oCorpse, CNR_NODE_FAMILY, "cadaver");
    SetLocalString(oCorpse, CNR_NODE_MATERIAL, sMaterial);
    SetLocalInt(oCorpse, CNR_NODE_TIER, CnrSkin_Tier(nPiel));
    SetLocalInt(oCorpse, CNR_NODE_LEFT, CNR_SKIN_DELIVERIES);
    SetLocalString(oCorpse, "CNR_CADAVER_DE", GetName(oCreature));

}

void CnrSkin_Strike(object oPC, object oCorpse)
{
    if (!GetIsObjectValid(oCorpse) || !GetIsDead(oCorpse))
    {
        return;
    }

    string sMaterial = GetLocalString(oCorpse, CNR_NODE_MATERIAL);
    if (sMaterial == "")
    {
        return;
    }

    // One answer every ten seconds, whoever is cutting and however fast.
    if (GetLocalInt(oCorpse, CNR_NODE_BUSY))
    {
        return;
    }
    SetLocalInt(oCorpse, CNR_NODE_BUSY, TRUE);
    DelayCommand(CNR_NODE_COOLDOWN, DeleteLocalInt(oCorpse, CNR_NODE_BUSY));

    object oKnife = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    if (GetTag(oKnife) != CNR_SKIN_KNIFE)
    {
        oKnife = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
    }
    if (GetTag(oKnife) != CNR_SKIN_KNIFE)
    {
        SendMessageToPC(oPC, "Necesitas un cuchillo de desollar en la mano.");
        return;
    }

    int nLeft = GetLocalInt(oCorpse, CNR_NODE_LEFT);
    if (nLeft <= 0)
    {
        SendMessageToPC(oPC, "Ya no queda nada aprovechable en el cadaver.");
        return;
    }

    int nTier = GetLocalInt(oCorpse, CNR_NODE_TIER);
    int nAmount = CnrSkin_Amount(nTier);
    if (!GetIsObjectValid(CreateItemOnObject(sMaterial, oPC, nAmount)))
    {
        SendMessageToPC(oPC, "No te cabe nada mas.");
        return;
    }

    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 1.5));

    // The corpse and the knife are only spent when something came out.
    nLeft--;
    SetLocalInt(oCorpse, CNR_NODE_LEFT, nLeft);
    if (nLeft <= 0)
    {
        SendMessageToPC(oPC, "Has aprovechado todo lo que este cadaver daba.");
    }

    int nUses = GetLocalInt(oKnife, CNR_NODE_TOOL_USES);
    if (nUses <= 0)
    {
        // Stamped the first time the knife is used, not when it is bought, so
        // one bought long ago still works.
        nUses = 40;
    }

    nUses -= (nTier >= 4) ? 3 : ((nTier == 3) ? 2 : 1);

    if (nUses <= 0)
    {
        SendMessageToPC(oPC, "Tu cuchillo de desollar se ha roto.");
        CnrStack_BreakTool(oKnife, CNR_NODE_TOOL_USES);
    }
    else
    {
        SetLocalInt(oKnife, CNR_NODE_TOOL_USES, nUses);
    }
}
