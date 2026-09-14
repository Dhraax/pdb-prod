// modified by: Dhraax
#include "nw_i0_spells"
#include "NW_I0_GENERIC"
#include "mti_libreria"
#include "inc_sqlite_time"
#include "nostack_inc"
#include "inc_spells"

//#include "nwnx_system"
//::////////////////////////////////////////////////////////////////////////:://
//::// LIBRERIA PERSONALIZADA DE SUTEKH                                   //:://
//::////////////////////////////////////////////////////////////////////////:://
//::// MODIFICADA POR CERRIL PARA REUTILIZARLA EN EL SISTEMA DE VENENOS   //:://
//::////////////////////////////////////////////////////////////////////////:://

//Declaraciones
int bonoRealCaracteristicaPJ(int iCaracteristica, object oPC);
void FuncionCrearObjetoYTag(string sResref, object oObjetivo = OBJECT_SELF, int iAcumulable = 1, string sNombre = "", string sNuevoTag = "", int iCantidad = 1);

void bajarAlineamiento(object oPC, int iPotencia);

//Variables Globales
int iLoop;

//Funciones
int bonoRealCaracteristicaPJ(int iCaracteristica, object oPC){
   int caracteristicaReal= GetAbilityScore(oPC, iCaracteristica, TRUE);
   int bonoReal= ((caracteristicaReal-10)/2);
   return bonoReal;
}

// CREAR OBJETO EN JUGADOR (COMPATIBLE CON DELAYS)
void FuncionCrearObjetoYTag(string sResref, object oObjetivo = OBJECT_SELF, int iAcumulable = 1, string sNombre = "", string sNuevoTag = "", int iCantidad = 1)
{
    for (iLoop = 0; iLoop < iCantidad; iLoop++) {
        object oObjetoCreado = CreateItemOnObject(sResref, oObjetivo, iAcumulable, sNuevoTag);
        if(sNombre != "") SetName(oObjetoCreado, sNombre);
        SetIdentified(oObjetoCreado, TRUE);
    }
}

// usarPocionHerboristeria lived here, 1623 lines of it. The potions are served
// by pb_potion_inc in src/cnr/nss now, which is the file CNR maintains. This
// library survives only for bonoRealCaracteristicaPJ and FuncionCrearObjetoYTag
// and should disappear once those two move to pb_item_helpers, as they already
// have in the development repository.

//void main(){}
