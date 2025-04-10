//::///////////////////////////////////////////////
//:: Trapporium Trigger OnDiarm Event
//:: q1_Trap_Disarm.nss
//:://////////////////////////////////////////////
/*
    Place this script in a trapporium trap trigger's, placeable's, or door's
    OnDisarm event.
*/
//:://////////////////////////////////////////////
//:: Created By: Lacero
//:: Created On:
//:://////////////////////////////////////////////
#include "q_inc_switches"
#include "q_inc_simplexp"

void main()
{
    object oPC = GetLastDisarmed();
    object oAOE;
    object oPlcbl = GetLocalObject(OBJECT_SELF,"TRP_PLCBL_OBJ");

    oAOE = GetNearestObject(OBJECT_TYPE_AREA_OF_EFFECT,oPlcbl);
    if(GetAreaOfEffectCreator(oAOE)==OBJECT_SELF)
    {
        DestroyObject(oAOE);
    }

    if(GetIsObjectValid(oPlcbl))
    {
        AssignCommand(oPlcbl, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));
        if(GetTag(oPlcbl)=="RazorWire")
            DestroyObject(oPlcbl);
    }

    DeleteLocalInt(OBJECT_SELF,"TRP_PLCBL_SHOW");
    DeleteLocalObject(OBJECT_SELF,"TRP_PLCBL_OBJ");
    DeleteLocalLocation(OBJECT_SELF,"TRP_PLCBL_LOC");

    //--------------------------------------------------------------------------
    // Q - Check for ScrewTape's SimpleXP
    //
    // Awards the PC some XP based upon the CR of the trap - the value assigned
    // to the integer variable "TRAP_CR" and stored on the trap trigger or
    // object. According to the DMG, the XP award is divided between the rogue
    // who disarmed the trap and his entire party.

    if (GetModuleSwitchValue(MODULE_SWITCH_SIMPLE_XP_ENABLED) == TRUE)
    {
        if (GetIsObjectValid(oPC))
            AwardXP(oPC);
    }
}
