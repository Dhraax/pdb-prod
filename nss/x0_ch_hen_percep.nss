//:://////////////////////////////////////////////////
//:: X0_CH_HEN_PERCEP
/*

  OnPerception event handler for henchmen/associates.

 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 01/05/2003
//:://////////////////////////////////////////////////


#include "X0_INC_HENAI"

void main()
{

     // Don't do anything if we have have been recently commanded
            if (GetLocalInt(OBJECT_SELF, "bmc_active"))
            {
                return;
            }
    //This is the equivalent of a force conversation bubble, should only be used if you want an NPC
    //to say something while he is already engaged in combat.
    if(GetSpawnInCondition(NW_FLAG_SPECIAL_COMBAT_CONVERSATION))
    {
        ActionStartConversation(OBJECT_SELF);
    }

    // * July 2003
    // * If in Stealth mode, don't attack enemies. Wait for player to attack or
    // * for you to be attacked. (No point hiding anymore if you've been detected)
    if(!GetAssociateState(NW_ASC_MODE_STAND_GROUND) && GetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH)== FALSE)
    {
        //Do not bother checking the last target seen if already fighting
        if(!GetIsObjectValid(GetAttemptedAttackTarget()) &&
           !GetIsObjectValid(GetAttackTarget()) &&
           !GetIsObjectValid(GetAttemptedSpellTarget()))
        {
            //Check if the last percieved creature was actually seen
            if(GetLastPerceptionSeen())
            {
                if(GetIsEnemy(GetLastPerceived()))
                {
                    SetFacingPoint(GetPosition(GetLastPerceived()));
                    HenchmenCombatRound(OBJECT_INVALID);
                }
                //Linked up to the special conversation check to initiate a special one-off conversation
                //to get the PCs attention
                else if(GetSpawnInCondition(NW_FLAG_SPECIAL_CONVERSATION) && GetIsPC(GetLastPerceived()))
                {
                    ActionStartConversation(OBJECT_SELF);
                }
            }
        }
    }
    if(GetSpawnInCondition(NW_FLAG_PERCIEVE_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(1002));
    }
    ExecuteScript("nw_ch_ac2", OBJECT_SELF);
}

