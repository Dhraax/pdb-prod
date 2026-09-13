/// ----------------------------------------------------------------------------
/// @system  CNR Arcane
/// @file    cnr_arc_nui
/// @author  Dhraax
/// @brief   The arcane table's window.
///
///          This file only draws and collects what the player picks.
///          Everything it needs to know - which item is inside, which
///          properties that item admits, what material is missing - it asks
///          cnr_i_arcane, which does not know this window exists.
///
///          The choice is made in three steps, family then property then
///          power, and not in one list of a hundred and twenty entries with
///          headers mixed in. Two reasons, and the second is the important
///          one: a hundred and twenty lines is not a list anybody reads, and
///          the header rows had to share the value 0 with each other, which is
///          what a combo uses to tell its entries apart. Now every entry in
///          every dropdown carries its own value and no list is longer than
///          one family.
///
///          Nothing that leaves here is trusted: the applier checks it all
///          again. A window is driven by the client.
/// modified by: Dhraax
/// ----------------------------------------------------------------------------

#include "nw_inc_nui"
#include "cnr_i_arcane"
#include "cnr_i_craft"

// -----------------------------------------------------------------------------
//                                  Constants
// -----------------------------------------------------------------------------

const string CNR_ARCN_WINDOW = "cnr_arcane";
const string CNR_ARCN_EVENTS = "cnr_arc_evt";

/// Window binds.
const string CNR_ARCN_B_TARGET   = "target";     ///< what is in the table
const string CNR_ARCN_B_FAMS     = "fams";       ///< family list
const string CNR_ARCN_B_FAM_SEL  = "fam_sel";    ///< chosen family
const string CNR_ARCN_B_PROPS    = "props";      ///< property list
const string CNR_ARCN_B_PROP_SEL = "prop_sel";   ///< chosen property
const string CNR_ARCN_B_STEPS    = "steps";      ///< power list
const string CNR_ARCN_B_STEP_SEL = "step_sel";   ///< chosen power
/// What the two edit boxes accept. The applier caps them again: this one is a
/// courtesy to the player, not a check on him.
const int CNR_ARCN_NAME_MAX = 60;
const int CNR_ARCN_DESC_MAX = 900;

const string CNR_ARCN_B_GAIN     = "gain";       ///< xp and tier, one line
const string CNR_ARCN_B_NAME     = "item_name";  ///< typed by the player
const string CNR_ARCN_B_DESC     = "item_desc";  ///< typed by the player
const string CNR_ARCN_B_STATUS   = "status";     ///< warning line
const string CNR_ARCN_B_ALL      = "show_all";   ///< see above your level
const string CNR_ARCN_B_LEVEL    = "level";      ///< your arcane level

/// Cost box: one label and one colour per line, so a missing pile is red
/// before the player counts anything.
const string CNR_ARCN_B_ESS_NAME = "ess_name";
const string CNR_ARCN_B_ESS_HAVE = "ess_have";
const string CNR_ARCN_B_ESS_COL  = "ess_col";
const string CNR_ARCN_B_CRY_NAME = "cry_name";
const string CNR_ARCN_B_CRY_HAVE = "cry_have";
const string CNR_ARCN_B_CRY_COL  = "cry_col";
const string CNR_ARCN_B_ODDS     = "odds";
const string CNR_ARCN_B_ODDS_COL = "odds_col";
const string CNR_ARCN_B_CAN      = "can_enchant";  ///< enables the button

/// Per-player state while the window is open. It lives on the PC and never on
/// the placeable: the table is shared and each crafter carries their own.
const string CNR_ARCN_V_TABLE   = "CNR_ARC_TABLE";
const string CNR_ARCN_V_FAM     = "CNR_ARC_FAM";      ///< chosen family, 1..N
const string CNR_ARCN_V_FAMNAME = "CNR_ARC_FAMNAME";  ///< and its name
const string CNR_ARCN_V_FAMROW  = "CNR_ARC_FAMROW_";  ///< name of family i
const string CNR_ARCN_V_FAMN    = "CNR_ARC_FAMN";     ///< how many of those
const string CNR_ARCN_V_ROWS    = "CNR_ARC_ROWS";     ///< the listing, cached
const string CNR_ARCN_V_PROP    = "CNR_ARC_PROP";     ///< chosen arcane_id
const string CNR_ARCN_V_STEP    = "CNR_ARC_STEP";     ///< chosen essences
const string CNR_ARCN_V_CONFIRM = "CNR_ARC_CONFIRM";  ///< 1 = awaiting the yes
const string CNR_ARCN_V_ALL     = "CNR_ARC_ALL";      ///< 1 = show everything

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

