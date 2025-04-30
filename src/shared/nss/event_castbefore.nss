/////////////////////////////////////////////////////////
//
// SYSTEM: NWNX_ON_CAST_SPELL_BEFORE
//
// Name: event_castbefore
//
// Desc: 
//
// Author: Dhraax - 20250430
//
/////////////////////////////////////////////////////////

#include "nwnx_events"
#include "nwnx"

void HandleImmuneMagicCheck(object oCaster, object oTarget)
{
    string sTargetTag = GetTag(oTarget);
    string sCasterName = GetName(oCaster);

    int iImmune = GetLocalInt(oTarget, "IMMUNE_MAGIC");

    if (iImmune == TRUE)
    {
        if (GetIsPC(oCaster))
        {
            SendMessageToPC(oCaster, "<c´$$>El hechizo no produce ningún efecto, la criatura parece inmune a la magia.</c>");
        }

        NWNX_Events_SkipEvent();
    }
}

void main()
{
    string sCurrentEvent = NWNX_Events_GetCurrentEvent();
    object oCaster = OBJECT_SELF;
    object oTarget = StringToObject(NWNX_Events_GetEventData("TARGET_OBJECT_ID"));
    object oItem = StringToObject(NWNX_Events_GetEventData("ITEM_OBJECT_ID"));
    int iSpell = StringToInt(NWNX_Events_GetEventData("SPELL_ID"));

    HandleImmuneMagicCheck(oCaster, oTarget);

}
