//::////////////////////////////////////////////////////////////////////////////
//:: Ray Puzzle
//::////////////////////////////////////////////////////////////////////////////
//::
//:: Place this script in the OnUsed-Slot of a placeable. When used it will
//:: toggle the ray/beam of the specified node.
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
    // Add some delay to prevent repeated use (We need some time to set the
    // beams)
    if (GetLocalInt(OBJECT_SELF, "rapu_leverdelay") == 1)
    {
        SpeakString("Parece que está atascado.");
        return;
    }
    SetLocalInt(OBJECT_SELF, "rapu_leverdelay", 1);
    DelayCommand(3.0, DeleteLocalInt(OBJECT_SELF, "rapu_leverdelay"));


    // Placeable animation
    object oNode = RAPU_GetNode(OBJECT_SELF);
    SpeakString("Escuchas algún tipo de mecanismo.");

    if (GetLocalInt(OBJECT_SELF, "rapu_leverstate") == 1)
    {
        // Turn off
        ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE);

        SetLocalInt(OBJECT_SELF, "rapu_leverstate", 0);

        RAPU_DeactivateAll(oNode);
    }
    else
    {
        // Turn on
        ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);

        SetLocalInt(OBJECT_SELF, "rapu_leverstate", 1);

        RAPU_TurnNode(oNode, 0);
    }
}
