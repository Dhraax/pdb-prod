#include "nwnx_events"
#include "mti_libreria"

//Script que se subscribe en los eventos NWNX_ON_CLIENT_LEVEL_UP_BEFORE
//Gestiona los cambios hechos por el maestro de múltiples formas y evitar que se buggee el personaje.

void main()
{
    object oPC = OBJECT_SELF;
    string sEvent = NWNX_Events_GetCurrentEvent();
    if(sEvent == NWNX_ON_CLIENT_LEVEL_UP_BEGIN_BEFORE && ObtenerIntPersistente(oPC,"POLYMORPHED"))
    {
        NWNX_Events_SkipEvent();
        SendMessageToPC(OBJECT_SELF,"No puedes subir de nivel mientras estás transformado.");
    }
}
