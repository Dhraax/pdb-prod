/// ----------------------------------------------------------------------------
/// @system  CNR Crafting
/// @file    cnr_i_craft
/// @author  Dhraax
/// @brief   Database-driven crafting: stations, categories, recipes and rolls.
/// modified by: Dhraax
/// ----------------------------------------------------------------------------

#include "cnr_i_stack"
#include "nwnx_sql"
#include "pwdb_i_user"
#include "cnr_i_skill"
#include "cnr_i_setting"
#include "cnr_i_prop"
#include "cnr_i_product"
#include "colors_inc"

// Page size for the browsing menus.
const int CNR_PAGE_SIZE = 5;

// Difficulty model. Single place to tune; nothing is copied into recipes.
const int CNR_LEVEL_CAP            = 20;
const int CNR_CRAFT_RANKS_PER_BONUS = 5;   // +1 per N ranks of base Craft
const int CNR_XP_FAILURE_PERCENT   = 12;   // failure pays this share

// Navigation state, cached on the PC for the duration of the menu.
const string CNR_VAR_STATION   = "CNR_STATION_ID";
const string CNR_VAR_SKILL     = "CNR_SKILL_INDEX";
const string CNR_VAR_CATEGORY  = "CNR_CATEGORY_ID";
const string CNR_VAR_PAGE      = "CNR_PAGE";
/// Recipe-list page to restore after detail or variant selection.
const string CNR_VAR_RECIPE_PAGE = "CNR_RECIPE_PAGE";
const string CNR_VAR_RECIPE    = "CNR_RECIPE_ID";
/// Which product of the recipe's group the crafter picked. A recipe without a
/// group ignores this: it makes what its own row says.
const string CNR_VAR_VARIANT   = "CNR_VARIANT_ID";
/// The group the open recipe offers, empty when it offers nothing.
const string CNR_VAR_VGROUP    = "CNR_VARIANT_GROUP";
const string CNR_VAR_COUNT     = "CNR_LIST_COUNT";
const string CNR_VAR_ITEM      = "CNR_LIST_";      // + index
const string CNR_VAR_PARENT    = "CNR_PARENT_ID";
/// Which list the menu is showing, and the only thing that says so.
///
/// It replaces two overlapping booleans. The variant screen is reached from
/// the recipe list, so a "browsing recipes" flag stayed true while it was up:
/// paging reloaded recipes over the variant slots, and picking one then stored
/// a recipe id as if it were a variant. A second flag was needed on top to say
/// "no list at all", because the category screen otherwise claimed every turn
/// nothing else wanted.
///
/// Whatever builds a list owns this value: that is the only place where the
/// kind is known for certain.
const string CNR_VAR_LISTMODE  = "CNR_LIST_MODE";
const int CNR_LIST_NONE       = 0;   // no list: the action menu
const int CNR_LIST_CATEGORIES = 1;
const int CNR_LIST_RECIPES    = 2;
const int CNR_LIST_VARIANTS   = 3;
const string CNR_VAR_PLACEABLE = "CNR_PLACEABLE";
const string CNR_VAR_TYPED_ID  = "CNR_TYPED_ID";
const string CNR_VAR_HAYMAS    = "CNR_HAY_MAS";   // la pagina actual no es la ultima
const string CNR_VAR_ACTIVE    = "CNR_CRAFT_ACTIVE";

// Set on an item that already holds a gem. A marked item is invisible to every
// recipe: a stone is set once, and a set piece is never raw material again.
const string CNR_VAR_ENGARZADO = "CNR_ENGARZADO";

// Stamped on a crafted piece with the profession that made it, so a later
// enchanting table can tell one from anything else. Potions and materials do
// not carry it, and neither does a ring band or a cut gem: another recipe
// eats those, which makes them material whatever bench they came off.
const string CNR_VAR_OFICIO = "CNR_OFICIO";

// CnrCraft_GetRollBonus leaves its two halves here so the roll message can
// show where the number came from instead of one opaque total.
const string CNR_VAR_ROLL_LEVEL = "CNR_ROLL_LEVEL";
const string CNR_VAR_ROLL_HELP  = "CNR_ROLL_HELP";

// Conversation tokens.
const int CNR_TOKEN_SLOT   = 5000;   // 5000..5004, the five list lines
const int CNR_TOKEN_HEAD1  = 5010;   // station name
const int CNR_TOKEN_HEAD2  = 5011;   // skill rank
const int CNR_TOKEN_DETAIL = 5012;   // recipe detail screen
const int CNR_TOKEN_BUTTON = 5020;   // 5020..5032, one per menu reply

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

/// @brief Resolve the station the PC is using and cache it on them.
/// @param oPC Player using the station.
/// @param oStation The placeable, looked up by its tag.
/// @returns Station id, or 0 when the tag is not registered.
int CnrCraft_OpenStation(object oPC, object oStation);

/// @brief Fill the PC's list cache with the categories under nParent.
/// @param oPC Player browsing.
/// @param nParent Parent category id, 0 for top level.
/// @returns Number of categories found.
int CnrCraft_ListCategories(object oPC, int nParent);

/// @brief Fill the PC's list cache with one page of recipes in a category.
/// @param oPC Player browsing.
/// @param nCategory Category id.
/// @param nPage Zero-based page number.
/// @returns Number of rows on this page.
int CnrCraft_ListRecipes(object oPC, int nCategory, int nPage);

/// @brief Id behind a list line: a category id, or a recipe public id.
/// @param oPC Player browsing.
/// @param nIndex Zero-based index within the current page.
/// @returns The id, or 0 when out of range.
int CnrCraft_GetListId(object oPC, int nIndex);

/// @brief Capture a bare number typed in chat as the recipe id to craft.
/// @param oPC Player typing.
/// @param sTexto The chat message.
/// @returns TRUE when the message was a number and was consumed.
int CnrCraft_CaptureTypedId(object oPC, string sTexto);

/// @brief Fill the header tokens with station name and skill rank.
/// @param oPC Player browsing.
void CnrCraft_SetHeaderTokens(object oPC);

/// @brief Fill the button tokens. The dialogue cannot carry colour itself:
///     <cRGB> codes are raw bytes and do not survive JSON to GFF conversion,
///     so every button is a token coloured here at runtime.
void CnrCraft_SetButtonTokens();

/// @brief Fill the five list tokens from the current page.
/// @param oPC Player browsing.
void CnrCraft_SetSlotTokens(object oPC);

/// @brief Fill the detail token for the selected recipe.
/// @param oPC Player browsing.
/// @param oStation Station holding the components.
void CnrCraft_SetDetailToken(object oPC, object oStation);

/// @brief Read one entry from the list cache.
/// @param oPC Player browsing.
/// @param nIndex Zero-based index within the current page.
/// @returns The rendered line, or "" when out of range.
string CnrCraft_GetListEntry(object oPC, int nIndex);

/// @brief Select a recipe by its public id and cache it on the PC.
/// @param oPC Player crafting.
/// @param nPublicId The id shown in the menu.
/// @returns TRUE when enabled, owned by this station and within tradeskill level.
/// Reports a refusal to the player before returning FALSE.
int CnrCraft_SelectRecipe(object oPC, int nPublicId);

/// @brief The product a recipe makes, once the crafter's choice is taken into
///     account.
/// @param oPC The crafter.
/// @param nRecipe Recipe identifier.
/// @returns "resref|name", or an empty string when the recipe offers a group
///     and nothing valid has been chosen from it. The name is empty when the
///     recipe's own display name should be used.
string CnrCraft_ResolveProduct(object oPC, int nRecipe);

/// @brief Lists the products of the open recipe's group into the menu.
/// @param oPC The crafter.
/// @returns How many were listed.
int CnrCraft_ListVariants(object oPC);

/// @brief Build the detail screen for the selected recipe.
/// @param oPC Player crafting.
/// @param oStation Station holding the components.
/// @returns Multi-line description with DC, gold, materials and result.
string CnrCraft_DescribeSelection(object oPC, object oStation);

/// @brief Whether the station holds every component in the required quantity.
/// @param oPC Player crafting.
/// @param oStation Station holding the components.
/// @returns TRUE when the recipe can be attempted.
int CnrCraft_HasMaterials(object oPC, object oStation);

/// @brief Find an inventory tool recursively, including equipped slots.
/// @param oOwner Creature or container that owns the tool.
/// @param sToolTag Exact item tag required by the station.
/// @returns The first matching item, or OBJECT_INVALID when absent.
object CnrCraft_FindInventoryTool(object oOwner, string sToolTag);

