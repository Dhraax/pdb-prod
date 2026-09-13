/// ----------------------------------------------------------------------------
/// @system  CNR Harvesting
/// @file    cnr_i_node
/// @author  Dhraax
/// @brief   Harvesting nodes: what a vein, a tree or a plant gives when it is
///          struck, and what it costs to take it.
///
///          Everything the node needs to know it carries on itself, put there
///          by the blueprint: CNR_NODO says which family it is, CNR_TIER how
///          hard it is, CNR_MATERIAL what it drops, and CNR_CONDICION the three
///          plants that only give at a certain time. Nothing is read from the
///          database except the gems a mineral vein hands over as a bonus.
///
///          Harvesting grants no experience and asks for no trade level.
///          Anyone can do it, which is what makes the material worth trading.
/// modified by: Dhraax
/// ----------------------------------------------------------------------------

#include "nwnx_sql"

// -----------------------------------------------------------------------------
//                                  Constants
// -----------------------------------------------------------------------------

/// What the blueprint states about itself.
const string CNR_NODE_FAMILY   = "CNR_NODO";
const string CNR_NODE_TIER     = "CNR_TIER";
const string CNR_NODE_MATERIAL = "CNR_MATERIAL";
const string CNR_NODE_COND     = "CNR_CONDICION";

/// What the node remembers while it is being worked.
const string CNR_NODE_LEFT  = "CNR_NODO_QUEDA";   ///< deliveries still in it
const string CNR_NODE_BUSY  = "CNR_NODO_ESPERA";  ///< inside the cooldown
const string CNR_NODE_SPENT = "CNR_NODO_AGOTADO"; ///< run dry, waiting to refill

/// Wear left on a tool, counted down as it hands material over.
const string CNR_NODE_TOOL_USES = "CNR_USOS";

/// A node answers once every this many seconds, whoever is hitting it and
/// however fast. Without it the yield would depend on attacks per round.
const float CNR_NODE_COOLDOWN = 10.0f;

/// And it refills this long after running dry. It never disappears.
const float CNR_NODE_REFILL = 7200.0f;

/// When the day starts and ends, copied from the module: Mod_DawnHour and
/// Mod_DuskHour in module.ifo. Nothing in NWScript reads those, so if they are
/// ever moved in the toolset they have to be moved here as well.
const int CNR_NODE_DAWN = 6;
const int CNR_NODE_DUSK = 18;

/// Chance of the extras a mineral vein gives on top of its own nugget. Coal is
/// rolled on a delivery; the gem is rolled on every strike the vein answers,
/// which is not the same thing - see CnrNode_Strike.
const int CNR_NODE_COAL_CHANCE = 20;
const int CNR_NODE_GEM_CHANCE  = 12;
/// Tier 4 veins have no gem of their own tier, so they give a lower one, and
/// rarely: they are mined for the metal.
const int CNR_NODE_GEM_CHANCE_T4 = 6;

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

/// @brief The tool the player is holding for this family of node.
/// @param oPC Who is striking.
/// @param sFamily CNR_NODO value.
/// @returns The equipped tool, or OBJECT_INVALID when it is the wrong one.
object CnrNode_Tool(object oPC, string sFamily);

/// @brief Which ability this family is worked with.
/// @param sFamily CNR_NODO value.
/// @returns An ABILITY_* constant.
int CnrNode_Ability(string sFamily);

/// @brief The difficulty of a node, by tier.
/// @param nTier 1 to 4.
/// @returns The DC of the roll.
int CnrNode_DC(int nTier);

/// @brief How many units one delivery hands over.
/// @param sFamily CNR_NODO value.
/// @param nTier 1 to 4.
/// @returns The count.
int CnrNode_Amount(string sFamily, int nTier);

/// @brief How many deliveries a node holds when it charges.
/// @param nTier 1 to 4.
/// @returns The count, rolled.
int CnrNode_Yield(int nTier);

/// @brief What the player is told when there is nothing left to take.
/// @param sFamily CNR_NODO value.
/// @returns A player-facing line.
string CnrNode_SpentText(string sFamily);

/// @brief Puts a spent node back to work.
/// @param oNode The node.
void CnrNode_Refill(object oNode);

/// @brief One rough gem of a tier, drawn at random.
/// @param nTier 1 to 3; 4 falls back to the tiers below.
/// @returns Its resref, or an empty string.
string CnrNode_RandomGem(int nTier);