/// @brief Opens the window, or refreshes it when already in front of them.
/// @param oPC The crafter.
/// @param oTable The arcane table.
void CnrArcN_Open(object oPC, object oTable);

/// @brief Re-reads the table and repaints everything that depends on it.
/// @param oPC The crafter.
/// @param oTable The arcane table.
void CnrArcN_Refresh(object oPC, object oTable);

/// @brief Fills the property dropdown with one family's properties.
/// @param oPC The crafter.
/// @param iToken The window token.
/// @param sFamily The family name, as it comes from the listing.
void CnrArcN_DrawProps(object oPC, int iToken, string sFamily);

/// @brief Fills the power dropdown for the chosen property.
/// @param oPC The crafter.
/// @param iToken The window token.
/// @param iArcaneId The chosen property.
void CnrArcN_DrawSteps(object oPC, int iToken, int iArcaneId);

/// @brief Rewrites the right-hand panel and the cost box from the current
///        choice, and decides whether Encantar may be pressed.
/// @param oPC The crafter.
/// @param iToken The window token.
/// @param oTable The arcane table.
void CnrArcN_DrawDetail(object oPC, int iToken, object oTable);

/// @brief Describes what is in the table, or why it will not do.
/// @param oTable The arcane table.
/// @returns A player-facing line.
string CnrArcN_TargetText(object oTable);

/// @brief The label the see-everything button should be showing.
/// @param oPC The crafter.
/// @returns A player-facing label.
string CnrArcN_AllLabel(object oPC);

/// @brief Odds of the roll landing, as a percentage.
/// @param oPC The crafter.
/// @param iDC The property's difficulty.
/// @returns 0 to 100.
int CnrArcN_Odds(object oPC, int iDC);

/// @brief Empties the cost box, for when there is nothing to cost.
/// @param oPC The crafter.
/// @param iToken The window token.
void CnrArcN_ClearCost(object oPC, int iToken);

/// @brief Forgets the property and the power, leaving the family alone.
/// @param oPC The crafter.
/// @param iToken The window token.
void CnrArcN_DropChoice(object oPC, int iToken);

/// @brief Says whether a property is still in the listing on screen.
/// @param oPC The crafter.
/// @param iArcaneId The property to look for.
/// @returns TRUE when the cached listing holds a row for it.
///          The listing is already filtered by base item and by level, so
///          this is what answers whether the choice is still on offer.
int CnrArcN_IsListed(object oPC, int iArcaneId);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

string CnrArcN_TargetText(object oTable)
{
    int iState = CnrArc_TargetState(oTable);
    if (iState == CNR_ARC_TARGET_NONE)
    {
        return "Deja en la mesa una pieza hecha por un oficio";
    }
    if (iState == CNR_ARC_TARGET_MANY)
    {
        return "Hay más de una pieza encantable: deja solo una";
    }
    if (iState == CNR_ARC_TARGET_DONE)
    {
        return "Esa pieza ya está encantada";
    }
    return GetName(CnrArc_GetTarget(oTable));
}

string CnrArcN_AllLabel(object oPC)
{
    return GetLocalInt(oPC, CNR_ARCN_V_ALL) ? "Solo mi nivel" : "Ver todas";
}

int CnrArcN_Odds(object oPC, int iDC)
{
    // The roll is the crafting one: a natural 20 always lands, a natural 1
    // always fails, and everything between is d20 + bonus against the DC.
    int iBonus = CnrCraft_GetRollBonus(oPC, CNR_ARC_PROFESSION);

    int iLow = iDC - iBonus;
    if (iLow < 2)
    {
        iLow = 2;
    }

    int iFaces = (iLow <= 19) ? (19 - iLow + 1) : 0;
    return ((iFaces + 1) * 100) / 20;
}

void CnrArcN_ClearCost(object oPC, int iToken)
{
    NuiSetBind(oPC, iToken, CNR_ARCN_B_ESS_NAME, JsonString(""));
    NuiSetBind(oPC, iToken, CNR_ARCN_B_ESS_HAVE, JsonString(""));
    NuiSetBind(oPC, iToken, CNR_ARCN_B_CRY_NAME, JsonString(""));
    NuiSetBind(oPC, iToken, CNR_ARCN_B_CRY_HAVE, JsonString(""));
    NuiSetBind(oPC, iToken, CNR_ARCN_B_GAIN, JsonString(""));
    NuiSetBind(oPC, iToken, CNR_ARCN_B_ODDS, JsonString(""));
    NuiSetBind(oPC, iToken, CNR_ARCN_B_CAN, JsonBool(FALSE));
}

