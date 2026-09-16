/// ----------------------------------------------------------------------------
/// @system  CNR Almacen
/// @file    sapo_alma_dist
/// @author  Monti
/// @brief   OnInvDisturbed of the invisible chest: deposits and withdrawals.
///
///          A deposit adds the whole stack to the player's count and the item
///          goes. A withdrawal charges five gold per unit taken and puts the
///          next stack back, up to ten, until the count runs out.
///
///          The chest is filled by script, and a script filling a container
///          raises no disturb event, which is why putting the next stack back
///          here does not re-enter this handler.
/// modified by: Dhraax
/// ----------------------------------------------------------------------------

#include "sapo_cons_alma"
#include "mti_libreria"

/// The most the engine will stack for these base items.
const int ALM_PILA = 10;

/// Gold charged for each unit taken out.
const int ALM_PRECIO = 5;

/// @brief Whether the chest already shows this material.
/// @param oCofre The invisible chest.
/// @param oExcluir The item being deposited, which is about to be destroyed.
/// @param sBuscado The material's resref, lower case.
/// @returns TRUE when a stack of it is already on display.
int AlmHayMuestra(object oCofre, object oExcluir, string sBuscado)
{
    object oItem = GetFirstItemInInventory(oCofre);
    while (GetIsObjectValid(oItem))
    {
        if (oItem != oExcluir
            && (GetStringLowerCase(GetResRef(oItem)) == sBuscado
                || GetStringLowerCase(GetTag(oItem)) == sBuscado))
        {
            return TRUE;
        }
        oItem = GetNextItemInInventory(oCofre);
    }
    return FALSE;
}

void GuardarIngrediente(object oJugador, string sVariable, string sNombre, int nCantidad)
{
    GuardarIntPersistente(oJugador, sVariable,
        ObtenerIntPersistente(oJugador, sVariable) + nCantidad);
    SendMessageToPC(oJugador, "Almacenado: " + sNombre + " x" + IntToString(nCantidad));
}

void SacarIngrediente(object oJugador, string sVariable, string sNombre, int nCantidad)
{
    GuardarIntPersistente(oJugador, sVariable,
        ObtenerIntPersistente(oJugador, sVariable) - nCantidad);
    SendMessageToPC(oJugador, "Sacado: " + sNombre + " x" + IntToString(nCantidad));
}

void main()
{
    int iTipoDisturbio = GetInventoryDisturbType();
    object oPC = GetLastDisturbed();
    object oUbicado = OBJECT_SELF;
    object oIngOficios = GetInventoryDisturbItem();

    // A container inside the chest would hide its contents from the count.
    object oTest = GetFirstItemInInventory(oIngOficios);
    if (GetIsObjectValid(oTest))
    {
        FloatingTextStringOnCreature("*¡No puedes guardar un recipiente dentro de otro!*", oPC, FALSE);
        while (GetIsObjectValid(oTest))
        {
            CopyItem(oTest, oPC);
            DestroyObject(oTest, 0.0);
            oTest = GetNextItemInInventory(oIngOficios);
        }
        CopyItem(oIngOficios, oPC, TRUE);
        DestroyObject(oIngOficios, 0.0);
        return;
    }

    int nPila = GetItemStackSize(oIngOficios);
    if (nPila < 1)
    {
        nPila = 1;
    }

    // The list keys on the blueprint resref, because that is what
    // CreateItemOnObject needs. An item carries both a resref and a tag and the
    // two are not always the same string: 43 materials differ only in case and
    // five have a tag longer than the sixteen characters a resref allows.
    // Comparing only the tag, as this handler used to, silently refused those
    // 48 on the way in and let them out without charging on the way out.
    string sResItem = GetStringLowerCase(GetResRef(oIngOficios));
    string sTagItem = GetStringLowerCase(GetTag(oIngOficios));

    int nCount;
    for (nCount = 1; nCount <= NUM_DIST_INGRED; nCount++)
    {
        string sVar = GetLocalArrayString(oUbicado, "sVarIngOficio", nCount);
        string sTag = GetLocalArrayString(oUbicado, "sTagIngOficio", nCount);
        if (sVar == "" || sTag == "")
        {
            continue;
        }

        string sBuscado = GetStringLowerCase(sTag);
        if (sResItem != sBuscado && sTagItem != sBuscado)
        {
            continue;
        }

        string sNom = GetLocalArrayString(oUbicado, "sNomIngOficio", nCount);

        if (iTipoDisturbio == INVENTORY_DISTURB_TYPE_ADDED)
        {
            GuardarIngrediente(oPC, sVar, sNom, nPila);
            DestroyObject(oIngOficios, 0.0);

            // Exactly one stack is on show at a time. Creating another here
            // without looking would leave two on display against a single
            // count, and the player could take both.
            if (!AlmHayMuestra(oUbicado, oIngOficios, sBuscado))
            {
                int nQueda = ObtenerIntPersistente(oPC, sVar);
                if (nQueda > 0)
                {
                    int nMuestra = nQueda;
                    if (nMuestra > ALM_PILA)
                    {
                        nMuestra = ALM_PILA;
                    }
                    CreateItemOnObject(sTag, oUbicado, nMuestra);
                }
            }
            return;
        }

        if (iTipoDisturbio == INVENTORY_DISTURB_TYPE_REMOVED)
        {
            int nPrecio = ALM_PRECIO * nPila;
            if (GetGold(oPC) < nPrecio)
            {
                // Put it back rather than destroy it: a stack is worth more
                // than the five gold the old script charged for a single unit.
                SendMessageToPC(oPC, "Necesitas " + IntToString(nPrecio)
                    + " po para sacar " + IntToString(nPila) + ".");
                CopyItem(oIngOficios, oUbicado, TRUE);
                DestroyObject(oIngOficios, 0.0);
                return;
            }

            TakeGoldFromCreature(nPrecio, oPC, TRUE);
            SacarIngrediente(oPC, sVar, sNom, nPila);

            int nResto = ObtenerIntPersistente(oPC, sVar);
            if (nResto > 0)
            {
                int nSiguiente = nResto;
                if (nSiguiente > ALM_PILA)
                {
                    nSiguiente = ALM_PILA;
                }
                CreateItemOnObject(sTag, oUbicado, nSiguiente);
            }
            return;
        }

        return;
    }

    // Not a material the store accepts: give it back.
    if (iTipoDisturbio == INVENTORY_DISTURB_TYPE_ADDED)
    {
        CopyItem(oIngOficios, oPC, TRUE);
        DestroyObject(oIngOficios);
        SendMessageToPC(oPC, "¡No puedes guardar eso ahí!");
    }
}
