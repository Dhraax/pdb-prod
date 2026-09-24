/// ----------------------------------------------------------------------------
/// @system  CNR Arcane
/// @file    cnr_i_apply
/// @author  Dhraax
/// @brief   The applier: takes a request the window built, checks every part
///          of it again, rolls, and enchants.
///
///          Nothing the window sent is trusted. A NUI window is driven by the
///          client, so a modified one can ask for "+7 with no essences". Every
///          check the window made is made again here, at the moment of
///          applying and inside one execution:
///
///            - the property exists, is supported, and the step exists
///            - the item is still there, is of a type the group admits, and is
///              not enchanted already
///            - the material is in the table right now
///            - the crafter has the level the property asks for
///
///          Only then is anything consumed. On a failed roll the material goes
///          all the same - the crystal is a catalyst, and it burns whether it
///          worked or not - but the item comes back untouched.
/// modified by: Dhraax
/// ----------------------------------------------------------------------------

#include "cnr_i_arcane"
#include "cnr_i_prop"
// For CnrCraft_GetRollBonus: the roll is the same one the other trades use,
// level plus the halved ability-and-craft help, so it lives in one place.
#include "cnr_i_craft"

// -----------------------------------------------------------------------------
//                                  Constants
// -----------------------------------------------------------------------------

/// A failed attempt still pays this share of the step's experience, the same
/// share the crafting engine uses.
const int CNR_ARC_XP_FAILURE_PERCENT = 12;

/// The marker every enchanted piece carries away, and the pink it is written
/// in. It has to read apart from tier 4's magenta, which a tier-4 piece shows
/// right beside it once slice 4 colours the name by tier.
///
/// ColorToken() maps each channel through ColorArray, which is the identity
/// except for the six values that would break a NWScript string literal - 0,
/// 10, 13, 34, 92 and 255 come out as 1, 11, 14, 35, 93 and 254. So 255 leaves
/// as 254, which is imperceptible but worth knowing before anyone compares
/// these numbers against the ones written into a blueprint's name. 130 and 190
/// pass through untouched.
const string CNR_ARC_MARK_TEXT = "[Encantado]";
const int    CNR_ARC_MARK_R    = 255;
const int    CNR_ARC_MARK_G    = 130;
const int    CNR_ARC_MARK_B    = 190;

/// What a player may type, once cleaned. The window caps these too, but a NUI
/// window is driven by the client and its cap is a courtesy, not a check.
const int CNR_ARC_NAME_MAX = 60;
const int CNR_ARC_DESC_MAX = 900;

/// Written by the applier and never sent by the window, so it cannot be edited
/// away nor forged with somebody else's name.
const string CNR_ARC_SIGNATURE =
    "Esta pieza ha sido imbuida por el Artesano Arcano: ";

/// Result of an attempt.
const int CNR_ARC_RESULT_REFUSED = 0;  ///< a check failed, nothing consumed
const int CNR_ARC_RESULT_FAILED  = 1;  ///< rolled and missed
const int CNR_ARC_RESULT_DONE    = 2;  ///< enchanted

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

/// @brief Removes a number of units of a material from the table.
/// @param oTable The station placeable.
/// @param sTag Material tag.
/// @param iQty How many to remove.
void CnrArcA_Consume(object oTable, string sTag, int iQty);

/// @brief The name an enchanted piece carries away.
/// @param sCurrentName The name the piece has right now.
/// @returns The same name with the marker appended in pink.
///
/// Appended, never wrapped. A crafted piece may arrive already coloured - 90 of
/// the 513 recipes bake a colour code into cnr_recipe.display_name - and two
/// closed spans side by side is what the engine reads. Wrapping the existing
/// one inside a second would leave a tag it cannot.
string CnrArcA_MarkName(string sCurrentName);

/// @brief Makes a string typed by a player safe to put on an item.
/// @param sText What the window sent.
/// @param bSingleLine TRUE to fold line breaks into spaces.
/// @param iMax Characters to keep at most.
/// @returns The cleaned text, trimmed of surrounding blanks.
///
/// Every angle bracket goes, not just well-formed colour codes. A code is "<c"
/// plus three bytes and a ">", and a half-written one swallows everything after
/// it - the [Encantado] marker included. Matching the shape would leave the
/// malformed cases behind, so the character is what goes.
string CnrArcA_Clean(string sText, int bSingleLine, int iMax);