void CnrArcN_DropChoice(object oPC, int iToken)
{
    DeleteLocalInt(oPC, CNR_ARCN_V_PROP);
    DeleteLocalInt(oPC, CNR_ARCN_V_STEP);
    DeleteLocalInt(oPC, CNR_ARCN_V_CONFIRM);
    NuiSetBind(oPC, iToken, CNR_ARCN_B_PROP_SEL, JsonInt(0));
    NuiSetBind(oPC, iToken, CNR_ARCN_B_STEP_SEL, JsonInt(0));
    NuiSetBind(oPC, iToken, CNR_ARCN_B_STEPS, JsonArray());
}

int CnrArcN_IsListed(object oPC, int iArcaneId)
{
    if (iArcaneId <= 0)
    {
        return FALSE;
    }

    string sRest = GetLocalString(oPC, CNR_ARCN_V_ROWS);
    while (sRest != "")
    {
        int iEnd = FindSubString(sRest, CNR_ARC_SEP_ROW);
        if (iEnd < 0)
        {
            break;
        }
        string sRow = GetStringLeft(sRest, iEnd);
        sRest = GetStringRight(sRest, GetStringLength(sRest) - iEnd - 1);

        if (StringToInt(CnrArc_Field(sRow, 0)) == iArcaneId)
        {
            return TRUE;
        }
    }
    return FALSE;
}

void CnrArcN_DrawProps(object oPC, int iToken, string sFamily)
{
    json jProps = JsonArray();
    jProps = JsonArrayInsert(jProps,
        NuiComboEntry("-- elige una propiedad --", 0));

    if (sFamily != "")
    {
        string sRest = GetLocalString(oPC, CNR_ARCN_V_ROWS);
        while (sRest != "")
        {
            int iEnd = FindSubString(sRest, CNR_ARC_SEP_ROW);
            if (iEnd < 0)
            {
                break;
            }
            string sRow = GetStringLeft(sRest, iEnd);
            sRest = GetStringRight(sRest, GetStringLength(sRest) - iEnd - 1);

            if (CnrArc_Field(sRow, 1) != sFamily)
            {
                continue;
            }

            int    iId      = StringToInt(CnrArc_Field(sRow, 0));
            string sName    = CnrArc_Field(sRow, 2);
            string sLevel   = CnrArc_Field(sRow, 4);
            int    bReached = StringToInt(CnrArc_Field(sRow, 5));

            // The level only shows on what you cannot do yet, so the common
            // case reads as a clean list of names.
            string sLabel = sName;
            if (!bReached)
            {
                sLabel += "   [nivel " + sLevel + "]";
            }
            jProps = JsonArrayInsert(jProps, NuiComboEntry(sLabel, iId));
        }
    }

    NuiSetBind(oPC, iToken, CNR_ARCN_B_PROPS, jProps);
}

void CnrArcN_DrawSteps(object oPC, int iToken, int iArcaneId)
{
    json jSteps = JsonArray();
    jSteps = JsonArrayInsert(jSteps, NuiComboEntry("-- elige el poder --", 0));

    string sRest = CnrArc_ListSteps(iArcaneId);
    while (sRest != "")
    {
        int iEnd = FindSubString(sRest, CNR_ARC_SEP_ROW);
        if (iEnd < 0)
        {
            break;
        }
        string sRow = GetStringLeft(sRest, iEnd);
        sRest = GetStringRight(sRest, GetStringLength(sRest) - iEnd - 1);

        int    iEssences = StringToInt(CnrArc_Field(sRow, 0));
        string sLabel    = CnrArc_Field(sRow, 1);
        string sStepDC   = CnrArc_Field(sRow, 2);

        // The combo's value is the essence count: it is what the applier
        // needs, and looking the step up by it is the whole validation.
        //
        // The DC rides along in the label because it now climbs with the
        // power: without it the player picks a rung and only then finds out
        // what it costs him to hit.
        jSteps = JsonArrayInsert(jSteps,
            NuiComboEntry(sLabel + "   -   " + IntToString(iEssences)
                          + (iEssences == 1 ? " esencia" : " esencias")
                          + "   -   DC " + sStepDC,
                          iEssences));
    }

    NuiSetBind(oPC, iToken, CNR_ARCN_B_STEPS, jSteps);
    NuiSetBind(oPC, iToken, CNR_ARCN_B_STEP_SEL, JsonInt(0));
    DeleteLocalInt(oPC, CNR_ARCN_V_STEP);
}

