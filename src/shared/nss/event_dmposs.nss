#include "nwnx_events"
#include "x0_i0_match"
#include "mti_libreria"
#include "lib_disguise"

void main()
{
    string sCurrentEvent = NWNX_Events_GetCurrentEvent();
    object oPC = OBJECT_SELF;
    object oPossessed;

    if(sCurrentEvent == NWNX_ON_DM_POSSESS_AFTER || sCurrentEvent == NWNX_ON_DM_POSSESS_FULL_POWER_AFTER)
    {
        oPossessed = StringToObject(NWNX_Events_GetEventData("TARGET"));
        if(oPossessed == OBJECT_INVALID) //Da invalido al poseer.
        {
            oPossessed = OBJECT_SELF; //Cuando un DM desposee, OBJECT_SELF es el PNJ.
            oPC = GetLocalObject(oPossessed, "CurrentlyPossessedBy"); //Agarramos el avatar del DM.
            DeleteLocalObject(oPC, "CurrentPossessionObject"); //Borramos la variable del avatar.
            DeleteLocalObject(oPossessed, "CurrentlyPossessedBy"); //Borramos la variable del poseido.
        }
        else
        {
            object oPrePossessed = GetLocalObject(oPC, "CurrentlyPossessedBy");
            if(oPrePossessed == OBJECT_INVALID)
            { //Poseemos desde el Avatar al PNJ.
                SetLocalObject(oPC, "CurrentPossessionObject", oPossessed); //El PNJ es es el DM ahora.
                SetLocalObject(oPossessed, "CurrentlyPossessedBy", oPC); //Indicamos que DM lo posee.
            }
            else
            { //Posesion de un PNJ a otro PNJ.
                oPC = oPrePossessed; //La criatura poseida actual es el avatar DM.
                DeleteLocalObject(GetLocalObject(oPC, "CurrentPossessionObject"), "CurrentlyPossessedBy"); //Remo
                SetLocalObject(oPC, "CurrentPossessionObject", oPossessed); // Reset the possession tracking on the PC/DM Avatar
                SetLocalObject(oPossessed, "CurrentlyPossessedBy", oPC);//store the Avatar reference on the new creature.
            }
        }

        if(oPossessed != OBJECT_INVALID)
        {
            PB_Disguise_HandleOnEnter(oPossessed);
        }
        if(oPossessed == OBJECT_INVALID)
        {
            PB_Disguise_HandleOnEnter(oPC);
        }
    }
}
