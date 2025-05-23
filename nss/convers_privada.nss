//::///////////////////////////////////////////////
//:: OnConversation: Conversacion privada con PNJs
//:: convers_privada
//:: Copyright (c) www.puertadebaldur.net
//:://////////////////////////////////////////////

#include "x0_inc_henai"

void main()
{
    object oMaster = GetMaster();
    int nMatch = GetListenPatternNumber();
    object oShouter = GetLastSpeaker();
    object oIntruder;

    if(nMatch == -1)
    {
        ClearAllActions();
        AssignCommand(OBJECT_SELF, ActionStartConversation(oShouter, "", TRUE));
    }
    else
    {
        // listening pattern matched
        if (GetIsObjectValid(oShouter) && oMaster == oShouter)
        {
            SetCommandable(TRUE);
            bkRespondToHenchmenShout(oShouter, nMatch, oIntruder, TRUE);
        }
    }

    // Signal user-defined event
    if(GetSpawnInCondition(NW_FLAG_ON_DIALOGUE_EVENT)) SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_DIALOGUE));
}