/// @brief Divide two integers using mathematical floor for negative results.
/// @param nDividend Value to divide.
/// @param nDivisor Positive divisor.
/// @returns floor(nDividend / nDivisor), or 0 for an invalid divisor.
int CnrNode_FloorDivide(int nDividend, int nDivisor);

/// @brief Whether it is daylight, counted by the clock.
/// @returns TRUE from the dawn hour until the dusk hour.
int CnrNode_IsDay();

/// @brief Whether the character can see what is invisible, however they got
///     it: a spell, an item, a racial trait.
/// @param oPC The harvester.
/// @returns TRUE when see invisibility or true seeing is on them.
int CnrNode_SeesInvisible(object oPC);

/// @brief Resolves one strike: checks, rolls, and hands material over.
/// @param oPC Who is striking.
/// @param oNode The node being struck.
void CnrNode_Strike(object oPC, object oNode);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

object CnrNode_Tool(object oPC, string sFamily)
{
    object oTool = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    if (!GetIsObjectValid(oTool))
    {
        return OBJECT_INVALID;
    }

    string sTag = GetTag(oTool);

    if (sFamily == "arbol")
    {
        if (sTag == "carp_hl" || sTag == "carp_hlp") { return oTool; }
    }
    else if (sFamily == "planta")
    {
        if (sTag == "cuchillorecolector" || sTag == "hozrecolector") { return oTool; }
    }
    else if (sFamily == "gema")
    {
        // One tool per family, with nothing crossing over: the gem pick works
        // gem veins and only those, and the miner's does not reach them.
        if (sTag == "picodegemas") { return oTool; }
    }
    else if (sFamily == "veta")
    {
        if (sTag == "picodeminero" || sTag == "mazodeminero") { return oTool; }
    }

    return OBJECT_INVALID;
}

int CnrNode_Ability(string sFamily)
{
    if (sFamily == "arbol")  { return ABILITY_STRENGTH; }
    if (sFamily == "planta") { return ABILITY_DEXTERITY; }
    return ABILITY_CONSTITUTION;
}

int CnrNode_DC(int nTier)
{
    switch (nTier)
    {
        case 1: return 14;
        case 2: return 15;
        case 3: return 16;
    }
    return 16;
}

int CnrNode_Amount(string sFamily, int nTier)
{
    // A hit that lands is worth more than one piece, because the cooldown
    // already sets the pace: without this a vein gave a nugget every ten
    // seconds and no more, whoever was working it and whatever it was made of.
    //
    // Two exceptions give one. The tier 4 metals, so the scarce stay scarce.
    // And every gem vein: a recipe eats ore and planks by the handful but sets
    // one stone per ring, and a gem vein already hands out three to six
    // different ones, so it gives variety without needing volume.
    if (sFamily == "gema" || nTier >= 4)
    {
        return 1;
    }
    return 2;
}

int CnrNode_Yield(int nTier)
{
    // Rolled when the node charges, so two veins of the same kind never give
    // the same, and none of them empties in two swings.
    switch (nTier)
    {
        case 1:
        case 2: return 8 + d4();
        case 3: return 7 + d4();
    }
    return 6 + d4();
}

string CnrNode_SpentText(string sFamily)
{
    // Nothing grows back out of a rock: what ran out is what was within reach.
    // Coming back later works because the ground shifts, the rubble is cleared
    // and another seam surfaces - not because the stone breeds ore.
    if (sFamily == "arbol")
    {
        return "¡Vaya, de este árbol ya no sale madera aprovechable! Mejor "
             + "volver más tarde.";
    }
    if (sFamily == "planta")
    {
        return "¡Vaya, no queda nada que merezca la pena recoger! Mejor volver "
             + "más tarde.";
    }
    return "¡Vaya, parece no haber más nada útil que sacar! Mejor volver más "
         + "tarde.";
}

void CnrNode_Refill(object oNode)
{
    if (!GetIsObjectValid(oNode))
    {
        return;
    }

    DeleteLocalInt(oNode, CNR_NODE_SPENT);
    SetLocalInt(oNode, CNR_NODE_LEFT,
                CnrNode_Yield(GetLocalInt(oNode, CNR_NODE_TIER)));
}