void CnrArcN_DrawDetail(object oPC, int iToken, object oTable)
{
    int iProp = GetLocalInt(oPC, CNR_ARCN_V_PROP);
    int iStep = GetLocalInt(oPC, CNR_ARCN_V_STEP);

    if (iProp <= 0)
    {
        CnrArcN_ClearCost(oPC, iToken);
        return;
    }

    string sProperty = CnrArc_ReadProperty(iProp);
    if (sProperty == "")
    {
        CnrArcN_ClearCost(oPC, iToken);
        return;
    }

    // The name, the section and the loot hint went with the panel: the two
    // dropdowns already carry the first two, and the third was never acted on.
    int    iGroup       = StringToInt(CnrArc_Field(sProperty, 2));
    string sTier        = CnrArc_Field(sProperty, 3);
    string sEssence     = CnrArc_Field(sProperty, 4);
    string sCrystal     = CnrArc_Field(sProperty, 5);
    int    iLevel       = StringToInt(CnrArc_Field(sProperty, 8));
    int    iEntryDC     = StringToInt(CnrArc_Field(sProperty, 13));
    string sEssenceName = CnrArc_Field(sProperty, 10);
    string sCrystalName = CnrArc_Field(sProperty, 11);

    // The right-hand panel is gone: it is where the player names his piece now.
    // Everything it used to say is either on the left or in a dropdown - the
    // step's label carries the value and its DC, the property list flags the
    // levels out of reach, and the cost box has the materials and the odds.
    // What had nowhere else to go is the experience and the tier, and that is
    // the one line below.
    string sStep = (iStep > 0) ? CnrArc_ReadStep(iProp, iStep) : "";
    int    iDC   = iEntryDC;
    string sGain = "tier " + sTier;

    if (sStep != "")
    {
        iDC   = StringToInt(CnrArc_Field(sStep, 5));
        sGain = CnrArc_Field(sStep, 3) + " xp   -   tier " + sTier;
    }

    NuiSetBind(oPC, iToken, CNR_ARCN_B_GAIN, JsonString(sGain));

    // --- the cost box --------------------------------------------------------
    object oTarget   = CnrArc_GetTarget(oTable);
    int    bTarget   = GetIsObjectValid(oTarget);
    int    iCrystals = bTarget ? CnrArc_CrystalCost(iGroup, GetBaseItemType(oTarget))
                               : 1;

    // A cost of zero is the group table saying this item does not take this
    // property. Read as a number it is always satisfied, so the crystal line
    // would go green on "0 de 0" and the button would light up on a job the
    // applier refuses.
    int bFits = (iCrystals > 0);

    int iHaveEss = CnrArc_CountMaterial(oTable, sEssence);
    int iHaveCry = CnrArc_CountMaterial(oTable, sCrystal);
    int bEssOk   = (iStep > 0 && iHaveEss >= iStep);
    int bCryOk   = (bFits && iHaveCry >= iCrystals);

    json jOk  = NuiColor(120, 230, 120);
    json jBad = NuiColor(230, 110, 110);

    NuiSetBind(oPC, iToken, CNR_ARCN_B_ESS_NAME, JsonString(sEssenceName));
    NuiSetBind(oPC, iToken, CNR_ARCN_B_ESS_HAVE,
        JsonString(IntToString(iHaveEss) + " de "
                   + (iStep > 0 ? IntToString(iStep) : "?")));
    NuiSetBind(oPC, iToken, CNR_ARCN_B_ESS_COL, bEssOk ? jOk : jBad);

    NuiSetBind(oPC, iToken, CNR_ARCN_B_CRY_NAME, JsonString(sCrystalName));
    NuiSetBind(oPC, iToken, CNR_ARCN_B_CRY_HAVE,
        JsonString(bFits
                   ? IntToString(iHaveCry) + " de " + IntToString(iCrystals)
                   : "no aplica"));
    NuiSetBind(oPC, iToken, CNR_ARCN_B_CRY_COL, bCryOk ? jOk : jBad);

    // --- odds and the button -------------------------------------------------
    int bLevelOk = (CnrArc_GetLevel(oPC) >= iLevel);
    if (!bLevelOk)
    {
        NuiSetBind(oPC, iToken, CNR_ARCN_B_ODDS,
                   JsonString("te falta nivel"));
        NuiSetBind(oPC, iToken, CNR_ARCN_B_ODDS_COL, jBad);
    }
    else if (sStep == "")
    {
        // Every rung of the ladder has its own DC, so there is no percentage
        // to give until the player says how much power he wants.
        NuiSetBind(oPC, iToken, CNR_ARCN_B_ODDS, JsonString("elige el poder"));
        NuiSetBind(oPC, iToken, CNR_ARCN_B_ODDS_COL, NuiColor(190, 190, 190));
    }
    else
    {
        int iOdds = CnrArcN_Odds(oPC, iDC);
        NuiSetBind(oPC, iToken, CNR_ARCN_B_ODDS,
                   JsonString(IntToString(iOdds) + "%"));
        NuiSetBind(oPC, iToken, CNR_ARCN_B_ODDS_COL,
                   (iOdds >= 50) ? jOk : NuiColor(235, 200, 110));
    }

    // Greying the button out is a courtesy, not a guard: the applier decides.
    NuiSetBind(oPC, iToken, CNR_ARCN_B_CAN,
               JsonBool(bTarget && bLevelOk && iStep > 0 && bEssOk && bCryOk));
}

