//::///////////////////////////////////////////////
//:: XP3 Portable Encampment Script
//:: Copyright (c) 2008 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Spawns in an encampment that allows the PC to rest.

*/
//:://////////////////////////////////////////////
//:: Created By:   Peter Thomas
//:: Adapted for core game by: Craig Welburn
//:: Created On:   2008-01-07
//:://////////////////////////////////////////////

#include "x2_inc_switches"

void main()
{
    object oItem = GetItemActivated();
    object oPC = GetItemActivator();
    int nEvent = GetUserDefinedItemEventNumber();
    if ( nEvent == X2_ITEM_EVENT_ACTIVATE )
    {
        // Cannot set camp if in combat
        if (GetIsInCombat(oPC) == FALSE)
        {
            object oCamp = CreateObject(OBJECT_TYPE_PLACEABLE, "qp_camp", GetLocation(oPC));
            DelayCommand(1.0, AssignCommand(oCamp, ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE)));
            DestroyObject(oItem);
        }
    }
    else
    {
        SendMessageToPC(oPC, "You cannot setup camp while in combat!");
    }
}