/// @brief Find a tool in one of the creature's equipped slots.
/// @param oPC Player whose equipment is searched.
/// @param sToolTag Exact item tag required by the station.
/// @returns The matching equipped item, or OBJECT_INVALID when absent.
object CnrCraft_FindEquippedTool(object oPC, string sToolTag);

/// @brief Enforce every tool row configured for the current station.
/// @param oPC Player attempting the craft.
/// @param oStation Station being used.
/// @returns TRUE when every required tool is present and survives breakage.
int CnrCraft_CheckStationTools(object oPC, object oStation, int nRecipe);

/// @brief Remove nQty items with sTag from the station inventory.
/// @param oStation Station holding the components.
/// @param sTag Component tag.
/// @param nQty How many to remove.
void CnrCraft_ConsumeFromStation(object oStation, string sTag, int nQty);

/// @brief Divide two integers using mathematical floor for negative results.
/// @param nDividend Value to divide.
/// @param nDivisor Positive divisor.
/// @returns floor(nDividend / nDivisor), or 0 for an invalid divisor.
int CnrCraft_FloorDivide(int nDividend, int nDivisor);

/// @brief Total bonus the PC adds to the crafting roll.
/// @param oPC Player crafting.
/// @param nProfessionId Profession the station belongs to.
/// @returns Tradeskill level plus the floored average of the profession's
///     ability contribution and the natural Craft-rank contribution.
int CnrCraft_GetRollBonus(object oPC, int nProfessionId);

/// @brief Complete a previously animated crafting attempt.
/// @param oPC Player crafting.
/// @param oStation Station whose animation script ran.
/// @param bSuccess Whether the crafting roll succeeded.
/// @param nGain Tradeskill XP awarded by the attempt.
/// @param nSkill One-based tradeskill index.
/// @param sResRef Blueprint resref of the result.
/// @param sOutputTag Optional tag assigned to the result.
/// @param nQty Number of result items created.
/// @param sName Display name assigned to the result.
/// @param sPropertyRows Serialized item properties to apply.
/// @param sExtraResRef Optional second product, created on success only.
/// @param nExtraQty How many of the second product; 0 when there is none.
/// @param bMarksSocketed TRUE when the result already holds a gem.
/// @param nOficio Profession that made it, or 0 when it is not a crafted piece.
/// @param iRecipe Recipe ID captured before the animation.
/// @param iTier Recipe tier captured before the animation.
void CnrCraft_Finish(
    object oPC,
    object oStation,
    int bSuccess,
    int nGain,
    int nSkill,
    string sResRef,
    string sOutputTag,
    int nQty,
    string sName,
    string sPropertyRows,
    string sExtraResRef,
    int nExtraQty,
    int bMarksSocketed,
    int nOficio,
    int iRecipe,
    int iTier
);

/// @brief Resolve a craft attempt: roll, consume, award XP.
/// @param oPC Player crafting.
/// @param oStation Station holding the components.
/// @returns TRUE on success, FALSE on failure or when it could not be attempted.
int CnrCraft_Attempt(object oPC, object oStation);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

/// @brief Verde de la interfaz de oficios. Un solo sitio donde cambiarlo.
string CnrCraft_Verde()
{
    return ColorToken(80, 255, 80);
}

void CnrCraft_ClearList(object oPC)
{
    int nCount = GetLocalInt(oPC, CNR_VAR_COUNT);
    int i;
    for (i = 0; i < nCount; i++)
    {
        DeleteLocalString(oPC, CNR_VAR_ITEM + IntToString(i));
        DeleteLocalInt(oPC, CNR_VAR_ITEM + "ID_" + IntToString(i));
    }
    SetLocalInt(oPC, CNR_VAR_COUNT, 0);
    SetLocalInt(oPC, CNR_VAR_LISTMODE, CNR_LIST_NONE);
}

int CnrCraft_OpenStation(object oPC, object oStation)
{
    string sTag = GetTag(oStation);

    if (!NWNX_SQL_PrepareQuery(
        "SELECT s.station_id, p.skill_index"
        + " FROM cnr_station s"
        + " JOIN cnr_profession p ON p.profession_id = s.profession_id"
        + " WHERE s.tag = ? LIMIT 1"))
    {
        PrintString("[CNR] Station lookup failed: " + NWNX_SQL_GetLastError());
        return 0;
    }

    NWNX_SQL_PreparedString(0, sTag);

    if (!NWNX_SQL_ExecutePreparedQuery() || !NWNX_SQL_ReadyToReadNextRow())
    {
        PrintString("[CNR] Station not registered: " + sTag);
        return 0;
    }

    NWNX_SQL_ReadNextRow();
    int nStation = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
    int nSkillIndex = StringToInt(NWNX_SQL_ReadDataInActiveRow(1));

    SetLocalInt(oPC, CNR_VAR_STATION, nStation);
    SetLocalInt(oPC, CNR_VAR_SKILL, nSkillIndex);
    SetLocalInt(oPC, CNR_VAR_CATEGORY, 0);
    SetLocalInt(oPC, CNR_VAR_PAGE, 0);
    CnrCraft_ClearList(oPC);

    return nStation;
}

int CnrCraft_ListCategories(object oPC, int nParent)
{
    int nStation = GetLocalInt(oPC, CNR_VAR_STATION);
    if (nStation <= 0)
    {
        return 0;
    }

    CnrCraft_ClearList(oPC);

    int nShowAboveLevel = CnrSetting_GetInt(
        oPC,
        CNR_SETTING_SHOW_ABOVE_LEVEL,
        FALSE
    );
    int nSkillIndex = GetLocalInt(oPC, CNR_VAR_SKILL);
    int nLevel = CnrSkill_GetLevel(oPC, nSkillIndex + 1);
    // Recipes open by level now, not in blocks of five.

    // The category count follows the same visibility rule as its recipe list.
    if (!NWNX_SQL_PrepareQuery(
        "SELECT c.category_id, c.display_name, COUNT(r.recipe_id)"
        + " FROM cnr_category c"
        + " LEFT JOIN cnr_recipe r"
        + "        ON r.category_id = c.category_id AND r.enabled = 1"
        + "       AND (? = 1 OR r.min_level <= ?)"
        + " WHERE c.station_id = ? AND c.parent_id <=> ?"
        + " GROUP BY c.category_id, c.display_name, c.sort_order"
        + " ORDER BY c.sort_order, c.display_name"))
    {
        return 0;
    }

    NWNX_SQL_PreparedInt(0, nShowAboveLevel);
    NWNX_SQL_PreparedInt(1, nLevel);
    NWNX_SQL_PreparedInt(2, nStation);
    if (nParent > 0)
    {
        NWNX_SQL_PreparedInt(3, nParent);
    }
    else
    {
        NWNX_SQL_PreparedNULL(3);
    }

    if (!NWNX_SQL_ExecutePreparedQuery())
    {
        return 0;
    }

    int nSalta = GetLocalInt(oPC, CNR_VAR_PAGE) * CNR_PAGE_SIZE;
    int nFila = 0, nCount = 0, bHayMas = FALSE;
    while (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();

        if (nFila++ < nSalta)
        {
            continue;
        }

        if (nCount >= CNR_PAGE_SIZE)
        {
            bHayMas = TRUE;
            continue;
        }

        int    nId   = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
        string sName = NWNX_SQL_ReadDataInActiveRow(1);
        string sQty  = NWNX_SQL_ReadDataInActiveRow(2);

        SetLocalString(oPC, CNR_VAR_ITEM + IntToString(nCount),
                       sName + " (" + sQty + ")");
        SetLocalInt(oPC, CNR_VAR_ITEM + "ID_" + IntToString(nCount), nId);
        nCount++;
    }
    SetLocalInt(oPC, CNR_VAR_HAYMAS, bHayMas);

    SetLocalInt(oPC, CNR_VAR_COUNT, nCount);
    SetLocalInt(oPC, CNR_VAR_LISTMODE, CNR_LIST_CATEGORIES);
    return nCount;
}

