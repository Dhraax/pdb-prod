//::////////////////////////////////////////////////////////////////////////////
//:: Ray Puzzle
//::////////////////////////////////////////////////////////////////////////////
//::
//:: Place this script in the OnEnter-Slot of a trigger. When used it will
//:: make the barrier disappear for small amount of time.
//:: Useful when a PC wants to pass the barrier from the other side.
//::
//:: Variables:
//::
//:: Name:            Type:        Value:
//:: rapu_ntag        string       Tag of the node to be controlled
//::
//::////////////////////////////////////////////////////////////////////////////

#include "rapu_include"

void main()
{
    object oEnteringObject = GetEnteringObject();
    object oTrigger        = OBJECT_SELF;

    string sTargetObjectTag = GetLocalString(oTrigger, RAPU_LVAR_OBJECTTAG);

    if (GetIsObjectValid(GetObjectByTag(sTargetObjectTag)))
    {
        RAPU_MassDestroyPlaceable(sTargetObjectTag, oTrigger, TRUE);

        DelayCommand(60.0f, RAPU_MassRespawnPlaceable(sTargetObjectTag, oTrigger));
    }
}
