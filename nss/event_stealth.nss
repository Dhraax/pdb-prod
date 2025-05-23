#include "nwnx_events"
#include "inc_timelock"
#include "inc_generic"

void main()
{   
    object oPC = OBJECT_SELF;
    string sCurrentEvent = NWNX_Events_GetCurrentEvent();
    // int iTime = SQLite_GetTimeStamp();
    // int iCooldown = GetLocalInt(OBJECT_SELF, "PLAIN_SIGHT_COOLDOWN");

    if (sCurrentEvent == "NWNX_ON_STEALTH_ENTER_BEFORE") {
        if (GetHasFeat(FEAT_HIDE_IN_PLAIN_SIGHT, oPC)) {
            // Cooldown check.
            if(GetIsTimelocked(oPC, "Ocultarse a Simple Vista"))
            {
                TimelockErrorMessage(oPC, "Ocultarse a Simple Vista");
                NWNX_Events_SkipEvent();
                return;
            }
        }
    }

    else if (sCurrentEvent == "NWNX_ON_STEALTH_EXIT_AFTER") {
        if (GetHasFeat(FEAT_HIDE_IN_PLAIN_SIGHT, oPC)) {
            // HIPS Explorador
            SetTimelock(OBJECT_SELF, 6, "Ocultarse a Simple Vista", 0, 0);
            effect eSlowness = SupernaturalEffect(EffectMovementSpeedIncrease(-50));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlowness, oPC, 4.0);
        }
    }
}

