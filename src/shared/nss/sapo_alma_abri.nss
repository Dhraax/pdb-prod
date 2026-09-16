/// ----------------------------------------------------------------------------
/// @system  CNR Almacen
/// @file    sapo_alma_abri
/// @author  Monti
/// @brief   OnUsed of the material store. Builds the player's holdings inside an
///          invisible chest and makes them open it.
///
///          Nothing is really kept in the chest: every quantity lives as a
///          persistent key on the player's own variable container, and what you
///          see is created from that when you open it and destroyed when you
///          close it.
///
///          Materials come out in stacks of ten, which is what the engine
///          allows for these base items. One stack is shown at a time; taking it
///          puts the next one back, so a hundred logs do not fill the chest.
/// modified by: Dhraax
/// ----------------------------------------------------------------------------

#include "sapo_cons_alma"
#include "sapo_alma_migr"
#include "mti_libreria"

/// The most the engine will stack for these base items.
const int ALM_PILA = 10;

int RecorreIngredientes(object oUbicado, object oPC, int iCrea);
int Ngru;

void main()
{
    object oPJ = GetLastUsedBy();
    object oUbicado = OBJECT_SELF;

    if (GetLocalInt(oUbicado, "abierto") == 1)
    {
        FloatingTextStringOnCreature("*El almacen lo está usando alguien. Intentalo de nuevo cuando acabe*", oPJ);
        return;
    }

    // Convert what this character stored under the old trade's materials before
    // anything is listed, so the totals shown are the ones that survive.
    AlmMigrar(oPJ);

    object oCofre = CreateObject(OBJECT_TYPE_PLACEABLE, "sapo_alma_u", GetLocation(oUbicado));
    SetLocalObject(oCofre, "chest_use", oUbicado);
    SetLocalObject(oCofre, "user", oPJ);

    CargaArray(oCofre);

    Ngru = 0;
    int iIng = RecorreIngredientes(oCofre, oPJ, 0);
    if (iIng == 0)
    {
        SendMessageToPC(oPJ, "¡No tienes nada guardado");
    }
    else
    {
        int iI = RecorreIngredientes(oCofre, oPJ, 1);
    }

    AssignCommand(oPJ, ActionInteractObject(oCofre));
}

int RecorreIngredientes(object oUbicado, object oPC, int iCrea)
{
    int nTotal = 0;
    int iTipos = 0;
    int nCount;
    for (nCount = 1; nCount <= NUM_DIST_INGRED; nCount++)
    {
        string sVar = GetLocalArrayString(oUbicado, "sVarIngOficio", nCount);
        string sTag = GetLocalArrayString(oUbicado, "sTagIngOficio", nCount);
        if (sVar == "" || sTag == "")
        {
            continue;
        }

        int i = ObtenerIntPersistente(oPC, sVar);
        if (i > 0)
        {
            iTipos = iTipos + 1;
            nTotal = nTotal + i;
            if (iCrea == 0)
            {
                string sNom = GetLocalArrayString(oUbicado, "sNomIngOficio", nCount);
                SendMessageToPC(oPC, sNom + IntToString(i));
            }
        }

        if (iCrea == 1 && i > 0)
        {
            // One stack at a time. sapo_alma_dist puts the next one back when
            // this one is taken.
            int nPila = i;
            if (nPila > ALM_PILA)
            {
                nPila = ALM_PILA;
            }
            CreateItemOnObject(sTag, oUbicado, nPila);
        }
    }

    return nTotal;
}
