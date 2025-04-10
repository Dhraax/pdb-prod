#include "pb_inc_mmf"
#include "nwnx_events"

//Script que se subscribe en los eventos NWNX_ON_CLIENT_EXPORT_CHARACTER_BEFORE y NWNX_ON_SERVER_CHARACTER_SAVE_BEFORE
//Gestiona los cambios hechos por el maestro de múltiples formas y evitar que se buggee el personaje.

void main()
{
    object oPC = OBJECT_SELF;
    object oContainer = GetItemPossessedBy(oPC,"dmfi_pc_emote");
    string sEvent = NWNX_Events_GetCurrentEvent();
    if(sEvent == NWNX_ON_CLIENT_DISCONNECT_BEFORE && ObtenerIntPersistente(oPC,"POLYMORPHED"))
    {
        SaveRemainingMMFSpecialAbilityUses(oPC);
        GuardarIntPersistente(oPC,"LOGGED_OUT_POLYMORPHED",TRUE);
    }
}
