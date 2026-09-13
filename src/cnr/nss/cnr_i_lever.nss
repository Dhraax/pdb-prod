/// ----------------------------------------------------------------------------
/// @system  CNR Crafting
/// @file    cnr_i_lever
/// @author  Dhraax
/// @brief   The test levers that move a trade one level up or down.
///
///          Which trade each lever moves is read from its own name, "Lever:
///          Herreria" and so on, exactly as the original did: the seven
///          placeables differ in nothing else, so there is nothing to keep in
///          step between the map and the code.
///
///          These are a testing tool. Nothing here belongs in production.
/// ----------------------------------------------------------------------------

#include "cnr_recipe_utils"

/// Custom token the lever's conversation prints. 22401 is free; CNR uses
/// 22000-22399 and the extractor took 22400.
const int CNR_LEVER_TOKEN = 22401;

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

/// @brief The trade a lever moves, taken from its name.
/// @param oLever The lever placeable.
/// @returns A CNR_TRADESKILL_* value, or 0 when the name says nothing.
int CnrLever_Trade(object oLever);

/// @brief The trade's name, for what the player reads.
/// @param oLever The lever placeable.
/// @returns The name without the "Lever: " prefix.
string CnrLever_TradeName(object oLever);

/// @brief Moves a trade one level, up or down.
/// @param oPC Whose trade moves.
/// @param oLever The lever, which says which trade.
/// @param nDelta +1 or -1.
void CnrLever_Move(object oPC, object oLever, int nDelta);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

string CnrLever_TradeName(object oLever)
{
    string sName = GetName(oLever);
    return GetStringRight(sName, GetStringLength(sName) - 7);
}

int CnrLever_Trade(object oLever)
{
    string sTrade = CnrLever_TradeName(oLever);

    if (sTrade == "Herreria")    { return CNR_TRADESKILL_SMITHING; }
    if (sTrade == "Carpinteria") { return CNR_TRADESKILL_CARPENTRY; }
    if (sTrade == "Peleteria")   { return CNR_TRADESKILL_TAILORING; }
    if (sTrade == "Alquimia")    { return CNR_TRADESKILL_ALCHEMY; }
    if (sTrade == "Joyeria")     { return CNR_TRADESKILL_JEWELRY; }
    if (sTrade == "Arcano")      { return CNR_TRADESKILL_ARCANE; }
    if (sTrade == "Sastreria")   { return CNR_TRADESKILL_SEWING; }

    return 0;
}

void CnrLever_Move(object oPC, object oLever, int nDelta)
{
    int nTrade = CnrLever_Trade(oLever);
    if (nTrade <= 0 || !GetIsObjectValid(oPC))
    {
        return;
    }

    string sTrade = CnrLever_TradeName(oLever);
    int nLevel = CnrDetermineTradeskillLevel(
        CnrGetTradeskillXPByType(oPC, nTrade));
    int nWanted = nLevel + nDelta;

    if (nWanted > 20)
    {
        FloatingTextStringOnCreature(
            "Ya tienes el nivel máximo (20) en " + sTrade + ".", oPC, FALSE);
        return;
    }
    if (nWanted < 1)
    {
        FloatingTextStringOnCreature(
            "Ya estás en el nivel mínimo (1) en " + sTrade + ".", oPC, FALSE);
        return;
    }

    // The curve lives on the module, put there when the catalogue loads, so
    // the level is set by writing the experience its first point asks for.
    int nXP = GetLocalInt(GetModule(),
                          "CnrTradeXPLevel" + IntToString(nWanted));

    if (!CnrSkill_SetXP(oPC, nTrade, nXP))
    {
        FloatingTextStringOnCreature(
            "No se ha podido guardar el nivel. Avisa a un DM.", oPC, FALSE);
        return;
    }

    FloatingTextStringOnCreature(
        "Tu oficio de " + sTrade + " es ahora nivel " + IntToString(nWanted)
        + ".", oPC, FALSE);
}