/// @brief The colour of a tier, for the name of what it made.
/// @param iTier 1 to 4, from cnr_arcane_property.
/// @returns A colour token.
///
/// Read from the property and never from the essence: eight essences serve one
/// tier-2 property and one tier-3 property each, so an essence has no single
/// tier to give. The colour marks what was made, not what was spent.
string CnrArcA_TierColor(int iTier);

/// @brief The name an enchanted piece carries away.
/// @param sTyped The player's name, already cleaned; "" when he typed none.
/// @param iTier Tier of the property applied.
/// @param sCurrentName The name the piece has right now.
/// @returns The finished name, marker included.
string CnrArcA_BuildName(string sTyped, int iTier, string sCurrentName);

/// @brief The description an enchanted piece carries away.
/// @param sTyped The player's description, already cleaned; "" when none.
/// @param sCurrent The description the piece has right now.
/// @param sCrafter The enchanter's name, for the signature.
/// @returns The finished description, always signed.
string CnrArcA_BuildDescription(string sTyped, string sCurrent,
                                string sCrafter);

/// @brief Runs a full enchanting attempt.
/// @param oPC The crafter.
/// @param oTable The station placeable.
/// @param iArcaneId The chosen property.
/// @param iEssences The chosen step.
/// @param sCustomName What the player typed for a name, raw. "" for none.
/// @param sCustomDesc What the player typed for a description, raw. "" for
///     none.
/// @returns One of the CNR_ARC_RESULT_* constants.
///
/// The two strings arrive exactly as the client sent them and are cleaned in
/// here, never in the window.
int CnrArcA_Attempt(object oPC, object oTable, int iArcaneId, int iEssences,
                    string sCustomName = "", string sCustomDesc = "");

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

string CnrArcA_Clean(string sText, int bSingleLine, int iMax)
{
    // Bounded before the first character is read. The loop walks the string a
    // character at a time, and the string came from a client: an oversized one
    // would burn the script's instruction budget and abort the attempt part
    // way through - after the material was spent and the property applied, but
    // before the piece was marked enchanted, leaving it open to a second one.
    // Truncating the raw input costs one native call and removes the whole
    // class of it. Four times the cap so that stripping cannot starve the
    // result of legitimate characters.
    int iRoom = iMax * 4;
    if (GetStringLength(sText) > iRoom)
    {
        sText = GetStringLeft(sText, iRoom);
    }

    string sOut = "";
    int    iLen = GetStringLength(sText);
    int    i;

    for (i = 0; i < iLen; i++)
    {
        // Nothing more can be kept, so nothing more needs reading.
        if (GetStringLength(sOut) >= iMax)
        {
            break;
        }

        string sCh = GetSubString(sText, i, 1);

        if (sCh == "<" || sCh == ">")
        {
            continue;
        }
        if (sCh == "\n")
        {
            // LF only, and it is not a choice. NWScript has no "\r" escape:
            // the compiler emits the letter r for it, byte 114, verified in the
            // bytecode. Writing "\r" here therefore folded every lowercase r in
            // a name into a space - "Espada del bravo" arrived as "Espada del
            // b avo" - while capital R came through, since the test is case
            // sensitive. Reported from testing on 2026-08-23.
            //
            // So a carriage return cannot be matched at all. It is cosmetic
            // where an unbalanced colour tag was not, and a single-line
            // NuiTextEdit does not produce one; only a modified client could,
            // and the worst it buys is an odd-looking name.
            //
            // Two consecutive breaks collapse to one space, because the
            // trailing blank is trimmed below.
            if (!bSingleLine)
            {
                sOut += sCh;
                continue;
            }
            sCh = " ";
            if (GetStringRight(sOut, 1) == " ")
            {
                continue;
            }
        }
        sOut += sCh;
    }

    // Trim both ends. A name of nothing but spaces has to read as no name at
    // all, or the fallback never fires and the piece ends up nameless.
    while (GetStringLeft(sOut, 1) == " ")
    {
        sOut = GetStringRight(sOut, GetStringLength(sOut) - 1);
    }
    while (GetStringRight(sOut, 1) == " ")
    {
        sOut = GetStringLeft(sOut, GetStringLength(sOut) - 1);
    }

    if (GetStringLength(sOut) > iMax)
    {
        sOut = GetStringLeft(sOut, iMax);
    }
    return sOut;
}