int CnrCraft_ListRecipes(object oPC, int nCategory, int nPage)
{
    CnrCraft_ClearList(oPC);

    int nShowAboveLevel = CnrSetting_GetInt(
        oPC,
        CNR_SETTING_SHOW_ABOVE_LEVEL,
        FALSE
    );
    int nSkillIndex = GetLocalInt(oPC, CNR_VAR_SKILL);
    int nLevel = CnrSkill_GetLevel(oPC, nSkillIndex + 1);
    // Recipes open by level now, not in blocks of five.

    if (!NWNX_SQL_PrepareQuery(
        "SELECT public_id, display_name, dc FROM cnr_recipe"
        + " WHERE category_id = ? AND enabled = 1"
        + "   AND (? = 1 OR min_level <= ?)"
        + " ORDER BY tier, dc, xp_award, public_id"
        + " LIMIT ? OFFSET ?"))
    {
        return 0;
    }

    NWNX_SQL_PreparedInt(0, nCategory);
    NWNX_SQL_PreparedInt(1, nShowAboveLevel);
    NWNX_SQL_PreparedInt(2, nLevel);
    // Se pide una fila de mas: si llega, hay pagina siguiente. Sin esto, una
    // ultima pagina exactamente llena deja el boton visible para siempre.
    NWNX_SQL_PreparedInt(3, CNR_PAGE_SIZE + 1);
    NWNX_SQL_PreparedInt(4, nPage * CNR_PAGE_SIZE);

    if (!NWNX_SQL_ExecutePreparedQuery())
    {
        return 0;
    }

    int nCount = 0;
    int bHayMas = FALSE;
    while (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();

        if (nCount >= CNR_PAGE_SIZE)
        {
            bHayMas = TRUE;   // la fila extra: existe pagina siguiente
            continue;
        }

        int    nPub  = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
        string sName = NWNX_SQL_ReadDataInActiveRow(1);
        string sDC   = NWNX_SQL_ReadDataInActiveRow(2);

        SetLocalString(oPC, CNR_VAR_ITEM + IntToString(nCount),
                       sName + " [DC=" + sDC + "] [ID: " + IntToString(nPub) + "]");
        SetLocalInt(oPC, CNR_VAR_ITEM + "ID_" + IntToString(nCount), nPub);
        nCount++;
    }
    SetLocalInt(oPC, CNR_VAR_HAYMAS, bHayMas);

    SetLocalInt(oPC, CNR_VAR_COUNT, nCount);
    SetLocalInt(oPC, CNR_VAR_CATEGORY, nCategory);
    SetLocalInt(oPC, CNR_VAR_PAGE, nPage);
    SetLocalInt(oPC, CNR_VAR_LISTMODE, CNR_LIST_RECIPES);
    return nCount;
}

string CnrCraft_GetListEntry(object oPC, int nIndex)
{
    if (nIndex < 0 || nIndex >= GetLocalInt(oPC, CNR_VAR_COUNT))
    {
        return "";
    }

    return GetLocalString(oPC, CNR_VAR_ITEM + IntToString(nIndex));
}

int CnrCraft_SelectRecipe(object oPC, int nPublicId)
{
    // The recipe must belong to the station currently open, or a typed id would
    // let a player craft anything anywhere the component tags happen to match.
    if (!NWNX_SQL_PrepareQuery(
        "SELECT r.recipe_id, IFNULL(r.variant_group, ''), r.category_id,"
        + " r.min_level, p.skill_index"
        + " FROM cnr_recipe r"
        + " JOIN cnr_category c ON c.category_id = r.category_id"
        + " JOIN cnr_station s ON s.station_id = c.station_id"
        + " JOIN cnr_profession p ON p.profession_id = s.profession_id"
        + " WHERE r.public_id = ? AND r.enabled = 1 AND c.station_id = ? LIMIT 1"))
    {
        SendMessageToPC(oPC, "No existe ninguna receta con ese ID en esta mesa.");
        return FALSE;
    }

    NWNX_SQL_PreparedInt(0, nPublicId);
    NWNX_SQL_PreparedInt(1, GetLocalInt(oPC, CNR_VAR_STATION));

    if (!NWNX_SQL_ExecutePreparedQuery() || !NWNX_SQL_ReadyToReadNextRow())
    {
        SendMessageToPC(oPC, "No existe ninguna receta con ese ID en esta mesa.");
        return FALSE;
    }

    NWNX_SQL_ReadNextRow();
    int iMinLevel = StringToInt(NWNX_SQL_ReadDataInActiveRow(3));
    int iSkillIndex = StringToInt(NWNX_SQL_ReadDataInActiveRow(4));
    if (CnrSkill_GetLevel(oPC, iSkillIndex + 1) < iMinLevel)
    {
        SendMessageToPC(oPC, "Necesitas nivel " + IntToString(iMinLevel)
            + " de oficio para fabricar esta receta.");
        return FALSE;
    }

    int iCategory = StringToInt(NWNX_SQL_ReadDataInActiveRow(2));
    int iReturnPage = 0;
    if (GetLocalInt(oPC, CNR_VAR_LISTMODE) == CNR_LIST_RECIPES
        && GetLocalInt(oPC, CNR_VAR_CATEGORY) == iCategory)
    {
        iReturnPage = GetLocalInt(oPC, CNR_VAR_PAGE);
    }
    SetLocalInt(oPC, CNR_VAR_RECIPE_PAGE, iReturnPage);
    SetLocalInt(oPC, CNR_VAR_RECIPE, StringToInt(NWNX_SQL_ReadDataInActiveRow(0)));

    // Choosing a recipe always drops the product chosen for the previous one:
    // a variant belongs to a group, and the new recipe may not offer it.
    SetLocalString(oPC, CNR_VAR_VGROUP, NWNX_SQL_ReadDataInActiveRow(1));
    DeleteLocalInt(oPC, CNR_VAR_VARIANT);

    // The recipe brings its own category, so a recipe reached by typing its id
    // leaves the menu able to climb back to the list it belongs to. Without
    // this, back from a typed id landed on whatever category the player had
    // browsed before, or on nothing at all at a freshly opened station.
    SetLocalInt(oPC, CNR_VAR_CATEGORY,
                StringToInt(NWNX_SQL_ReadDataInActiveRow(2)));
    return TRUE;
}

string CnrCraft_ResolveProduct(object oPC, int nRecipe)
{
    // The variant is looked up through the recipe, never on its own. Asking
    // "does this variant exist" would let a crafter send the id of a product
    // from another group; asking "does this recipe offer this variant" is the
    // question that matters, and it is one query.
    if (!NWNX_SQL_PrepareQuery(
        "SELECT v.base_resref, v.display_name, m.display_name"
        + " FROM cnr_recipe r"
        + " JOIN cnr_variant v ON v.group_code = r.variant_group"
        + " LEFT JOIN cnr_material m ON m.material_id = r.material_id"
        + " WHERE r.recipe_id = ? AND r.enabled = 1 AND v.variant_id = ?"
        + " LIMIT 1"))
    {
        return "";
    }

    NWNX_SQL_PreparedInt(0, nRecipe);
    NWNX_SQL_PreparedInt(1, GetLocalInt(oPC, CNR_VAR_VARIANT));

    if (!NWNX_SQL_ExecutePreparedQuery() || !NWNX_SQL_ReadyToReadNextRow())
    {
        return "";
    }

    NWNX_SQL_ReadNextRow();
    string sResRef   = NWNX_SQL_ReadDataInActiveRow(0);
    string sVariant  = NWNX_SQL_ReadDataInActiveRow(1);
    string sMaterial = NWNX_SQL_ReadDataInActiveRow(2);

    // "Daga" plus "Acero" reads as the recipe row it replaces, "Daga de acero".
    string sName = sVariant;
    if (sMaterial != "")
    {
        sName += " de " + GetStringLowerCase(sMaterial);
    }

    return sResRef + "|" + sName;
}

int CnrCraft_ListVariants(object oPC)
{
    string sGroup = GetLocalString(oPC, CNR_VAR_VGROUP);
    if (sGroup == "")
    {
        return 0;
    }

    if (!NWNX_SQL_PrepareQuery(
        "SELECT variant_id, display_name FROM cnr_variant"
        + " WHERE group_code = ? ORDER BY sort_order, display_name"))
    {
        return 0;
    }

    NWNX_SQL_PreparedString(0, sGroup);

    if (!NWNX_SQL_ExecutePreparedQuery())
    {
        return 0;
    }

    // Paged like every other list in the menu, and with the same variable
    // names, so the existing next/previous scripts work on it unchanged.
    int nSalta = GetLocalInt(oPC, CNR_VAR_PAGE) * CNR_PAGE_SIZE;
    int nFila = 0, nCount = 0, bHayMas = FALSE;
    while (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();

        if (nFila++ < nSalta)
        {
            continue;
        }

        if (nCount >= CNR_PAGE_SIZE)
        {
            bHayMas = TRUE;
            continue;
        }

        SetLocalString(oPC, CNR_VAR_ITEM + IntToString(nCount),
                       NWNX_SQL_ReadDataInActiveRow(1));
        SetLocalInt(oPC, CNR_VAR_ITEM + "ID_" + IntToString(nCount),
                    StringToInt(NWNX_SQL_ReadDataInActiveRow(0)));
        nCount++;
    }

    SetLocalInt(oPC, CNR_VAR_HAYMAS, bHayMas);
    SetLocalInt(oPC, CNR_VAR_COUNT, nCount);
    SetLocalInt(oPC, CNR_VAR_LISTMODE, CNR_LIST_VARIANTS);
    return nCount;
}

