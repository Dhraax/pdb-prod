/// ----------------------------------------------------------------------------
/// @system  CNR Arcane
/// @file    cnr_arc_evt
/// @author  Dhraax
/// @brief   Events of the arcane window.
///
///          Encantar is pressed twice. The first press says what is missing
///          and touches nothing. The second, once the material is there,
///          warns that the choice is final and asks to confirm; the third
///          confirms.
///
///          Selection state lives on the player, not on the table: the table
///          is shared and each crafter carries their own.
/// modified by: Dhraax
/// ----------------------------------------------------------------------------

#include "cnr_arc_nui"
#include "cnr_i_apply"
#include "colors_inc"

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

/// @brief The trades system's green, so the chat reads like the rest.
/// @returns A colour token.
string CnrArcE_Green();

/// @brief Red for refusals and missing material.
/// @returns A colour token.
string CnrArcE_Red();

/// @brief Clears everything this window kept on the player.
/// @param oPC The crafter.
void CnrArcE_Clear(object oPC);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

string CnrArcE_Green()
{
    return ColorToken(80, 255, 80);
}

string CnrArcE_Red()
{
    return ColorToken(255, 80, 80);
}

void CnrArcE_Clear(object oPC)
{
    DeleteLocalObject(oPC, CNR_ARCN_V_TABLE);
    DeleteLocalInt(oPC, CNR_ARCN_V_PROP);
    DeleteLocalInt(oPC, CNR_ARCN_V_STEP);
    DeleteLocalInt(oPC, CNR_ARCN_V_CONFIRM);
    DeleteLocalInt(oPC, CNR_ARCN_V_FAM);
    DeleteLocalString(oPC, CNR_ARCN_V_FAMNAME);
    // The listing can be a few kilobytes and there is no reason to carry it
    // around once the window is gone.
    DeleteLocalString(oPC, CNR_ARCN_V_ROWS);

    // The family names are numbered locals, and locals on a PC are saved
    // with the character, so the count says how many there are to remove.
    int iFams = GetLocalInt(oPC, CNR_ARCN_V_FAMN);
    int i;
    for (i = 1; i <= iFams; i++)
    {
        DeleteLocalString(oPC, CNR_ARCN_V_FAMROW + IntToString(i));
    }
    DeleteLocalInt(oPC, CNR_ARCN_V_FAMN);
}

