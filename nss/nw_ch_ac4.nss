//::///////////////////////////////////////////////
//:: Associate: On Dialogue
//:: NW_CH_AC4
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Determines the course of action to be taken
    by the generic script after dialogue or a
    shout is initiated.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 24, 2001
//:://////////////////////////////////////////////


#include "hench_i0_hensho"

int AbleToTalk(object oSelf)
{
    if (GetCommandable(oSelf) == FALSE)
    {
        if (GetHasEffect(EFFECT_TYPE_CONFUSED, oSelf) || GetHasEffect(EFFECT_TYPE_DOMINATED, oSelf) ||
            GetHasEffect(EFFECT_TYPE_PETRIFY, oSelf) || GetHasEffect(EFFECT_TYPE_PARALYZE, oSelf)   ||
            GetHasEffect(EFFECT_TYPE_STUNNED, oSelf) || GetHasEffect(EFFECT_TYPE_FRIGHTENED, oSelf)
        )
        {
            return FALSE;
        }
    }
    return TRUE;
}
void main()
{
            object oMinionMaster = GetMaster(), oMinionShouter = GetLastSpeaker();
            int nMinionMatch = GetListenPatternNumber();

            if(GetIsObjectValid(oMinionShouter) && oMinionMaster == oMinionShouter)
            {
                switch (nMinionMatch)
                {
                    // These are orders we want to re-enable AI for
                    case ASSOCIATE_COMMAND_ATTACKNEAREST:
                    case ASSOCIATE_COMMAND_FOLLOWMASTER:
                    case ASSOCIATE_COMMAND_GUARDMASTER:
                    case ASSOCIATE_COMMAND_STANDGROUND:
                    case ASSOCIATE_COMMAND_HEALMASTER:
                    case ASSOCIATE_COMMAND_PICKLOCK:
                    case ASSOCIATE_COMMAND_DISARMTRAP:
                    case ASSOCIATE_COMMAND_MASTERFAILEDLOCKPICK:
                    case ASSOCIATE_COMMAND_LEAVEPARTY:
                        DeleteLocalObject(OBJECT_SELF, "bmc_attacktarget");
                        SetLocalInt(OBJECT_SELF, "bmc_active", 0);
                        break;

                    // These are orders we want to ignore
                    case ASSOCIATE_COMMAND_MASTERGOINGTOBEATTACKED:
                    case ASSOCIATE_COMMAND_MASTERATTACKEDOTHER:
                    case ASSOCIATE_COMMAND_MASTERUNDERATTACK:
                        if (GetLocalInt(OBJECT_SELF, "bmc_active"))
                        {
                            return;
                        }
                        break;
                }
            }
    object oMaster = GetMaster();
    int nMatch = GetListenPatternNumber();
    object oShouter = GetLastSpeaker();

    object oIntruder;
    if (nMatch == -1)
    {
        if(!GetIsDisabled(OBJECT_SELF) && GetCurrentAction() != ACTION_OPENLOCK)
        {
            ClearAllActions();
                // restore associate settings
            HenchGetDefSettings();
            // * if in XP2, use an alternative dialog file
            string sDialog = "";
            if (GetLocalInt(GetModule(), "X2_L_XP2") == 1)
            {
                sDialog = "x2_associate";
            }
            BeginConversation(sDialog);
        }
    }
    else if(GetIsObjectValid(oShouter) && oMaster == oShouter)
    {
        SetCommandable(TRUE);
        HenchChRespondToShout(oShouter, nMatch, oIntruder);
    }

    // Signal user-defined event
    if(GetSpawnInCondition(NW_FLAG_ON_DIALOGUE_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_DIALOGUE));
    }
}