/// @brief How many items with sTag the station holds.
int CnrCraft_CountInStation(object oStation, string sTag)
{
    int nTotal = 0;
    object oItem = GetFirstItemInInventory(oStation);
    while (GetIsObjectValid(oItem))
    {
        if (GetTag(oItem) == sTag && !GetLocalInt(oItem, CNR_VAR_ENGARZADO))
        {
            int nStack = GetItemStackSize(oItem);
            nTotal += (nStack > 0) ? nStack : 1;
        }
        oItem = GetNextItemInInventory(oStation);
    }
    return nTotal;
}

int CnrCraft_HasMaterials(object oPC, object oStation)
{
    int nRecipe = GetLocalInt(oPC, CNR_VAR_RECIPE);
    if (nRecipe <= 0)
    {
        return FALSE;
    }

    if (!NWNX_SQL_PrepareQuery(
        "SELECT component_tag, qty FROM cnr_recipe_component WHERE recipe_id = ?"))
    {
        return FALSE;
    }

    NWNX_SQL_PreparedInt(0, nRecipe);

    if (!NWNX_SQL_ExecutePreparedQuery())
    {
        return FALSE;
    }

    // Collect first: the result set cannot be held open while scanning inventory.
    string sTags = "";
    while (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        sTags += NWNX_SQL_ReadDataInActiveRow(0) + "|"
               + NWNX_SQL_ReadDataInActiveRow(1) + ";";
    }

    while (sTags != "")
    {
        int nSep = FindSubString(sTags, ";");
        if (nSep < 0)
        {
            break;
        }

        string sPair = GetStringLeft(sTags, nSep);
        sTags = GetStringRight(sTags, GetStringLength(sTags) - nSep - 1);

        int nBar = FindSubString(sPair, "|");
        string sTag = GetStringLeft(sPair, nBar);
        int nNeed = StringToInt(GetStringRight(sPair, GetStringLength(sPair) - nBar - 1));

        if (CnrCraft_CountInStation(oStation, sTag) < nNeed)
        {
            return FALSE;
        }
    }

    return TRUE;
}

object CnrCraft_FindInventoryTool(object oOwner, string sToolTag)
{
    object oItem = GetFirstItemInInventory(oOwner);
    while (GetIsObjectValid(oItem))
    {
        if (GetTag(oItem) == sToolTag)
        {
            return oItem;
        }

        if (GetHasInventory(oItem))
        {
            object oNested = CnrCraft_FindInventoryTool(oItem, sToolTag);
            if (GetIsObjectValid(oNested))
            {
                return oNested;
            }
        }

        oItem = GetNextItemInInventory(oOwner);
    }

    if (GetObjectType(oOwner) == OBJECT_TYPE_CREATURE)
    {
        return CnrCraft_FindEquippedTool(oOwner, sToolTag);
    }

    return OBJECT_INVALID;
}

object CnrCraft_FindEquippedTool(object oPC, string sToolTag)
{
    int nSlot;
    for (nSlot = INVENTORY_SLOT_HEAD; nSlot <= INVENTORY_SLOT_BOLTS; nSlot++)
    {
        object oItem = GetItemInSlot(nSlot, oPC);
        if (GetIsObjectValid(oItem) && GetTag(oItem) == sToolTag)
        {
            return oItem;
        }
    }

    return OBJECT_INVALID;
}

int CnrCraft_CheckStationTools(object oPC, object oStation, int nRecipe)
{
    if (!NWNX_SQL_PrepareQuery(
        "SELECT st.tool_tag, st.access_mode, st.breakage_chance,"
        + "       COALESCE(st.display_name, st.tool_tag)"
        + " FROM cnr_station_tool st"
        + " JOIN cnr_station s ON s.station_id = st.station_id"
        // A tool with no category belongs to the whole station; one with a
        // category is only required by the recipes inside it.
        + " WHERE s.tag = ? AND (st.category_id IS NULL OR st.category_id ="
        + "   (SELECT category_id FROM cnr_recipe WHERE recipe_id = ?))"
        + " ORDER BY st.sort_order, st.station_tool_id"))
    {
        PrintString("[CNR] Station tool query preparation failed: "
            + NWNX_SQL_GetLastError());
        SendMessageToPC(oPC, "No se pudieron comprobar las herramientas. Avisa a un DM.");
        return FALSE;
    }

    NWNX_SQL_PreparedString(0, GetTag(oStation));
    NWNX_SQL_PreparedInt(1, nRecipe);
    if (!NWNX_SQL_ExecutePreparedQuery())
    {
        PrintString("[CNR] Station tool query failed: " + NWNX_SQL_GetLastError());
        SendMessageToPC(oPC, "No se pudieron comprobar las herramientas. Avisa a un DM.");
        return FALSE;
    }

    // SQL rows are collected before inventory access. Every row is required;
    // this makes multi-tool stations explicit instead of reproducing the old
    // single-value local-variable overwrite.
    string sTools = "";
    while (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        sTools += NWNX_SQL_ReadDataInActiveRow(0) + "|"
                + NWNX_SQL_ReadDataInActiveRow(1) + "|"
                + NWNX_SQL_ReadDataInActiveRow(2) + "|"
                + NWNX_SQL_ReadDataInActiveRow(3) + ";";
    }

    // Validate the complete set before any breakage roll can destroy a tool.
    string sRemaining = sTools;
    while (sRemaining != "")
    {
        int nEnd = FindSubString(sRemaining, ";");
        if (nEnd < 0)
        {
            break;
        }

        string sRow = GetStringLeft(sRemaining, nEnd);
        sRemaining = GetStringRight(
            sRemaining,
            GetStringLength(sRemaining) - nEnd - 1
        );

        int nFirst = FindSubString(sRow, "|");
        string sToolTag = GetStringLeft(sRow, nFirst);
        sRow = GetStringRight(sRow, GetStringLength(sRow) - nFirst - 1);
        int nSecond = FindSubString(sRow, "|");
        string sMode = GetStringLeft(sRow, nSecond);
        sRow = GetStringRight(sRow, GetStringLength(sRow) - nSecond - 1);

        // The player is told the item's name, never its tag.
        int nThird = FindSubString(sRow, "|");
        string sToolName = GetStringRight(sRow, GetStringLength(sRow) - nThird - 1);

        object oTool = (sMode == "equipped")
            ? CnrCraft_FindEquippedTool(oPC, sToolTag)
            : CnrCraft_FindInventoryTool(oPC, sToolTag);
        if (!GetIsObjectValid(oTool))
        {
            string sAction = (sMode == "equipped") ? "equipar" : "llevar";
            SendMessageToPC(oPC, "Necesitas " + sAction + " "
                + sToolName + " para fabricar aqui.");
            return FALSE;
        }
    }

    // A configured percentage is evaluated independently for each tool.
    sRemaining = sTools;
    while (sRemaining != "")
    {
        int nEnd = FindSubString(sRemaining, ";");
        if (nEnd < 0)
        {
            break;
        }

        string sRow = GetStringLeft(sRemaining, nEnd);
        sRemaining = GetStringRight(
            sRemaining,
            GetStringLength(sRemaining) - nEnd - 1
        );

        int nFirst = FindSubString(sRow, "|");
        string sToolTag = GetStringLeft(sRow, nFirst);
        sRow = GetStringRight(sRow, GetStringLength(sRow) - nFirst - 1);
        int nSecond = FindSubString(sRow, "|");
        string sMode = GetStringLeft(sRow, nSecond);
        sRow = GetStringRight(sRow, GetStringLength(sRow) - nSecond - 1);
        // Cut at the separator: the display name follows the chance, and
        // leaving it attached only worked because StringToFloat stops at the
        // first character it cannot read.
        int nThird = FindSubString(sRow, "|");
        float fBreakage = StringToFloat(
            (nThird < 0) ? sRow : GetStringLeft(sRow, nThird)
        );

        object oTool = (sMode == "equipped")
            ? CnrCraft_FindEquippedTool(oPC, sToolTag)
            : CnrCraft_FindInventoryTool(oPC, sToolTag);
        if (fBreakage > 0.0
            && Random(10000) < FloatToInt(fBreakage * 100.0))
        {
            string sToolName = GetName(oTool);
            CnrStack_BreakTool(oTool);
            SendMessageToPC(oPC, "Se ha roto: " + sToolName + ".");
            return FALSE;
        }
    }

    return TRUE;
}

