//
//event_skills
//

#include "nwnx_events"
#include "x0_i0_match"

void main()
{
    string sCurrentEvent = NWNX_Events_GetCurrentEvent();
    int iSkill = StringToInt(NWNX_Events_GetEventData("SKILL_ID"));

    if (sCurrentEvent == "NWNX_ON_USE_SKILL_BEFORE") {
        if (iSkill == SKILL_TAUNT && GetIsPC(OBJECT_SELF)) {
            NWNX_Events_SkipEvent();
            SendMessageToPC(OBJECT_SELF, "No se puede utilizar esta habilidad.");
        }
        else if (iSkill == SKILL_ANIMAL_EMPATHY) {
            object oTarget = StringToObject(NWNX_Events_GetEventData("TARGET_OBJECT_ID"));

            if (GetIsObjectValid(oTarget) && GetHasEffect(EFFECT_TYPE_POLYMORPH, oTarget)) {
                NWNX_Events_SkipEvent();
                SendMessageToPC(OBJECT_SELF, "No se pueden empatizar criaturas polimorfadas.");
            }
        }
    }
}
