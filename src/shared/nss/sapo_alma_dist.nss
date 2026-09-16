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
    string sTagIngOficio = GetTag(oIngOficios);

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

    int nCount;
    for (nCount = 1; nCount <= NUM_DIST_INGRED; nCount++)
    {
        string sVar = GetLocalArrayString(oUbicado, "sVarIngOficio", nCount);
        string sTag = GetLocalArrayString(oUbicado, "sTagIngOficio", nCount);
        if (sVar == "" || sTag == "")
        {
            continue;
        }

        // The list keys on the blueprint resref; what arrives carries its tag.
        // They match for every material in the list, and the check below is
        // what keeps anything else out.
        if (sTagIngOficio != sTag)
        {
            continue;
        }

        string sNom = GetLocalArrayString(oUbicado, "sNomIngOficio", nCount);

        if (iTipoDisturbio == INVENTORY_DISTURB_TYPE_ADDED)
        {
            GuardarIngrediente(oPC, sVar, sNom, nPila);
            DestroyObject(oIngOficios, 0.0);

            // Show the next stack, so the chest always offers what is left.
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
