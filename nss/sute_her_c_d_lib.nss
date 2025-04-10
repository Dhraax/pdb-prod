#include "mti_libreria"

//::///////////////////////////////////////////////
//:: FileName sute_her_c_d_lib
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 07/11/2006 18:59:04
//:://////////////////////////////////////////////
void main()
{
    // Dar los objetos al que habla
    CreateItemOnObject("libroherborister", GetPCSpeaker(), 1);

    // Quitar algo de oro al jugador
    TakeGoldFromCreature(200, GetPCSpeaker(), FALSE);

    GuardarIntPersistente(GetPCSpeaker(), "NIVELRECOLECCION", 1);
    GuardarIntPersistente(GetPCSpeaker(), "NIVELCOCINA", 1);
    GuardarIntPersistente(GetPCSpeaker(), "NIVELHERBOLOGIA", 1);
    GuardarIntPersistente(GetPCSpeaker(), "NIVELALQUIMIA", 1);
}