void CnrCraft_ConsumeFromStation(object oStation, string sTag, int nQty)
{
    object oItem = GetFirstItemInInventory(oStation);
    while (GetIsObjectValid(oItem) && nQty > 0)
    {
        object oNext = GetNextItemInInventory(oStation);

        if (GetTag(oItem) == sTag && !GetLocalInt(oItem, CNR_VAR_ENGARZADO))
        {
            int nStack = GetItemStackSize(oItem);
            if (nStack <= 0)
            {
                nStack = 1;
            }

            if (nStack <= nQty)
            {
                nQty -= nStack;
                DestroyObject(oItem);
            }
            else
            {
                SetItemStackSize(oItem, nStack - nQty);
                nQty = 0;
            }
        }

        oItem = oNext;
    }
}

int CnrCraft_FloorDivide(int nDividend, int nDivisor)
{
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

int CnrCraft_GetRollBonus(object oPC, int nProfessionId)
{
    // Base Craft ranks only, no item bonuses.
    int nRanks = GetSkillRank(SKILL_CRAFT_WEAPON, oPC, TRUE);
    int nCraftBonus = nRanks / CNR_CRAFT_RANKS_PER_BONUS;

    if (nProfessionId <= 0)
    {
        SetLocalInt(oPC, CNR_VAR_ROLL_LEVEL, 0);
        SetLocalInt(oPC, CNR_VAR_ROLL_HELP, CnrCraft_FloorDivide(nCraftBonus, 2));
        return GetLocalInt(oPC, CNR_VAR_ROLL_HELP);
    }

    if (!NWNX_SQL_PrepareQuery(
        "SELECT ability_1, ability_2, skill_index FROM cnr_profession"
        + " WHERE profession_id = ? LIMIT 1"))
    {
        return CnrCraft_FloorDivide(nCraftBonus, 2);
    }

    NWNX_SQL_PreparedInt(0, nProfessionId);

    if (!NWNX_SQL_ExecutePreparedQuery() || !NWNX_SQL_ReadyToReadNextRow())
    {
        return CnrCraft_FloorDivide(nCraftBonus, 2);
    }

    NWNX_SQL_ReadNextRow();
    string sA1 = NWNX_SQL_ReadDataInActiveRow(0);
    string sA2 = NWNX_SQL_ReadDataInActiveRow(1);
    int nSkillIndex = StringToInt(NWNX_SQL_ReadDataInActiveRow(2));

    // First average the profession's configured abilities. Mathematical floor
    // matters for penalties because NWScript integer division truncates toward
    // zero. Then average that result with the natural Craft-rank contribution.
    int nAbilityBonus = 0;
    if (sA1 != "")
    {
        nAbilityBonus = GetAbilityModifier(StringToInt(sA1), oPC);
        if (sA2 != "")
        {
            nAbilityBonus = CnrCraft_FloorDivide(
                nAbilityBonus + GetAbilityModifier(StringToInt(sA2), oPC),
                2
            );
        }
    }

    // The profession's own level. skill_index is 0-based, CnrSkill is 1-based.
    int nProfessionLevel = CnrSkill_GetLevel(oPC, nSkillIndex + 1);
    int nHelpBonus = CnrCraft_FloorDivide(nAbilityBonus + nCraftBonus, 2);
    SetLocalInt(oPC, CNR_VAR_ROLL_LEVEL, nProfessionLevel);
    SetLocalInt(oPC, CNR_VAR_ROLL_HELP, nHelpBonus);
    return nProfessionLevel + nHelpBonus;
}

string CnrCraft_DescribeSelection(object oPC, object oStation)
{
    int nRecipe = GetLocalInt(oPC, CNR_VAR_RECIPE);
    if (nRecipe <= 0)
    {
        return "";
    }

    if (!NWNX_SQL_PrepareQuery(
        "SELECT r.display_name, r.dc, r.gold_value, r.output_qty,"
        + "       IFNULL(r.extra_name, r.extra_resref), r.extra_qty"
        + " FROM cnr_recipe r"
        + " JOIN cnr_category c ON c.category_id = r.category_id"
        + " WHERE r.recipe_id = ? AND r.enabled = 1 AND c.station_id = ? LIMIT 1"))
    {
        return "";
    }

    NWNX_SQL_PreparedInt(0, nRecipe);
    NWNX_SQL_PreparedInt(1, GetLocalInt(oPC, CNR_VAR_STATION));

    if (!NWNX_SQL_ExecutePreparedQuery() || !NWNX_SQL_ReadyToReadNextRow())
    {
        return "";
    }

    NWNX_SQL_ReadNextRow();
    string sName = NWNX_SQL_ReadDataInActiveRow(0);
    string sDC   = NWNX_SQL_ReadDataInActiveRow(1);
    string sGold = NWNX_SQL_ReadDataInActiveRow(2);
    string sQty  = NWNX_SQL_ReadDataInActiveRow(3);
    // extra_name is what the player reads; the resref is only the fallback for
    // a row that forgot one, and a tag is never shown here.
    string sExtraNom = NWNX_SQL_ReadDataInActiveRow(4);
    int    nExtraQty = StringToInt(NWNX_SQL_ReadDataInActiveRow(5));

    string sV = CnrCraft_Verde();
    string sF = ColorTokenEnd();

    // With a group chosen, the heading is the product and not the recipe: the
    // crafter picked "Daga" and expects to read "Daga de acero", not
    // "Arma de acero". The lookup also proves the choice still stands.
    if (GetLocalString(oPC, CNR_VAR_VGROUP) != "")
    {
        string sProduct = CnrCraft_ResolveProduct(oPC, nRecipe);
        if (sProduct != "")
        {
            int nCut = FindSubString(sProduct, "|");
            sName = GetStringRight(sProduct,
                                   GetStringLength(sProduct) - nCut - 1);
        }
    }

    string sOut = sName + "\n\n"
                + sV + "Dificultad (DC): " + sF + sDC + "\n"
                + sV + "Valor total: "     + sF + sGold + " monedas de oro\n"
                + sV + "Materiales necesarios:" + sF + "\n";

    if (!NWNX_SQL_PrepareQuery(
        "SELECT component_tag, qty, IFNULL(display_name, component_tag)"
        + " FROM cnr_recipe_component WHERE recipe_id = ? ORDER BY sort_order"))
    {
        return sOut;
    }

    NWNX_SQL_PreparedInt(0, nRecipe);

    if (NWNX_SQL_ExecutePreparedQuery())
    {
        string sPairs = "";
        while (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            sPairs += NWNX_SQL_ReadDataInActiveRow(0) + "|"
                    + NWNX_SQL_ReadDataInActiveRow(1) + "|"
                    + NWNX_SQL_ReadDataInActiveRow(2) + ";";
        }

        while (sPairs != "")
        {
            int nSep = FindSubString(sPairs, ";");
            if (nSep < 0)
            {
                break;
            }

            string sPair = GetStringLeft(sPairs, nSep);
            sPairs = GetStringRight(sPairs, GetStringLength(sPairs) - nSep - 1);

            int nBar = FindSubString(sPair, "|");
            string sTag = GetStringLeft(sPair, nBar);
            sPair = GetStringRight(sPair, GetStringLength(sPair) - nBar - 1);

            int nBar2 = FindSubString(sPair, "|");
            string sNeed = GetStringLeft(sPair, nBar2);
            string sNom  = GetStringRight(sPair, GetStringLength(sPair) - nBar2 - 1);

            sOut += "  " + IntToString(CnrCraft_CountInStation(oStation, sTag))
                  + "/" + sNeed + " " + sNom + "\n";
        }
    }

    sOut += sV + "Producto final:" + sF + "\n  " + sQty + " x " + sName;
    if (sExtraNom != "" && nExtraQty > 0)
    {
        sOut += "\n  " + IntToString(nExtraQty) + " x " + sExtraNom;
    }

    return sOut;
}

void CnrCraft_Finish(
    object oPC,
    object oStation,
    int bSuccess,
    int nGain,
    int nSkill,
    string sResRef,
    string sOutputTag,
    int nQty,
    string sName,
    string sPropertyRows,
    string sExtraResRef,
    int nExtraQty,
    int bMarksSocketed,
    int nOficio,
    int iRecipe,
    int iTier
)
{
    DeleteLocalInt(oPC, CNR_VAR_ACTIVE);
    DeleteLocalInt(oPC, "bCnrCraftingResult");
    DeleteLocalFloat(oPC, "fCnrAnimationDelay");
    DeleteLocalObject(oStation, "oCnrCraftingPC");

    if (!GetIsObjectValid(oPC))
    {
        return;
    }

    // Beyond the last level of the curve the experience only piles up, so it
    // is not awarded at all and the player is told why.
    int bMaxLevel = CnrSkill_IsMaxLevel(oPC, nSkill);
    if (bMaxLevel)
    {
        nGain = 0;
    }

    int bXPStored = TRUE;
    if (nGain > 0)
    {
        bXPStored = CnrSkill_SetXP(
            oPC,
            nSkill,
            CnrSkill_GetXP(oPC, nSkill) + nGain
        );
    }

    if (!bSuccess)
    {
        string sFailureXP = bMaxLevel
            ? " Ya dominas este oficio: no ganas mas experiencia."
            : (bXPStored
                ? " Ganas " + IntToString(nGain) + " de experiencia."
                : " No se pudo guardar la experiencia.");
        SendMessageToPC(oPC, "Has fallado." + sFailureXP);
        return;
    }

    // The piece is built away from every inventory and only handed over once it
    // is finished. Creating it straight on the crafter prints "Objeto
    // adquirido:" with the blueprint's own name, before SetName has had a
    // chance to run, so a copper scale mail announced itself as the carpenter's
    // outfit whose blueprint it happens to reuse.
    //
    // It is not built inside the station either. CreateItemOnObject merges with
    // a matching stack already in the target and returns the merged pile, which
    // would then be renamed, enchanted, copied to the crafter whole and
    // destroyed: a station holding five ingots would hand over six and keep
    // none. The same trap is documented and avoided for the blueprint probe
    // further down. A location holds no stacks, so nothing can merge with it.
    object oItem = CreateObject(OBJECT_TYPE_ITEM, sResRef,
                                GetLocation(oStation));
    if (!GetIsObjectValid(oItem))
    {
        PrintString("[CNR] No se pudo crear el objeto: " + sResRef);
        SendMessageToPC(oPC, "Error al crear el objeto. Avisa a un DM.");
        return;
    }

    // Always, not only above one. CreateObject inherits the blueprint's own
    // StackSize, unlike CreateItemOnObject whose count overrides it, so a
    // potion whose blueprint stacks to ten came out as ten for one potion's
    // materials. Reported from the test server on 2026-08-21.
    SetItemStackSize(oItem, nQty);

    if (sName != "")
    {
        SetName(oItem, sName);
    }

    if (sOutputTag != "")
    {
        SetTag(oItem, sOutputTag);
    }

    // A crafted item is known to whoever made it, and the server marks its own
    // production as stolen so it cannot be resold at full price.
    CnrProduct_Stamp(oItem, iRecipe, iTier);

    if (nOficio > 0)
    {
        SetLocalInt(oItem, CNR_VAR_OFICIO, nOficio);
    }

    if (bMarksSocketed)
    {
        SetLocalInt(oItem, CNR_VAR_ENGARZADO, TRUE);
    }

    while (sPropertyRows != "")
    {
        int nEnd = FindSubString(sPropertyRows, ";");
        if (nEnd < 0)
        {
            break;
        }

        string sRow = GetStringLeft(sPropertyRows, nEnd);
        sPropertyRows = GetStringRight(
            sPropertyRows,
            GetStringLength(sPropertyRows) - nEnd - 1
        );

        int n1 = FindSubString(sRow, "|");
        string sType = GetStringLeft(sRow, n1);
        sRow = GetStringRight(sRow, GetStringLength(sRow) - n1 - 1);

        int n2 = FindSubString(sRow, "|");
        int nSubtype = StringToInt(GetStringLeft(sRow, n2));
        sRow = GetStringRight(sRow, GetStringLength(sRow) - n2 - 1);

        int n3 = FindSubString(sRow, "|");
        int nValue1 = StringToInt(GetStringLeft(sRow, n3));
        int nValue2 = StringToInt(
            GetStringRight(sRow, GetStringLength(sRow) - n3 - 1)
        );

        CnrProp_Apply(oItem, sType, nSubtype, nValue1, nValue2);
    }

    // Finished: hand it over. The copy carries the name, the tag, the flags,
    // the properties and the local variables, so what the crafter is told they
    // acquired is what they actually made. Only the piece just built is
    // destroyed; it never belonged to an inventory, so nothing else goes with
    // it.
    object oFinished = CopyItem(oItem, oPC, TRUE);
    DestroyObject(oItem);
    if (!GetIsObjectValid(oFinished))
    {
        PrintString("[CNR] No se pudo entregar el objeto: " + sResRef);
        SendMessageToPC(oPC, "Error al entregar el objeto. Avisa a un DM.");
        return;
    }

    CnrProduct_Stamp(oFinished, iRecipe, iTier);

    string sExtra = "";
    if (sExtraResRef != "" && nExtraQty > 0)
    {
        object oExtra = CreateItemOnObject(sExtraResRef, oPC, nExtraQty);
        if (GetIsObjectValid(oExtra))
        {
            CnrProduct_Stamp(oExtra, iRecipe, iTier);
            sExtra = " Ademas obtienes " + IntToString(nExtraQty) + " x "
                   + GetName(oExtra) + ".";
        }
        else
        {
            // The main product is already in the player's hands, so a bad
            // extra resref is logged and reported, never a failed craft.
            PrintString("[CNR] No se pudo crear el extra: " + sExtraResRef);
        }
    }

    string sSuccessXP = bMaxLevel
        ? ". Ya dominas este oficio: no ganas mas experiencia."
        : (bXPStored
            ? ". Ganas " + IntToString(nGain) + " de experiencia."
            : ". No se pudo guardar la experiencia.");
    SendMessageToPC(oPC, "Has creado: " + sName + sSuccessXP + sExtra);
}

int CnrCraft_Attempt(object oPC, object oStation)
{
    int nRecipe = GetLocalInt(oPC, CNR_VAR_RECIPE);
    if (nRecipe <= 0)
    {
        return FALSE;
    }

    if (GetLocalInt(oPC, CNR_VAR_ACTIVE))
    {
        SendMessageToPC(oPC, "Ya estas fabricando otro objeto.");
        return FALSE;
    }

    // Nothing is rolled, consumed or created without a resolvable identity:
    // otherwise the item exists but the XP write is refused downstream.
    if (PWDB_GetCharacterId(oPC) <= 0)
    {
        SendMessageToPC(oPC, "Tu progreso no se esta guardando; no puedes fabricar. Avisa a un DM.");
        return FALSE;
    }

    if (!NWNX_SQL_PrepareQuery(
        "SELECT r.dc, r.xp_award, r.base_resref, r.output_tag,"
        + "       r.output_qty, r.display_name, s.profession_id, p.skill_index,"
        + "       s.anim_script, IFNULL(r.extra_resref, ''), r.extra_qty,"
        + "       r.marks_socketed, r.gold_value, r.crafted_by, r.tier, r.min_level"
        + " FROM cnr_recipe r"
        + " JOIN cnr_category c ON c.category_id = r.category_id"
        + " JOIN cnr_station  s ON s.station_id  = c.station_id"
        + " JOIN cnr_profession p ON p.profession_id = s.profession_id"
        // enabled is checked again here, not only when selecting: the id lives
        // on the PC and survives a catalogue reload, which renumbers recipes.
        + " WHERE r.recipe_id = ? AND r.enabled = 1 AND c.station_id = ? LIMIT 1"))
    {
        return FALSE;
    }

    NWNX_SQL_PreparedInt(0, nRecipe);
    NWNX_SQL_PreparedInt(1, GetLocalInt(oPC, CNR_VAR_STATION));

    // The two reasons this can fail read the same to the player but not to
    // whoever reads the log. A recipe id lives on the PC and the catalogue
    // renumbers its rows every time it is rebuilt, so an id chosen before an
    // apply stops resolving after it; that is the common case and it clears
    // itself when the player picks again. A query that errors outright is a
    // different problem and used to hide in the same branch.
    if (!NWNX_SQL_ExecutePreparedQuery())
    {
        PrintString("[CNR] Recipe lookup failed for " + IntToString(nRecipe)
            + ": " + NWNX_SQL_GetLastError());
        DeleteLocalInt(oPC, CNR_VAR_RECIPE);
        SendMessageToPC(oPC, "Esa receta ya no esta disponible. Vuelve a elegirla.");
        return FALSE;
    }

    if (!NWNX_SQL_ReadyToReadNextRow())
    {
        // Disabled, deleted, or an id left over from an older catalogue.
        PrintString("[CNR] Recipe " + IntToString(nRecipe)
            + " no longer resolves: disabled, deleted or renumbered.");
        DeleteLocalInt(oPC, CNR_VAR_RECIPE);
        SendMessageToPC(oPC, "Esa receta ya no esta disponible. Vuelve a elegirla.");
        return FALSE;
    }

    NWNX_SQL_ReadNextRow();
    int    nDC      = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
    int    nXP      = StringToInt(NWNX_SQL_ReadDataInActiveRow(1));
    string sResRef  = NWNX_SQL_ReadDataInActiveRow(2);
    string sOutTag  = NWNX_SQL_ReadDataInActiveRow(3);
    int    nQty     = StringToInt(NWNX_SQL_ReadDataInActiveRow(4));
    string sName    = NWNX_SQL_ReadDataInActiveRow(5);
    int    nProf    = StringToInt(NWNX_SQL_ReadDataInActiveRow(6));
    int    nSkillIx = StringToInt(NWNX_SQL_ReadDataInActiveRow(7));
    string sAnim    = NWNX_SQL_ReadDataInActiveRow(8);
    // Second product. Created on success only, and never in place of the main
    // one: a jeweller cutting a stone keeps the gem and also gets its dust.
    string sExtraResRef = NWNX_SQL_ReadDataInActiveRow(9);
    int    nExtraQty    = StringToInt(NWNX_SQL_ReadDataInActiveRow(10));
    int    bMarks       = StringToInt(NWNX_SQL_ReadDataInActiveRow(11));
    // What the attempt costs the crafter, win or lose: the menu shows it as
    // "Valor total" before the recipe is chosen.
    int    nGold        = StringToInt(NWNX_SQL_ReadDataInActiveRow(12));
    int    nOficio      = StringToInt(NWNX_SQL_ReadDataInActiveRow(13));
    int    iTier        = StringToInt(NWNX_SQL_ReadDataInActiveRow(14));

    int    iMinLevel    = StringToInt(NWNX_SQL_ReadDataInActiveRow(15));

    // Recheck the current catalogue requirement before any roll or cost.
    if (CnrSkill_GetLevel(oPC, nSkillIx + 1) < iMinLevel)
    {
        SendMessageToPC(oPC, "Necesitas nivel " + IntToString(iMinLevel)
            + " de oficio para fabricar esta receta.");
        return FALSE;
    }

    // Recipe ownership is checked before inspecting or consuming components.
    if (!CnrCraft_HasMaterials(oPC, oStation))
    {
        SendMessageToPC(oPC, "No tienes los materiales necesarios.");
        return FALSE;
    }

    if (sResRef == "")
    {
        PrintString("[CNR] Recipe has no base resref: " + IntToString(nRecipe));
        SendMessageToPC(oPC, "Error de configuracion de receta. Avisa a un DM.");
        return FALSE;
    }

    // A recipe that offers a group makes what the crafter picked from it, not
    // what its own row says. The lookup is what validates the choice: it asks
    // whether THIS recipe offers THAT variant, so an id from another group
    // resolves to nothing and the attempt stops here, before any cost.
    if (GetLocalString(oPC, CNR_VAR_VGROUP) != "")
    {
        string sProduct = CnrCraft_ResolveProduct(oPC, nRecipe);
        if (sProduct == "")
        {
            SendMessageToPC(oPC, "Elige primero que quieres fabricar.");
            return FALSE;
        }

        int nCut = FindSubString(sProduct, "|");
        sResRef = GetStringLeft(sProduct, nCut);
        string sVariantName = GetStringRight(sProduct,
            GetStringLength(sProduct) - nCut - 1);
        if (sVariantName != "")
        {
            sName = sVariantName;
        }
    }

    // The blueprint has to exist before anything is charged. Nothing asks the
    // module whether a resref resolves, so one is made and thrown away: it
    // lands in the station, where the materials already are, and is gone
    // before the player can act on it.
    //
    // This is here because of what happened without it: the roll succeeded,
    // the steel and the 168 gold were spent, and then the item could not be
    // created because the recipe named a blueprint that was not in the module.
    // The crafter paid for nothing and the only trace was a line in the log.
    object oProbe = CreateItemOnObject(sResRef, oStation, 1);
    if (!GetIsObjectValid(oProbe))
    {
        PrintString("[CNR] Recipe " + IntToString(nRecipe)
            + " names a blueprint that is not in the module: " + sResRef);
        SendMessageToPC(oPC, "Esa receta apunta a un objeto que no existe en el "
            + "módulo. No se ha gastado nada. Avisa a un DM.");
        return FALSE;
    }

    // Taking the probe back out is not a DestroyObject. If the station already
    // held that same item, the probe merged into its pile and destroying the
    // object would destroy the whole pile: a jeweller with ten cut gems on the
    // table lost all ten the moment a recipe was checked. Shrink the pile
    // instead, and only destroy what was created alone.
    int nProbeStack = GetItemStackSize(oProbe);
    if (nProbeStack > 1)
    {
        SetItemStackSize(oProbe, nProbeStack - 1);
    }
    else
    {
        DestroyObject(oProbe);
    }

    int nSkill = nSkillIx + 1;
    if (!CnrSkill_CanSetXP(
        oPC,
        nSkill,
        CnrSkill_GetXP(oPC, nSkill) + nXP
    ))
    {
        return FALSE;
    }

    if (!CnrCraft_CheckStationTools(oPC, oStation, nRecipe))
    {
        return FALSE;
    }

    // The gold goes last among the checks and first among the costs: nothing
    // is charged until tools, materials and profession limits have all passed,
    // and once charged the attempt always happens - a failed roll costs the
    // gold too, exactly as it costs the materials.
    if (nGold > 0)
    {
        if (GetGold(oPC) < nGold)
        {
            SendMessageToPC(oPC, "Te faltan monedas: necesitas "
                + IntToString(nGold) + " y llevas "
                + IntToString(GetGold(oPC)) + ".");
            return FALSE;
        }

        TakeGoldFromCreature(nGold, oPC, TRUE);
        SendMessageToPC(oPC, "Pagas " + IntToString(nGold) + " monedas de oro.");
    }

    // Components are read before the roll: the result set cannot stay open
    // while items are destroyed.
    string sCons = "";
    if (NWNX_SQL_PrepareQuery(
        "SELECT component_tag, qty, retain_on_fail, retain_on_success"
        + " FROM cnr_recipe_component WHERE recipe_id = ?"))
    {
        NWNX_SQL_PreparedInt(0, nRecipe);
        if (NWNX_SQL_ExecutePreparedQuery())
        {
            while (NWNX_SQL_ReadyToReadNextRow())
            {
                NWNX_SQL_ReadNextRow();
                sCons += NWNX_SQL_ReadDataInActiveRow(0) + "|"
                       + NWNX_SQL_ReadDataInActiveRow(1) + "|"
                       + NWNX_SQL_ReadDataInActiveRow(2) + "|"
                       + NWNX_SQL_ReadDataInActiveRow(3) + ";";
            }
        }
    }

    // Properties are captured before the animation. The catalogue may be
    // reloaded while the delayed result is pending, so it must not be queried
    // again by a transient recipe id.
    string sPropertyRows = "";
    if (NWNX_SQL_PrepareQuery(
        "SELECT property_type, subtype, value1, value2 FROM cnr_recipe_property"
        + " WHERE recipe_id = ? ORDER BY sort_order"))
    {
        NWNX_SQL_PreparedInt(0, nRecipe);
        if (NWNX_SQL_ExecutePreparedQuery())
        {
            while (NWNX_SQL_ReadyToReadNextRow())
            {
                NWNX_SQL_ReadNextRow();
                sPropertyRows += NWNX_SQL_ReadDataInActiveRow(0) + "|"
                               + NWNX_SQL_ReadDataInActiveRow(1) + "|"
                               + NWNX_SQL_ReadDataInActiveRow(2) + "|"
                               + NWNX_SQL_ReadDataInActiveRow(3) + ";";
            }
        }
    }

    int nRoll  = d20();
    int nTotal = nRoll + CnrCraft_GetRollBonus(oPC, nProf);
    // Natural 1 always fails, natural 20 always succeeds.
    int bOk = (nRoll == 20) || (nRoll != 1 && nTotal >= nDC);

    // Broken down, because a single total hides whether the help bonus
    // contributed anything at all.
    SendMessageToPC(oPC, "Tirada: " + IntToString(nRoll)
        + " + " + IntToString(GetLocalInt(oPC, CNR_VAR_ROLL_LEVEL)) + " (oficio)"
        + " + " + IntToString(GetLocalInt(oPC, CNR_VAR_ROLL_HELP)) + " (ayuda)"
        + " = " + IntToString(nTotal)
        + " contra DC " + IntToString(nDC));
    DeleteLocalInt(oPC, CNR_VAR_ROLL_LEVEL);
    DeleteLocalInt(oPC, CNR_VAR_ROLL_HELP);

    // Consume the components. retain_on_fail survives a failure, which is how
    // an alchemy vial is kept when the potion is lost; retain_on_success also
    // survives a success, which is how a reusable tool listed as a component
    // is given back.
    string sRest = sCons;
    while (sRest != "")
    {
        int nEnd = FindSubString(sRest, ";");
        if (nEnd < 0)
        {
            break;
        }

        string sRow = GetStringLeft(sRest, nEnd);
        sRest = GetStringRight(sRest, GetStringLength(sRest) - nEnd - 1);

        int n1 = FindSubString(sRow, "|");
        string sCTag = GetStringLeft(sRow, n1);
        sRow = GetStringRight(sRow, GetStringLength(sRow) - n1 - 1);

        int n2 = FindSubString(sRow, "|");
        int nNeed = StringToInt(GetStringLeft(sRow, n2));
        sRow = GetStringRight(sRow, GetStringLength(sRow) - n2 - 1);

        int n3 = FindSubString(sRow, "|");
        int nRetain   = StringToInt(GetStringLeft(sRow, n3));
        int nRetainOk = StringToInt(GetStringRight(sRow, GetStringLength(sRow) - n3 - 1));

        int nGasta = bOk ? (nNeed - nRetainOk) : (nNeed - nRetain);
        if (nGasta > 0)
        {
            CnrCraft_ConsumeFromStation(oStation, sCTag, nGasta);
        }
    }

    // XP: full on success, a fraction on failure. Award and result creation
    // happen after the station animation has completed.
    int nGain  = bOk ? nXP : (nXP * CNR_XP_FAILURE_PERCENT) / 100;

    SetLocalInt(oPC, CNR_VAR_ACTIVE, TRUE);
    SetLocalObject(oStation, "oCnrCraftingPC", oPC);
    SetLocalInt(oPC, "bCnrCraftingResult", bOk);
    SetLocalFloat(oPC, "fCnrAnimationDelay", 0.0);

    if (sAnim != "")
    {
        ExecuteScript(sAnim, oStation);
    }

    float fDelay = GetLocalFloat(oPC, "fCnrAnimationDelay");
    if (fDelay > 0.0)
    {
        DelayCommand(fDelay, CnrCraft_Finish(
            oPC,
            oStation,
            bOk,
            nGain,
            nSkill,
            sResRef,
            sOutTag,
            nQty,
            sName,
            sPropertyRows,
            sExtraResRef,
            nExtraQty,
            bMarks,
            nOficio,
            nRecipe,
            iTier
        ));
    }
    else
    {
        CnrCraft_Finish(
            oPC,
            oStation,
            bOk,
            nGain,
            nSkill,
            sResRef,
            sOutTag,
            nQty,
            sName,
            sPropertyRows,
            sExtraResRef,
            nExtraQty,
            bMarks,
            nOficio,
            nRecipe,
            iTier
        );
    }

    return bOk;
}

int CnrCraft_GetListId(object oPC, int nIndex)
{
    if (nIndex < 0 || nIndex >= GetLocalInt(oPC, CNR_VAR_COUNT))
    {
        return 0;
    }

    return GetLocalInt(oPC, CNR_VAR_ITEM + "ID_" + IntToString(nIndex));
}

void CnrCraft_SetHeaderTokens(object oPC)
{
    int nStation = GetLocalInt(oPC, CNR_VAR_STATION);
    string sName = "Estacion";
    int nSkillIndex = 0;

    if (NWNX_SQL_PrepareQuery(
        "SELECT s.display_name, p.skill_index FROM cnr_station s"
        + " JOIN cnr_profession p ON p.profession_id = s.profession_id"
        + " WHERE s.station_id = ? LIMIT 1"))
    {
        NWNX_SQL_PreparedInt(0, nStation);
        if (NWNX_SQL_ExecutePreparedQuery() && NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            sName = NWNX_SQL_ReadDataInActiveRow(0);
            nSkillIndex = StringToInt(NWNX_SQL_ReadDataInActiveRow(1));
        }
    }

    SetCustomToken(CNR_TOKEN_HEAD1, CnrCraft_Verde() + sName + ColorTokenEnd());
    SetCustomToken(CNR_TOKEN_HEAD2,
        CnrCraft_Verde() + "Nivel de oficio: " + ColorTokenEnd()
        + IntToString(CnrSkill_GetLevel(oPC, nSkillIndex + 1)));
}

void CnrCraft_SetButtonTokens()
{
    string sV = CnrCraft_Verde();
    string sF = ColorTokenEnd();

    // One token per reply, even where two replies read the same. Order and
    // numbering are owned by build_station_dlg.py, which prints the map when it
    // runs.
    //
    // This did NOT fix the blank labels, and the reason it was written is wrong.
    // Custom tokens are expanded by the client, so a label comes out empty when
    // the client is missing the value, not when two replies share a number - and
    // thirteen unique tokens ask the client for more than the eight shared ones
    // they replaced. Whether that is what actually happens here is still only a
    // hypothesis: nothing has been reproduced or measured.
    // See D5 in documentation/oficios/cnr/open-issues.md before touching this.
    SetCustomToken(CNR_TOKEN_BUTTON +  0, sV + "Crear nueva produccion" + sF);
    SetCustomToken(CNR_TOKEN_BUTTON +  1, sV + "Crear por ID (escribe el ID antes)" + sF);
    SetCustomToken(CNR_TOKEN_BUTTON +  2, sV + "Abrir inventario" + sF);
    SetCustomToken(CNR_TOKEN_BUTTON +  3, sV + "Terminar" + sF);
    SetCustomToken(CNR_TOKEN_BUTTON +  4, sV + "[Pagina siguiente]" + sF);
    SetCustomToken(CNR_TOKEN_BUTTON +  5, sV + "[Pagina anterior]" + sF);
    SetCustomToken(CNR_TOKEN_BUTTON +  6, sV + "[Atras]" + sF);
    SetCustomToken(CNR_TOKEN_BUTTON +  7, sV + "Abrir inventario" + sF);
    SetCustomToken(CNR_TOKEN_BUTTON +  8, sV + "Terminar" + sF);
    SetCustomToken(CNR_TOKEN_BUTTON +  9, sV + "Fabricar" + sF);
    SetCustomToken(CNR_TOKEN_BUTTON + 10, sV + "[Atras]" + sF);
    SetCustomToken(CNR_TOKEN_BUTTON + 11, sV + "Abrir inventario" + sF);
    SetCustomToken(CNR_TOKEN_BUTTON + 12, sV + "Terminar" + sF);
}

void CnrCraft_SetSlotTokens(object oPC)
{
    int i;
    for (i = 0; i < CNR_PAGE_SIZE; i++)
    {
        SetCustomToken(CNR_TOKEN_SLOT + i, CnrCraft_GetListEntry(oPC, i));
    }
}

void CnrCraft_SetDetailToken(object oPC, object oStation)
{
    SetCustomToken(CNR_TOKEN_DETAIL, CnrCraft_DescribeSelection(oPC, oStation));
}

int CnrCraft_CaptureTypedId(object oPC, string sTexto)
{
    // Only while the crafting menu is actually open. CNR_VAR_PLACEABLE lives on
    // the PC and the placeable stays valid, so without this every bare number
    // typed for the rest of the session would be swallowed.
    if (!IsInConversation(oPC))
    {
        return FALSE;
    }

    // Only a bare number counts, so normal chat is never swallowed.
    int nLen = GetStringLength(sTexto);
    if (nLen < 1 || nLen > 7)
    {
        return FALSE;
    }

    int i;
    for (i = 0; i < nLen; i++)
    {
        string sChar = GetSubString(sTexto, i, 1);
        if (FindSubString("0123456789", sChar) < 0)
        {
            return FALSE;
        }
    }

    int nId = StringToInt(sTexto);
    if (nId <= 0)
    {
        return FALSE;
    }

    SetLocalInt(oPC, CNR_VAR_TYPED_ID, nId);
    SendMessageToPC(oPC, "ID de receta preparado: " + IntToString(nId)
        + ". Elige ahora \"Crear por ID\".");
    return TRUE;
}