string CnrNode_RandomGem(int nTier)
{
    // The gems are the jewellery materials, so the tier is the one the trade
    // already assigns them. There is no tier 4 gem and there will not be, so a
    // tier 4 vein reaches down instead.
    if (nTier >= 4)
    {
        nTier = Random(3) + 1;
    }

    if (!NWNX_SQL_PrepareQuery(
        "SELECT code FROM cnr_material"
        + " WHERE profession_id = 5 AND tier = ? AND enabled = 1"
        + " ORDER BY RAND() LIMIT 1"))
    {
        return "";
    }

    NWNX_SQL_PreparedInt(0, nTier);

    if (!NWNX_SQL_ExecutePreparedQuery() || !NWNX_SQL_ReadyToReadNextRow())
    {
        return "";
    }

    NWNX_SQL_ReadNextRow();
    return NWNX_SQL_ReadDataInActiveRow(0);
}

int CnrNode_FloorDivide(int nDividend, int nDivisor)
{
    // NWScript truncates towards zero, so a negative odd dividend rounds the
    // wrong way: Constitution 9 gave 0 instead of -1 and 7 gave -1 instead of
    // -2, which handed the weakest harvesters a bonus they had not earned.
    // The crafting include carries the same helper; it is repeated here rather
    // than imported, because pulling the whole crafting engine into a node's
    // include chain to reuse ten lines is the worse trade.
    if (nDivisor <= 0)
    {
        return 0;
    }

    if (nDividend >= 0)
    {
        return nDividend / nDivisor;
    }

    return -((-nDividend + nDivisor - 1) / nDivisor);
}

int CnrNode_IsDay()
{
    // Read off the clock instead of asking GetIsDay and GetIsNight. Those two
    // are not opposites: the engine keeps the dawn hour and the dusk hour to
    // themselves, so at 06:xx and at 18:xx neither answers TRUE and both the
    // day plant and the night plant refused to be picked. Two dead hours out
    // of twenty-four. Splitting the clock in two leaves none.
    int nHour = GetTimeHour();
    return nHour >= CNR_NODE_DAWN && nHour < CNR_NODE_DUSK;
}

int CnrNode_SeesInvisible(object oPC)
{
    // Walked by hand rather than asking for a spell by name: what matters is
    // that the effect is on the character, not where it came from.
    effect eCheck = GetFirstEffect(oPC);
    while (GetIsEffectValid(eCheck))
    {
        int nType = GetEffectType(eCheck);
        if (nType == EFFECT_TYPE_SEEINVISIBLE || nType == EFFECT_TYPE_TRUESEEING)
        {
            return TRUE;
        }
        eCheck = GetNextEffect(oPC);
    }
    return FALSE;
}

