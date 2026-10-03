/// ----------------------------------------------------------------------------
/// @system  CNR Almacen
/// @file    sapo_alma_abri
/// @author  Monti
/// @brief   Open one owner-bound material session with verified display counts.
/// modified by: Dhraax
/// ----------------------------------------------------------------------------

#include "cnr_i_store"
#include "sapo_alma_migr"

void main()
{
    object oPC = GetLastUsedBy();
    object oVisible = OBJECT_SELF;
    object oVariables = GetItemPossessedBy(oPC, CONTENEDOR_VARIABLES);
    if (!GetIsPC(oPC) || !GetIsObjectValid(oVariables))
    {
        return;
    }
    if (GetLocalInt(oPC, ALM_FAULT) || GetLocalInt(oVariables, ALM_FAULT))
    {
        SendMessageToPC(oPC, "El almacen se ha bloqueado por seguridad. Avisa a un DM.");
        return;
    }
    // Close the caller's old inventory explicitly. A cancelled/missed close
    // must not strand the character behind a valid but abandoned chest object.
    object oPrevious = GetLocalObject(oPC, ALM_SESSION);
    if (GetIsObjectValid(oPrevious)
        && GetLocalObject(oPrevious, "user") == oPC)
    {
        if (!AlmRecoverSession(oPrevious))
        {
            return;
        }
    }
    else
    {
        DeleteLocalObject(oPC, ALM_SESSION);
    }
    oPrevious = GetLocalObject(oVisible, ALM_SESSION);
    if (GetIsObjectValid(oPrevious))
    {
        if (AlmSessionActive(oPrevious))
        {
            SendMessageToPC(oPC, "El almacen esta siendo utilizado por otro jugador.");
            return;
        }
        if (!AlmRecoverSession(oPrevious))
        {
            SendMessageToPC(oPC, "Esta sesion del almacen requiere revision de un DM.");
            return;
        }
    }
    AlmMigrar(oPC);
    object oChest = CreateObject(OBJECT_TYPE_PLACEABLE, "cnr_almacen_u", GetLocation(oVisible));
    if (!GetIsObjectValid(oChest))
    {
        return;
    }
    SetLocalObject(oChest, "chest_use", oVisible);
    SetLocalObject(oChest, "user", oPC);
    // Initialization is inaccessible and does not publish session locks until
    // all display counts have been validated.
    SetLocked(oChest, TRUE);
    SetUseableFlag(oChest, FALSE);
    SetLocalInt(oChest, ALM_BUSY, TRUE);
    CargaArray(oChest);
    int iIndex;
    // Complete the lookup before creating any item or accepting an event.
    for (iIndex = 1; iIndex <= NUM_DIST_INGRED; iIndex++)
    {
        string sResref = GetStringLowerCase(GetLocalArrayString(oChest, "sTagIngOficio", iIndex));
        SetLocalInt(oChest, "alm_res_" + sResref, iIndex);
    }
    for (iIndex = 1; iIndex <= NUM_DIST_INGRED; iIndex++)
    {
        string sVariable = GetLocalArrayString(oChest, "sVarIngOficio", iIndex);
        int iBalance = ObtenerIntPersistente(oPC, sVariable);
        if (iBalance < 0)
        {
            DeleteLocalInt(oChest, ALM_BUSY);
            AlmBlock(oChest, "opening-balance");
            return;
        }
        string sSuffix = IntToString(iIndex);
        SetLocalInt(oChest, "alm_balance_" + sSuffix, iBalance);
        if (iBalance > 0)
        {
            int iWanted = iBalance;
            if (iWanted > ALM_STACK)
            {
                iWanted = ALM_STACK;
            }
            CreateItemOnObject(GetLocalArrayString(oChest, "sTagIngOficio", iIndex),
                oChest, iWanted);
            SendMessageToPC(oPC, GetLocalArrayString(oChest, "sNomIngOficio", iIndex)
                + IntToString(iBalance));
        }
    }
    // Validate all created rows with one inventory pass, not one full scan
    // per material. A full catalogue must remain within the script budget.
    if (!AlmScan(oChest))
    {
        DeleteLocalInt(oChest, ALM_BUSY);
        AlmBlock(oChest, "opening-count");
        return;
    }
    for (iIndex = 1; iIndex <= NUM_DIST_INGRED; iIndex++)
    {
        string sSuffix = IntToString(iIndex);
        int iActual = GetLocalInt(oChest, "alm_now_" + sSuffix);
        int iBalance = GetLocalInt(oChest, "alm_balance_" + sSuffix);
        if (iActual > iBalance || iActual > ALM_STACK)
        {
            DeleteLocalInt(oChest, ALM_BUSY);
            AlmBlock(oChest, "opening-count");
            return;
        }
        SetLocalInt(oChest, "alm_seen_" + sSuffix, iActual);
    }
    DeleteLocalInt(oChest, ALM_BUSY);
    SetLocalObject(oPC, ALM_SESSION, oChest);
    SetLocalObject(oVisible, ALM_SESSION, oChest);
    SetLocalInt(oVisible, "abierto", TRUE);
    SetLocalInt(oChest, ALM_READY, TRUE);
    SetLocked(oChest, FALSE);
    SetUseableFlag(oChest, TRUE);
    AssignCommand(oPC, ActionInteractObject(oChest));
}
