//::///////////////////////////////////////////////
//:: tk_detector_ent
//:://////////////////////////////////////////////
/*
    The OnEnter handler for a detector -- an area
    of effect that will respond to approaching creatures.
*/
//:://////////////////////////////////////////////
//:: Created by: The Krit
//:: Created on: October 24, 2007
//:://////////////////////////////////////////////


#include "tk_detector_inc"


void main()
{
    // Only react if the one entering is a living (non-DM) enemy.
    object oIntruder = GetEnteringObject();
    if ( GetIsEnemy(oIntruder)  &&  !GetIsDead(oIntruder)  &&
         !GetIsDM(oIntruder)    &&  !GetLocalInt(OBJECT_SELF, "DID_ONENTER_ONCE") )
    {
        // Prevent double firings.
        SetLocalInt(OBJECT_SELF, "DID_ONENTER_ONCE", TRUE);

        // Locate the associated object, and turn over processing to it.
        ExecuteScript(GetLocalString(OBJECT_SELF, TK_DETECTOR_SCRIPT),
                      GetLocalObject(OBJECT_SELF, TK_DETECTOR_EXECUTER));

        // Destroy the detector.
        DestroyObject(OBJECT_SELF);
    }
}

