//::///////////////////////////////////////////////
//:: FileName ukiconj_sin_amdm
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 11/07/2007 1:45:20
//:://////////////////////////////////////////////
#include "nw_i0_tool"
#include "mti_libreria"

int StartingConditional()
{
object oPC = GetPCSpeaker();
int nComprobarVar = ObtenerIntPersistente(oPC, "ENTRENAMIENTOGU1");
    // Comprobar si el PJ que habla tiene los objetos en su inventario
    if(nComprobarVar == 1)
        return FALSE;

    return TRUE;
}