void CnrArcN_Refresh(object oPC, object oTable)
{
    int iToken = NuiFindWindow(oPC, CNR_ARCN_WINDOW);
    if (iToken == 0)
    {
        return;
    }

    NuiSetBind(oPC, iToken, CNR_ARCN_B_TARGET,
               JsonString(CnrArcN_TargetText(oTable)));
    NuiSetBind(oPC, iToken, CNR_ARCN_B_LEVEL,
               JsonString("Arcano " + IntToString(CnrArc_GetLevel(oPC))));
    NuiSetBind(oPC, iToken, CNR_ARCN_B_ALL,
               JsonString(CnrArcN_AllLabel(oPC)));

    object oTarget = CnrArc_GetTarget(oTable);
    string sRows   = "";

    if (GetIsObjectValid(oTarget))
    {
        sRows = CnrArc_ListProperties(oPC, GetBaseItemType(oTarget),
                                      GetLocalInt(oPC, CNR_ARCN_V_ALL));
    }

    // Kept whole on the player so that changing family does not go back to the
    // database: the listing is one query per refresh and nothing more.
    SetLocalString(oPC, CNR_ARCN_V_ROWS, sRows);

    // --- families, in the order the query returned them -----------------------
    string sWanted = GetLocalString(oPC, CNR_ARCN_V_FAMNAME);
    string sLast   = "";
    int    iCount  = 0;
    int    iWanted = 0;

    json jFams = JsonArray();
    jFams = JsonArrayInsert(jFams, NuiComboEntry("-- elige una familia --", 0));

    string sRest = sRows;
    while (sRest != "")
    {
        int iEnd = FindSubString(sRest, CNR_ARC_SEP_ROW);
        if (iEnd < 0)
        {
            break;
        }
        string sRow = GetStringLeft(sRest, iEnd);
        sRest = GetStringRight(sRest, GetStringLength(sRest) - iEnd - 1);

        string sSection = CnrArc_Field(sRow, 1);
        if (sSection == sLast)
        {
            continue;
        }
        sLast = sSection;
        iCount++;

        SetLocalString(oPC, CNR_ARCN_V_FAMROW + IntToString(iCount), sSection);
        jFams = JsonArrayInsert(jFams, NuiComboEntry(sSection, iCount));

        if (sSection == sWanted)
        {
            iWanted = iCount;
        }
    }

    // A shorter listing than the last one leaves numbered names behind, and
    // locals on a PC are saved with the character.
    int iWas = GetLocalInt(oPC, CNR_ARCN_V_FAMN);
    int i;
    for (i = iCount + 1; i <= iWas; i++)
    {
        DeleteLocalString(oPC, CNR_ARCN_V_FAMROW + IntToString(i));
    }
    SetLocalInt(oPC, CNR_ARCN_V_FAMN, iCount);

    NuiSetBind(oPC, iToken, CNR_ARCN_B_FAMS, jFams);

    // The family survives a refresh when the new item still offers it, and is
    // dropped when it does not, so the dropdown and the panel never tell two
    // different stories.
    SetLocalInt(oPC, CNR_ARCN_V_FAM, iWanted);
    NuiSetBind(oPC, iToken, CNR_ARCN_B_FAM_SEL, JsonInt(iWanted));

    if (iWanted == 0)
    {
        DeleteLocalString(oPC, CNR_ARCN_V_FAMNAME);
        CnrArcN_DrawProps(oPC, iToken, "");
        CnrArcN_DropChoice(oPC, iToken);
    }
    else
    {
        CnrArcN_DrawProps(oPC, iToken, sWanted);

        // The property may have gone with the change of item or of filter.
        // The listing is what knows: the property table only says the row
        // exists, and one that exists but is no longer offered leaves the
        // combo blank while the panel keeps describing it.
        if (!CnrArcN_IsListed(oPC, GetLocalInt(oPC, CNR_ARCN_V_PROP)))
        {
            CnrArcN_DropChoice(oPC, iToken);
        }
    }

    DeleteLocalInt(oPC, CNR_ARCN_V_CONFIRM);
    CnrArcN_DrawDetail(oPC, iToken, oTable);
}

