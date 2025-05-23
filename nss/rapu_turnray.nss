//::////////////////////////////////////////////////////////////////////////////
//:: Ray Puzzle
//::////////////////////////////////////////////////////////////////////////////
//::
//:: Place this script in the OnUsed-Slot of a placeable. When used it will set
//:: the ray/beam to the next available node in the node list. If there are no
//:: more nodes available, the beam will be set to the first node in the list.
//::
//:: Variables:
//::
//:: Name:         Type:        Value:
//:: rapu_ntag     string       Tag of the node to be turned
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
    DelayCommand(5.0, DeleteLocalInt(OBJECT_SELF, "rapu_leverdelay"));


    // Placeable animation
    if (GetLocalInt(OBJECT_SELF, "rapu_leverstate") == 1)
    {
        ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE);

        SetLocalInt(OBJECT_SELF, "rapu_leverstate", 0);
    }
    else
    {
        ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);

        SetLocalInt(OBJECT_SELF, "rapu_leverstate", 1);
    }


    // Se the beam to the next node.
    object oNode = RAPU_GetNode(OBJECT_SELF);
    object oUser = GetLastUsedBy();
    // Check if a PC is using the placeable
    if  (GetIsPC(oUser) || GetIsDM(oUser))
    {
        // Set to the next available node
        RAPU_TurnNode(oNode, 1);
    }
    else
    {
        // NPCs may select the node directly depending on a variable
        // on the NPC itself.
        int nSelectedNode = GetLocalInt(oUser, RAPU_LVAR_SELECTEDNODE_TAG);
        RAPU_SetOutNode(oNode, nSelectedNode);
    }
    SpeakString("Escuchas algún tipo de mecanismo.");
}
