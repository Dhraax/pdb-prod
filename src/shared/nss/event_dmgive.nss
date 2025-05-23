#include "nwnx_events"
#include "x0_i0_match"
#include "mti_libreria"
#include "lib_disguise"

void main()
{
    string sCurrentEvent = NWNX_Events_GetCurrentEvent();
    object oPC = OBJECT_SELF;
    object oCreado = StringToObject(NWNX_Events_GetEventData("ITEM"));
    object oObjetivo = StringToObject(NWNX_Events_GetEventData("TARGET"));

    if(sCurrentEvent == NWNX_ON_DM_GIVE_ITEM_AFTER)
    {
        //Spawneamos cofres de recompensa.
        if(GetTag(oCreado) == "item_dmcofre3" || GetTag(oCreado) == "item_dmcofre4" || GetTag(oCreado) == "item_dmcofre5")
        {
            //Guardamos en el item el nombre del DM.
            SetLocalString(oCreado, "ITEMCOFRE_DM",GetName(oPC));
            SetDescription(oCreado, "Objeto entregado por "+GetName(oPC));
        }
        //SendMessageToPC(oPC,"Se ha creado el item "+GetName(oCreado)+", por el DM "+GetName(oPC)+" con el TAG "+GetTag(oCreado)+".");
    }

}