void CnrArcN_Open(object oPC, object oTable)
{
    SetLocalObject(oPC, CNR_ARCN_V_TABLE, oTable);

    int iToken = NuiFindWindow(oPC, CNR_ARCN_WINDOW);
    if (iToken != 0)
    {
        CnrArcN_Refresh(oPC, oTable);
        return;
    }

    json jDim = NuiColor(190, 190, 190);   ///< captions, quieter than values

    // --- header: what is on the table, and who is working ---------------------
    json jHead = JsonArray();
    jHead = JsonArrayInsert(jHead, NuiWidth(
        NuiStyleForegroundColor(
            NuiLabel(JsonString("En la mesa:"), JsonInt(NUI_HALIGN_LEFT),
                     JsonInt(NUI_VALIGN_MIDDLE)), jDim), 78.0f));
    jHead = JsonArrayInsert(jHead,
        NuiId(NuiLabel(NuiBind(CNR_ARCN_B_TARGET), JsonInt(NUI_HALIGN_LEFT),
                       JsonInt(NUI_VALIGN_MIDDLE)), "lbl_target"));
    jHead = JsonArrayInsert(jHead, NuiWidth(
        NuiId(NuiLabel(NuiBind(CNR_ARCN_B_LEVEL), JsonInt(NUI_HALIGN_RIGHT),
                       JsonInt(NUI_VALIGN_MIDDLE)), "lbl_level"), 100.0f));

    // --- left column: the choices --------------------------------------------
    json jLeft = JsonArray();

    jLeft = JsonArrayInsert(jLeft, NuiHeight(
        NuiStyleForegroundColor(
            NuiLabel(JsonString("1.  Familia"), JsonInt(NUI_HALIGN_LEFT),
                     JsonInt(NUI_VALIGN_BOTTOM)), jDim), 20.0f));
    jLeft = JsonArrayInsert(jLeft, NuiHeight(
        NuiId(NuiCombo(NuiBind(CNR_ARCN_B_FAMS), NuiBind(CNR_ARCN_B_FAM_SEL)),
              "cmb_family"), 28.0f));

    jLeft = JsonArrayInsert(jLeft, NuiHeight(
        NuiStyleForegroundColor(
            NuiLabel(JsonString("2.  Propiedad"), JsonInt(NUI_HALIGN_LEFT),
                     JsonInt(NUI_VALIGN_BOTTOM)), jDim), 22.0f));
    jLeft = JsonArrayInsert(jLeft, NuiHeight(
        NuiId(NuiCombo(NuiBind(CNR_ARCN_B_PROPS), NuiBind(CNR_ARCN_B_PROP_SEL)),
              "cmb_prop"), 28.0f));

    jLeft = JsonArrayInsert(jLeft, NuiHeight(
        NuiStyleForegroundColor(
            NuiLabel(JsonString("3.  Poder"), JsonInt(NUI_HALIGN_LEFT),
                     JsonInt(NUI_VALIGN_BOTTOM)), jDim), 22.0f));
    jLeft = JsonArrayInsert(jLeft, NuiHeight(
        NuiId(NuiCombo(NuiBind(CNR_ARCN_B_STEPS), NuiBind(CNR_ARCN_B_STEP_SEL)),
              "cmb_step"), 28.0f));

    // --- the cost box: three lines, caption left, value right ----------------
    json jCost = JsonArray();

    json jEssRow = JsonArray();
    jEssRow = JsonArrayInsert(jEssRow,
        NuiId(NuiLabel(NuiBind(CNR_ARCN_B_ESS_NAME), JsonInt(NUI_HALIGN_LEFT),
                       JsonInt(NUI_VALIGN_MIDDLE)), "lbl_ess"));
    jEssRow = JsonArrayInsert(jEssRow, NuiWidth(
        NuiStyleForegroundColor(
            NuiLabel(NuiBind(CNR_ARCN_B_ESS_HAVE), JsonInt(NUI_HALIGN_RIGHT),
                     JsonInt(NUI_VALIGN_MIDDLE)),
            NuiBind(CNR_ARCN_B_ESS_COL)), 92.0f));
    jCost = JsonArrayInsert(jCost, NuiHeight(NuiRow(jEssRow), 20.0f));

    json jCryRow = JsonArray();
    jCryRow = JsonArrayInsert(jCryRow,
        NuiId(NuiLabel(NuiBind(CNR_ARCN_B_CRY_NAME), JsonInt(NUI_HALIGN_LEFT),
                       JsonInt(NUI_VALIGN_MIDDLE)), "lbl_cry"));
    jCryRow = JsonArrayInsert(jCryRow, NuiWidth(
        NuiStyleForegroundColor(
            NuiLabel(NuiBind(CNR_ARCN_B_CRY_HAVE), JsonInt(NUI_HALIGN_RIGHT),
                     JsonInt(NUI_VALIGN_MIDDLE)),
            NuiBind(CNR_ARCN_B_CRY_COL)), 92.0f));
    jCost = JsonArrayInsert(jCost, NuiHeight(NuiRow(jCryRow), 20.0f));

    json jOddsRow = JsonArray();
    jOddsRow = JsonArrayInsert(jOddsRow,
        NuiStyleForegroundColor(
            NuiLabel(JsonString("Probabilidad de éxito"),
                     JsonInt(NUI_HALIGN_LEFT), JsonInt(NUI_VALIGN_MIDDLE)),
            jDim));
    jOddsRow = JsonArrayInsert(jOddsRow, NuiWidth(
        NuiStyleForegroundColor(
            NuiLabel(NuiBind(CNR_ARCN_B_ODDS), JsonInt(NUI_HALIGN_RIGHT),
                     JsonInt(NUI_VALIGN_MIDDLE)),
            NuiBind(CNR_ARCN_B_ODDS_COL)), 150.0f));
    jCost = JsonArrayInsert(jCost, NuiHeight(NuiRow(jOddsRow), 20.0f));

    // Experience and tier, the only two facts the retired panel held that are
    // nowhere else on the window.
    json jGainRow = JsonArray();
    jGainRow = JsonArrayInsert(jGainRow,
        NuiStyleForegroundColor(
            NuiLabel(JsonString("Experiencia"), JsonInt(NUI_HALIGN_LEFT),
                     JsonInt(NUI_VALIGN_MIDDLE)), jDim));
    jGainRow = JsonArrayInsert(jGainRow, NuiWidth(
        NuiStyleForegroundColor(
            NuiLabel(NuiBind(CNR_ARCN_B_GAIN), JsonInt(NUI_HALIGN_RIGHT),
                     JsonInt(NUI_VALIGN_MIDDLE)), jDim), 150.0f));
    jCost = JsonArrayInsert(jCost, NuiHeight(NuiRow(jGainRow), 20.0f));

    jLeft = JsonArrayInsert(jLeft, NuiHeight(
        NuiGroup(NuiCol(jCost), TRUE, NUI_SCROLLBARS_NONE), 104.0f));

    // The warning line, with a height of its own. Left to grow it ate into the
    // buttons underneath.
    jLeft = JsonArrayInsert(jLeft, NuiHeight(
        NuiId(NuiText(NuiBind(CNR_ARCN_B_STATUS)), "txt_status"), 96.0f));

    // Whatever room is left over goes here and not into the widgets.
    jLeft = JsonArrayInsert(jLeft, NuiSpacer());

    json jRowButtons = JsonArray();
    jRowButtons = JsonArrayInsert(jRowButtons,
        NuiTooltip(
            NuiEnabled(NuiId(NuiButton(JsonString("Encantar")), "btn_enchant"),
                       NuiBind(CNR_ARCN_B_CAN)),
            JsonString("Se activa cuando la pieza, el material y tu nivel "
                       + "están en orden.")));
    jRowButtons = JsonArrayInsert(jRowButtons, NuiWidth(
        NuiId(NuiButton(NuiBind(CNR_ARCN_B_ALL)), "btn_all"), 106.0f));
    jRowButtons = JsonArrayInsert(jRowButtons, NuiWidth(
        NuiId(NuiButton(JsonString("Cerrar")), "btn_close"), 86.0f));
    jLeft = JsonArrayInsert(jLeft, NuiHeight(NuiRow(jRowButtons), 32.0f));

    // --- right column: what the piece will be called --------------------------
    // Both are optional. Left empty the piece keeps the name and the
    // description it already has, and still gains the marker and the signature.
    json jRight = JsonArray();

    jRight = JsonArrayInsert(jRight, NuiHeight(
        NuiStyleForegroundColor(
            NuiLabel(JsonString("Nombre de la pieza"), JsonInt(NUI_HALIGN_LEFT),
                     JsonInt(NUI_VALIGN_BOTTOM)), jDim), 20.0f));
    jRight = JsonArrayInsert(jRight, NuiHeight(
        NuiId(NuiTextEdit(JsonString("Lo que ya trae, si lo dejas vacio"),
                          NuiBind(CNR_ARCN_B_NAME),
                          CNR_ARCN_NAME_MAX, FALSE), "txt_name"), 28.0f));

    jRight = JsonArrayInsert(jRight, NuiHeight(
        NuiStyleForegroundColor(
            NuiLabel(JsonString("Descripcion"), JsonInt(NUI_HALIGN_LEFT),
                     JsonInt(NUI_VALIGN_BOTTOM)), jDim), 24.0f));
    jRight = JsonArrayInsert(jRight,
        NuiId(NuiTextEdit(JsonString("La historia de la pieza"),
                          NuiBind(CNR_ARCN_B_DESC),
                          CNR_ARCN_DESC_MAX, TRUE), "txt_desc"));

    json jBody = JsonArray();
    jBody = JsonArrayInsert(jBody, NuiWidth(NuiCol(jLeft), 350.0f));
    jBody = JsonArrayInsert(jBody,
        NuiGroup(NuiCol(jRight), TRUE, NUI_SCROLLBARS_AUTO));

    json jRoot = JsonArray();
    jRoot = JsonArrayInsert(jRoot, NuiHeight(
        NuiGroup(NuiRow(jHead), TRUE, NUI_SCROLLBARS_NONE), 38.0f));
    jRoot = JsonArrayInsert(jRoot, NuiRow(jBody));

    json jWindow = NuiWindow(
        NuiCol(jRoot),
        JsonString("Mesa de artesanía urdímbrica"),
        NuiRect(-1.0f, -1.0f, 780.0f, 520.0f),
        JsonBool(TRUE),    // resizable
        JsonBool(FALSE),   // collapsed
        JsonBool(TRUE),    // closable
        JsonBool(FALSE),   // transparent
        JsonBool(TRUE));   // border

    iToken = NuiCreate(oPC, jWindow, CNR_ARCN_WINDOW, CNR_ARCN_EVENTS);

    NuiSetBindWatch(oPC, iToken, CNR_ARCN_B_FAM_SEL, TRUE);
    NuiSetBindWatch(oPC, iToken, CNR_ARCN_B_PROP_SEL, TRUE);
    NuiSetBindWatch(oPC, iToken, CNR_ARCN_B_STEP_SEL, TRUE);

    NuiSetBind(oPC, iToken, CNR_ARCN_B_FAM_SEL, JsonInt(0));
    NuiSetBind(oPC, iToken, CNR_ARCN_B_PROP_SEL, JsonInt(0));
    NuiSetBind(oPC, iToken, CNR_ARCN_B_STEP_SEL, JsonInt(0));
    NuiSetBind(oPC, iToken, CNR_ARCN_B_ALL, JsonString(CnrArcN_AllLabel(oPC)));
    NuiSetBind(oPC, iToken, CNR_ARCN_B_NAME, JsonString(""));
    NuiSetBind(oPC, iToken, CNR_ARCN_B_DESC, JsonString(""));
    NuiSetBind(oPC, iToken, CNR_ARCN_B_STATUS, JsonString(""));
    NuiSetBind(oPC, iToken, CNR_ARCN_B_CAN, JsonBool(FALSE));

    CnrArcN_Refresh(oPC, oTable);
}
