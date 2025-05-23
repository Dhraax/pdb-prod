#include "nwnx_events"
#include "x0_i0_match"
#include "mti_libreria"
#include "nw_i0_spells"
#include "inc_spells"

void main()
{
    string sCurrentEvent = NWNX_Events_GetCurrentEvent();
    object oPC = OBJECT_SELF;
    int iFeat = StringToInt(NWNX_Events_GetEventData("FEAT_ID"));

    //Evento antes de usar la dote.
    if (sCurrentEvent == "NWNX_ON_USE_FEAT_BEFORE")
    {
        //Aplicamos variable al castigar el bien y el mal.
        if(iFeat == 301)//Smite Evil.
        {
            SetLocalInt(oPC,"FEAT301", TRUE);
        }
        if(iFeat == 472)//Smite Good.
        {
            SetLocalInt(oPC,"FEAT472", TRUE);
        }
        if(iFeat == 1761)//Infusión Berserker.
        {
            if(GetLocalInt(oPC, "CLS_ING_ELIXIRBERS") == 1)
            {
                gsSPRemoveEffect(oPC, 1421, oPC);
                DeleteLocalInt(oPC,"CLS_ING_ELIXIRBERS");
                NWNX_Events_SkipEvent();
                return;
            }
            if(GetLocalInt(oPC, "CLS_ING_ELIXIRBERS") == 0)
            {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectMovementSpeedIncrease(-50), oPC, 2.5);
                FloatingTextStringOnCreature("*Rebuscar en tu cinturón los viales de alquimista te hace ir más lento.*",oPC,FALSE,FALSE);
            }
        }
    }
    /*//Evento después de usar la dote.
    else if (sCurrentEvent == "NWNX_ON_USE_FEAT_AFTER")
    {
        //Borramos variable al castigar el bien y el mal.
        if(iFeat == 301)//Smite Evil.
        {
            DeleteLocalInt(oPC,"FEAT301");
        }
        if(iFeat == 472)//Smite Good.
        {
            DeleteLocalInt(oPC,"FEAT472");
        }

    } */
}