void main()
{
    object oPC    = NuiGetEventPlayer();
    int    iToken = NuiGetEventWindow();
    string sEvent = NuiGetEventType();
    string sElem  = NuiGetEventElement();

    if (sEvent == "close")
    {
        CnrArcE_Clear(oPC);
        return;
    }

    object oTable = GetLocalObject(oPC, CNR_ARCN_V_TABLE);
    if (!GetIsObjectValid(oTable))
    {
        return;
    }

    // -------------------------------------------------------------------------
    //  Dropdown changes
    // -------------------------------------------------------------------------
    if (sEvent == "watch")
    {
        if (sElem == CNR_ARCN_B_FAM_SEL)
        {
            int iFam = JsonGetInt(NuiGetBind(oPC, iToken, CNR_ARCN_B_FAM_SEL));
            SetLocalInt(oPC, CNR_ARCN_V_FAM, iFam);

            string sFamily = (iFam > 0)
                ? GetLocalString(oPC, CNR_ARCN_V_FAMROW + IntToString(iFam))
                : "";
            SetLocalString(oPC, CNR_ARCN_V_FAMNAME, sFamily);

            // Another family means another property and another power: leaving
            // the old ones selected would describe something that is no longer
            // on the list.
            CnrArcN_DropChoice(oPC, iToken);
            CnrArcN_DrawProps(oPC, iToken, sFamily);
            CnrArcN_DrawDetail(oPC, iToken, oTable);
        }
        else if (sElem == CNR_ARCN_B_PROP_SEL)
        {
            int iProp = JsonGetInt(NuiGetBind(oPC, iToken, CNR_ARCN_B_PROP_SEL));
            SetLocalInt(oPC, CNR_ARCN_V_PROP, iProp);
            // Changing property invalidates the power and any half-made
            // confirmation.
            DeleteLocalInt(oPC, CNR_ARCN_V_CONFIRM);
            if (iProp > 0)
            {
                CnrArcN_DrawSteps(oPC, iToken, iProp);
            }
            else
            {
                NuiSetBind(oPC, iToken, CNR_ARCN_B_STEPS, JsonArray());
                DeleteLocalInt(oPC, CNR_ARCN_V_STEP);
            }
            CnrArcN_DrawDetail(oPC, iToken, oTable);
        }
        else if (sElem == CNR_ARCN_B_STEP_SEL)
        {
            SetLocalInt(oPC, CNR_ARCN_V_STEP,
                        JsonGetInt(NuiGetBind(oPC, iToken, CNR_ARCN_B_STEP_SEL)));
            DeleteLocalInt(oPC, CNR_ARCN_V_CONFIRM);
            CnrArcN_DrawDetail(oPC, iToken, oTable);
        }
        return;
    }

    if (sEvent != "click")
    {
        return;
    }

    if (sElem == "btn_close")
    {
        NuiDestroy(oPC, iToken);
        CnrArcE_Clear(oPC);
        return;
    }

    if (sElem == "btn_all")
    {
        // Show above your level, like the trades book toggle. It only changes
        // what is listed: enchanting checks the level all the same.
        SetLocalInt(oPC, CNR_ARCN_V_ALL, !GetLocalInt(oPC, CNR_ARCN_V_ALL));
        // The refresh redraws the list, relabels this button from the state,
        // and drops the choice if the new list no longer offers it.
        CnrArcN_Refresh(oPC, oTable);
        return;
    }

    if (sElem != "btn_enchant")
    {
        return;
    }

    // -------------------------------------------------------------------------
    //  Enchant
    // -------------------------------------------------------------------------
    if (GetDistanceBetween(oPC, oTable) > 5.0f)
    {
        SendMessageToPC(oPC, CnrArcE_Red() + "Estás demasiado lejos de la mesa.");
        return;
    }

    int iProp = GetLocalInt(oPC, CNR_ARCN_V_PROP);
    int iStep = GetLocalInt(oPC, CNR_ARCN_V_STEP);

    if (iProp <= 0)
    {
        SendMessageToPC(oPC, CnrArcE_Red()
            + "Elige primero la familia y la propiedad.");
        return;
    }
    if (iStep <= 0)
    {
        SendMessageToPC(oPC, CnrArcE_Red() + "Elige cuánto poder quieres "
            + "ponerle.");
        return;
    }

    object oTarget = CnrArc_GetTarget(oTable);
    if (!GetIsObjectValid(oTarget))
    {
        SendMessageToPC(oPC, CnrArcE_Red() + CnrArcN_TargetText(oTable));
        CnrArcN_Refresh(oPC, oTable);
        return;
    }

    // The dropdown may be showing properties above the player's level.
    string sProperty = CnrArc_ReadProperty(iProp);
    if (StringToInt(CnrArc_Field(sProperty, 8)) > CnrArc_GetLevel(oPC))
    {
        SendMessageToPC(oPC, CnrArcE_Red() + "Tu nivel de arcano no llega a esa "
            + "propiedad: necesitas " + CnrArc_Field(sProperty, 8) + ".");
        return;
    }

    string sMissing = CnrArc_Missing(oPC, oTable, iProp, iStep);
    if (sMissing != "")
    {
        // First press, or material pulled out in between: say what is missing
        // and touch nothing.
        SendMessageToPC(oPC, CnrArcE_Red() + "Te falta: " + sMissing);
        NuiSetBind(oPC, iToken, CNR_ARCN_B_STATUS,
                   JsonString("Falta:\n" + sMissing));
        DeleteLocalInt(oPC, CNR_ARCN_V_CONFIRM);
        return;
    }

    string sStep = CnrArc_ReadStep(iProp, iStep);
    if (sStep == "" || sProperty == "")
    {
        SendMessageToPC(oPC, CnrArcE_Red()
            + "Esa combinación no existe. Vuelve a elegirla.");
        CnrArcN_Refresh(oPC, oTable);
        return;
    }

    string sName  = CnrArc_Field(sProperty, 1);
    string sValue = CnrArc_Field(sStep, 4);

    if (!GetLocalInt(oPC, CNR_ARCN_V_CONFIRM))
    {
        // Second press: everything is here, so ask before committing.
        SetLocalInt(oPC, CNR_ARCN_V_CONFIRM, TRUE);
        string sWarning = "Vas a encantar " + GetName(oTarget) + " con "
                        + sName + " " + sValue + ".\n"
                        + "Es definitivo: esa pieza no se puede reencantar.\n"
                        + "Pulsa Encantar otra vez para confirmarlo.";
        SendMessageToPC(oPC, CnrArcE_Green() + sWarning);
        NuiSetBind(oPC, iToken, CNR_ARCN_B_STATUS, JsonString(sWarning));
        return;
    }

    // Third press: confirmed. The applier rechecks everything on its own
    // rather than trusting any of the above, then rolls and applies.
    DeleteLocalInt(oPC, CNR_ARCN_V_CONFIRM);

    // Handed over raw. Cleaning them here would be cleaning them on the side
    // the client drives, which is no cleaning at all; the applier does it.
    string sWantName = JsonGetString(NuiGetBind(oPC, iToken, CNR_ARCN_B_NAME));
    string sWantDesc = JsonGetString(NuiGetBind(oPC, iToken, CNR_ARCN_B_DESC));

    int iResult = CnrArcA_Attempt(oPC, oTable, iProp, iStep,
                                  sWantName, sWantDesc);

    string sReport = "";

    if (iResult == CNR_ARC_RESULT_DONE)
    {
        sReport = "Encantado: " + sName + " " + sValue + ".";

        // The item is spent as a target and the material is gone: start over.
        // The two boxes go with it, or the next piece inherits a name written
        // for this one.
        NuiSetBind(oPC, iToken, CNR_ARCN_B_NAME, JsonString(""));
        NuiSetBind(oPC, iToken, CNR_ARCN_B_DESC, JsonString(""));
        CnrArcN_DropChoice(oPC, iToken);
    }
    else if (iResult == CNR_ARC_RESULT_FAILED)
    {
        sReport = "Ha fallado. La pieza sigue entera; el material no.";
    }

    // Reported after the refresh, not before. The refresh redraws the window
    // from the new state and would wipe the line the player most wants to see.
    CnrArcN_Refresh(oPC, oTable);

    if (sReport != "")
    {
        NuiSetBind(oPC, iToken, CNR_ARCN_B_STATUS, JsonString(sReport));
    }
}