string CnrArcA_TierColor(int iTier)
{
    if (iTier <= 1)
    {
        return ColorToken(1, 243, 243);     ///< cyan
    }
    if (iTier == 2)
    {
        return ColorToken(65, 105, 225);    ///< royal blue
    }
    if (iTier == 3)
    {
        return ColorToken(218, 165, 32);    ///< goldenrod
    }
    return ColorToken(255, 1, 255);         ///< magenta
}

string CnrArcA_BuildName(string sTyped, int iTier, string sCurrentName)
{
    if (sTyped == "")
    {
        // Nothing typed: the piece keeps the name it already has, colour and
        // all, and only gains the marker. Never SetName("") here - the engine
        // reads that as "revert to the original" and would undo the recipe.
        return CnrArcA_MarkName(sCurrentName);
    }

    // Typed: the old name is gone entire, so whatever colour it carried goes
    // with it and there is nothing to strip.
    return CnrArcA_TierColor(iTier) + sTyped + ColorTokenEnd()
         + " " + ColorToken(CNR_ARC_MARK_R, CNR_ARC_MARK_G, CNR_ARC_MARK_B)
         + CNR_ARC_MARK_TEXT + ColorTokenEnd();
}

string CnrArcA_BuildDescription(string sTyped, string sCurrent,
                                string sCrafter)
{
    string sBase = (sTyped != "") ? sTyped : sCurrent;
    string sSign = CNR_ARC_SIGNATURE + sCrafter;

    if (sBase == "")
    {
        return sSign;
    }
    return sBase + "\n\n" + sSign;
}

string CnrArcA_MarkName(string sCurrentName)
{
    return sCurrentName + " "
         + ColorToken(CNR_ARC_MARK_R, CNR_ARC_MARK_G, CNR_ARC_MARK_B)
         + CNR_ARC_MARK_TEXT + ColorTokenEnd();
}

void CnrArcA_Consume(object oTable, string sTag, int iQty)
{
    object oItem = GetFirstItemInInventory(oTable);
    while (GetIsObjectValid(oItem) && iQty > 0)
    {
        object oNext = GetNextItemInInventory(oTable);

        if (GetTag(oItem) == sTag)
        {
            int iStack = GetItemStackSize(oItem);
            if (iStack <= 0)
            {
                iStack = 1;
            }

            if (iStack <= iQty)
            {
                iQty -= iStack;
                DestroyObject(oItem);
            }
            else
            {
                SetItemStackSize(oItem, iStack - iQty);
                iQty = 0;
            }
        }

        oItem = oNext;
    }
}