void CnrNode_Strike(object oPC, object oNode)
{
    string sFamily = GetLocalString(oNode, CNR_NODE_FAMILY);
    if (sFamily == "")
    {
        return;
    }

    // One answer every ten seconds, whoever is hitting and however fast.
    if (GetLocalInt(oNode, CNR_NODE_BUSY))
    {
        return;
    }
    SetLocalInt(oNode, CNR_NODE_BUSY, TRUE);
    DelayCommand(CNR_NODE_COOLDOWN, DeleteLocalInt(oNode, CNR_NODE_BUSY));

    if (GetLocalInt(oNode, CNR_NODE_SPENT))
    {
        SendMessageToPC(oPC, CnrNode_SpentText(sFamily));
        return;
    }

    object oTool = CnrNode_Tool(oPC, sFamily);
    if (!GetIsObjectValid(oTool))
    {
        if (sFamily == "arbol")
        {
            SendMessageToPC(oPC, "Necesitas un hacha de lenador en la mano.");
        }
        else if (sFamily == "planta")
        {
            SendMessageToPC(oPC, "Necesitas un cuchillo o una hoz de "
                + "recoleccion en la mano.");
        }
        else if (sFamily == "gema")
        {
            SendMessageToPC(oPC, "Necesitas un pico de gemas en la mano.");
        }
        else
        {
            SendMessageToPC(oPC, "Necesitas un pico o un mazo de minero en la "
                + "mano.");
        }
        return;
    }

    // Three plants only give at their moment.
    string sCond = GetLocalString(oNode, CNR_NODE_COND);
    if (sCond == "dia" && !CnrNode_IsDay())
    {
        SendMessageToPC(oPC, "Esta planta solo se recoge de dia.");
        return;
    }
    if (sCond == "noche" && CnrNode_IsDay())
    {
        SendMessageToPC(oPC, "Esta planta solo se recoge de noche.");
        return;
    }
    if (sCond == "verinvisible" && !CnrNode_SeesInvisible(oPC))
    {
        SendMessageToPC(oPC, "No ves lo que crece aqui. Necesitas ver lo "
            + "invisible.");
        return;
    }

    int nTier = GetLocalInt(oNode, CNR_NODE_TIER);
    if (nTier < 1) { nTier = 1; }

    // A node that has never been worked charges itself on the first strike.
    int nLeft = GetLocalInt(oNode, CNR_NODE_LEFT);
    if (nLeft <= 0)
    {
        nLeft = CnrNode_Yield(nTier);
        SetLocalInt(oNode, CNR_NODE_LEFT, nLeft);
    }

    // The gem is rolled here, before the ability check, so every strike the
    // vein answers has a chance at one whether or not it shook a nugget loose.
    // The old system turned a spent mineral vein into a gem vein, which is
    // where most stones used to come from; that is gone, and the map holds
    // fifteen mineral veins against eight of gems, so the mineral has to pay
    // for it. The ten second cooldown still gates this, so attacks per round
    // buy nothing.
    if (sFamily == "veta")
    {
        int nGemChance = (nTier >= 4) ? CNR_NODE_GEM_CHANCE_T4
                                      : CNR_NODE_GEM_CHANCE;
        if (Random(100) < nGemChance)
        {
            string sGem = CnrNode_RandomGem(nTier);
            if (sGem != "")
            {
                CreateItemOnObject(sGem, oPC, 1);
            }
        }
    }

    // The roll uses the base ability, so an item that raises it does not help:
    // this is about the arms, not the gear.
    int nRoll  = d20();
    int nScore = GetAbilityScore(oPC, CnrNode_Ability(sFamily), TRUE);
    int nMod   = CnrNode_FloorDivide(nScore - 10, 2);

    if (nRoll + nMod < CnrNode_DC(nTier))
    {
        // A miss costs nothing: not the node, not the tool.
        return;
    }

    string sMaterial = GetLocalString(oNode, CNR_NODE_MATERIAL);
    if (sMaterial == "")
    {
        return;
    }

    // A gem vein states several, separated by ';', and gives one of them.
    int nSep = FindSubString(sMaterial, ";");
    if (nSep >= 0)
    {
        int nCount = 1;
        string sRest = sMaterial;
        while (FindSubString(sRest, ";") >= 0)
        {
            nCount++;
            int nCut = FindSubString(sRest, ";");
            sRest = GetStringRight(sRest, GetStringLength(sRest) - nCut - 1);
        }

        int nPick = Random(nCount);
        sRest = sMaterial;
        int i;
        for (i = 0; i < nPick; i++)
        {
            int nCut = FindSubString(sRest, ";");
            sRest = GetStringRight(sRest, GetStringLength(sRest) - nCut - 1);
        }
        int nEnd = FindSubString(sRest, ";");
        sMaterial = (nEnd < 0) ? sRest : GetStringLeft(sRest, nEnd);
    }

    int nAmount = CnrNode_Amount(sFamily, nTier);
    if (!GetIsObjectValid(CreateItemOnObject(sMaterial, oPC, nAmount)))
    {
        SendMessageToPC(oPC, "No te cabe nada más.");
        return;
    }

    // A mineral vein gives coal on top of the nugget it just handed over.
    if (sFamily == "veta")
    {
        if (Random(100) < CNR_NODE_COAL_CHANCE)
        {
            CreateItemOnObject("pepitacarbon", oPC, 1);
        }
    }

    // The node and the tool are only spent when something came out of them.
    nLeft--;
    SetLocalInt(oNode, CNR_NODE_LEFT, nLeft);
    if (nLeft <= 0)
    {
        SetLocalInt(oNode, CNR_NODE_SPENT, TRUE);
        SendMessageToPC(oPC, CnrNode_SpentText(sFamily));
        DelayCommand(CNR_NODE_REFILL, CnrNode_Refill(oNode));
    }

    int nUses = GetLocalInt(oTool, CNR_NODE_TOOL_USES);
    if (nUses <= 0)
    {
        // Stamped the first time the tool is used, not when it is bought, so
        // an old tool lying in a chest still works.
        string sTag = GetTag(oTool);
        nUses = (sTag == "hozrecolector" || sTag == "carp_hlp"
                 || sTag == "picodegemas") ? 80 : 40;
    }

    nUses -= (nTier >= 4) ? 3 : ((nTier == 3) ? 2 : 1);

    if (nUses <= 0)
    {
        SendMessageToPC(oPC, "Tu herramienta se ha roto.");
        DestroyObject(oTool);
    }
    else
    {
        SetLocalInt(oTool, CNR_NODE_TOOL_USES, nUses);
    }
}