int CnrArcA_Attempt(object oPC, object oTable, int iArcaneId, int iEssences,
                    string sCustomName, string sCustomDesc)
{
    // --- everything the window claimed, verified again -----------------------
    // The player has to still be at the table. The window checks this too, but
    // the window is the client's and this is the boundary.
    if (GetDistanceBetween(oPC, oTable) > 5.0f)
    {
        SendMessageToPC(oPC, "Estas demasiado lejos de la mesa.");
        return CNR_ARC_RESULT_REFUSED;
    }

    // Nothing is rolled or consumed without a resolvable identity: otherwise
    // the material burns and the experience write is refused downstream. The
    // crafting engine guards the same way.
    if (PWDB_GetCharacterId(oPC) <= 0)
    {
        SendMessageToPC(oPC, "Tu progreso no se esta guardando; no puedes "
            + "encantar. Avisa a un DM.");
        return CNR_ARC_RESULT_REFUSED;
    }

    string sProperty = CnrArc_ReadProperty(iArcaneId);
    if (sProperty == "")
    {
        SendMessageToPC(oPC, "Esa propiedad no existe o no se puede aplicar.");
        return CNR_ARC_RESULT_REFUSED;
    }

    string sStep = CnrArc_ReadStep(iArcaneId, iEssences);
    if (sStep == "")
    {
        SendMessageToPC(oPC, "Esa cantidad de esencias no compra ningun valor.");
        return CNR_ARC_RESULT_REFUSED;
    }

    object oTarget = CnrArc_GetTarget(oTable);
    if (!GetIsObjectValid(oTarget))
    {
        SendMessageToPC(oPC, "Pon en la mesa un solo objeto de oficio sin encantar.");
        return CNR_ARC_RESULT_REFUSED;
    }

    int    iGroup   = StringToInt(CnrArc_Field(sProperty, 2));
    string sEssence = CnrArc_Field(sProperty, 4);
    string sCrystal = CnrArc_Field(sProperty, 5);
    string sType    = CnrArc_Field(sProperty, 6);
    int    iSubtype = StringToInt(CnrArc_Field(sProperty, 7));
    int    iMinLvl  = StringToInt(CnrArc_Field(sProperty, 8));
    string sName    = CnrArc_Field(sProperty, 1);

    // The DC belongs to the step, not to the property. Field 9 of the property
    // is the design's authored number, which is the DC of the FIRST value only;
    // reading it here made every step of a property equally hard, so the roll
    // varied with the property picked instead of with the power asked for.
    int iDC = StringToInt(CnrArc_Field(sStep, 5));

    int iLevel = CnrArc_GetLevel(oPC);
    if (iLevel < iMinLvl)
    {
        SendMessageToPC(oPC, "Tu nivel de arcano no llega: necesitas "
            + IntToString(iMinLvl) + ".");
        return CNR_ARC_RESULT_REFUSED;
    }

    // Arcano is for spellcasters. Refused here, before anything is spent;
    // CnrSkill_CanSetXP still refuses the experience on every other path.
    if (!CnrSkill_IsArcaneCaster(oPC))
    {
        SendMessageToPC(oPC, "Arcano requiere al menos "
            + IntToString(CNR_ARCANE_CASTER_LEVELS) + " niveles de bardo, "
            + "brujo, clérigo, druida, hechicero, mago, alma predilecta o "
            + "artífice.");
        return CNR_ARC_RESULT_REFUSED;
    }

    // With two other trained professions Arcano is closed, as any bench is.
    if (CnrSkill_IsProfessionClosed(oPC, CNR_ARC_SKILL))
    {
        SendMessageToPC(oPC, "Ya tienes dos oficios de nivel 2 o superior. "
            + "No puedes encantar; Alquimia no ocupa plaza.");
        return CNR_ARC_RESULT_REFUSED;
    }

    int iCrystals = CnrArc_CrystalCost(iGroup, GetBaseItemType(oTarget));
    if (iCrystals <= 0)
    {
        SendMessageToPC(oPC, "Ese objeto no admite esta propiedad.");
        return CNR_ARC_RESULT_REFUSED;
    }

    if (CnrArc_CountMaterial(oTable, sEssence) < iEssences
        || CnrArc_CountMaterial(oTable, sCrystal) < iCrystals)
    {
        SendMessageToPC(oPC, "Falta material en la mesa.");
        return CNR_ARC_RESULT_REFUSED;
    }

    // The step may override the property's subtype; damage reduction is the
    // one case where the essences buy the subtype and not the value.
    int iStepSub = StringToInt(CnrArc_Field(sStep, 0));
    if (iStepSub >= 0)
    {
        iSubtype = iStepSub;
    }
    int    iValue1 = StringToInt(CnrArc_Field(sStep, 1));
    int    iValue2 = StringToInt(CnrArc_Field(sStep, 2));
    int    iXP     = StringToInt(CnrArc_Field(sStep, 3));
    string sValue  = CnrArc_Field(sStep, 4);

    // --- what the player typed, cleaned before anything is spent -------------
    // Order matters more than it looks. These two are the only values in the
    // attempt that come from the client, so they are made safe while nothing
    // has been consumed yet and the attempt can still be abandoned for free.
    string sName2 = CnrArcA_Clean(sCustomName, TRUE,  CNR_ARC_NAME_MAX);
    string sDesc2 = CnrArcA_Clean(sCustomDesc, FALSE, CNR_ARC_DESC_MAX);
    int    iTier  = StringToInt(CnrArc_Field(sProperty, 3));

    // --- the roll ------------------------------------------------------------
    int iRoll  = d20();
    int iBonus = CnrCraft_GetRollBonus(oPC, CNR_ARC_PROFESSION);
    int iTotal = iRoll + iBonus;
    int bOk    = (iRoll == 20) || (iRoll != 1 && iTotal >= iDC);

    SendMessageToPC(oPC, "Tirada: " + IntToString(iRoll) + " + "
        + IntToString(iBonus) + " = " + IntToString(iTotal)
        + " contra DC " + IntToString(iDC));

    // --- consume, win or lose ------------------------------------------------
    CnrArcA_Consume(oTable, sEssence, iEssences);
    CnrArcA_Consume(oTable, sCrystal, iCrystals);

    // --- experience ----------------------------------------------------------
    // A property of a tier below the enchanter's band pays less, as a recipe
    // does.
    int iXPBand = CnrCraft_GetXPBand(iLevel, CNR_ARC_PROFESSION);
    int iXPPercent = CnrCraft_GetXPPercent(iXPBand, iTier);
    iXP = (iXP * iXPPercent) / 100;
    if (iXPPercent < 100)
    {
        SendMessageToPC(oPC, "Esta propiedad es de tier " + IntToString(iTier)
            + " y a tu nivel de arcano (" + IntToString(iLevel) + ") da el "
            + IntToString(iXPPercent) + "% de su experiencia.");
    }

    int iGain = bOk ? iXP : (iXP * CNR_ARC_XP_FAILURE_PERCENT) / 100;
    if (iGain > 0 && !CnrSkill_IsMaxLevel(oPC, CNR_ARC_SKILL))
    {
        CnrSkill_SetXP(oPC, CNR_ARC_SKILL,
                       CnrSkill_GetXP(oPC, CNR_ARC_SKILL) + iGain);
    }

    if (!bOk)
    {
        SendMessageToPC(oPC, "El encantamiento se deshace. El objeto queda "
            + "intacto, pero el material se ha perdido.");
        return CNR_ARC_RESULT_FAILED;
    }

    // --- apply ---------------------------------------------------------------
    // The same consumer the crafting engine uses, so a property behaves the
    // same whether it came out of a recipe or out of this table.
    //
    // Its answer is checked, and that check is the point. The roll succeeding
    // is not the same as the property landing: the engine drops one the base
    // item may not carry and says nothing, which is how a bow came back named,
    // signed and marked [Encantado] with nothing on it, and unusable ever after
    // because the mark is what makes this irreversible. Reported 2026-08-27.
    //
    // The groups were corrected in the same change so that the menu can no
    // longer offer an illegal pair, and this stays anyway: it is the floor
    // under every future group, propertyType and 2DA edit, and the only thing
    // between a silent engine refusal and a ruined item.
    if (!CnrProp_Apply(oTarget, sType, iSubtype, iValue1, iValue2))
    {
        // Untouched: no name, no description, no mark, not identified. The
        // material is gone, the same way it is gone after a failed roll, but
        // the item is exactly as it went in and can be brought back.
        PrintString("[CNR] Arcane property " + IntToString(iArcaneId)
            + " (" + sType + ") did not apply to " + GetName(oTarget)
            + ", base item " + IntToString(GetBaseItemType(oTarget)));
        SendMessageToPC(oPC, "La urdimbre no prende en este objeto. Ha quedado "
            + "intacto y se puede volver a intentar, pero el material se ha "
            + "perdido. Avisa a un DM: esto no deberia ocurrir.");
        return CNR_ARC_RESULT_FAILED;
    }

    // Named and described before the mark goes on, so a piece that somehow
    // failed to be stamped is not left wearing a marker that promises
    // otherwise.
    //
    // Both strings were cleaned above, before the roll.
    SetName(oTarget, CnrArcA_BuildName(sName2, iTier, GetName(oTarget)));
    SetDescription(oTarget,
        CnrArcA_BuildDescription(sDesc2, GetDescription(oTarget),
                                 GetName(oPC)));

    // The mark is what makes this irreversible, so it goes on last.
    SetLocalInt(oTarget, CNR_ARC_VAR_DONE, TRUE);
    SetIdentified(oTarget, TRUE);

    SendMessageToPC(oPC, GetName(oTarget) + " queda encantado con "
        + sName + " " + sValue + ".");
    return CNR_ARC_RESULT_DONE;
}
