//::////////////////////////////////////////////////////////////////////////////
//:: inc_rayriddle
//::////////////////////////////////////////////////////////////////////////////
//::
//::////////////////////////////////////////////////////////////////////////////


//::////////////////////////////////////////////////////////////////////////////
//:: Constants
//::////////////////////////////////////////////////////////////////////////////

// Change beam type here. A silent one is recommended unless you want to annoy
// your players ;-)
const int RAPU_BEAM_TYPE = VFX_BEAM_SILENT_COLD;

const int RAPU_BODYNODE = BODY_NODE_CHEST;

const int RAPU_NODE_STATUS_ACTIVE   = 1;
const int RAPU_NODE_STATUS_INACTIVE = 0;

const string RAPU_DUMMYNODE_PREFIX = "rpd_";
const string RAPU_DUMMYNODE_RESREF = "plc_invisobj";

//::////////////////////////////////////////////////////////////////////////////
//:: Local variable names defined as constants for easier refactoring.
//::////////////////////////////////////////////////////////////////////////////

// Variable for Levers. Tag of the node to control. See "rapu_onoff" and
// "rapu_turnray".
const string RAPU_LVAR_CONTROLLEDNODE_TAG = "rapu_ntag";

// Variable for NPCs. NPC can choose the outgoing node directly whithout the
// need to cycle through the successor nodes.
const string RAPU_LVAR_SELECTEDNODE_TAG = "rapu_nselected";

// Variable for nodes. Tag of a door or placeable. Doors will be opened and
// placeables destroyed, when a beam passes through this node.
const string RAPU_LVAR_OBJECTTAG ="rapu_otag";

// Variable for nodes. Current outgoing node.
const string RAPU_LVAR_NODE_OUT = "rapu_nout";

const string RAPU_LVAR_NEIGHBOUR_NODE_LIST = "rapu_nlist";
const string RAPU_LVAR_NUM_CHILDREN        = "rapu_num";

const string RAPU_LVAR_NODE_STATUS = "rapu_nstatus";

const string RAPU_LVAR_RESPAWN_LOCATION = "rapu_resp_loc";
const string RAPU_LVAR_RESPAWN_RESREF   = "rapu_resp_resr";

//::////////////////////////////////////////////////////////////////////////////

// Opens the doors or destroys placeables. Placeables can be brought back by a
// call to RAPU_CloseOrRespawn, IF it exists as a template (resrefs must match)
// - sTargetTag: Target to be opened or destroyed
// - oNode
void RAPU_OpenOrDestroy(string sTargetTag, object oNode = OBJECT_SELF);

// Closes the doors or respawn placeables, previosly opened or destroyed by
// RAPU_OpenOrDestroy. A placeable can be only be respawned, IF it exists as a
// template (resrefs must match)
// - sTargetTag: Target to be closed or respawned.
// - oNode
void RAPU_CloseOrRespawn(string sTargetTag, object oNode = OBJECT_SELF);

void RAPU_TurnNode(object oNodeToTurn, int nDirection);

object RAPU_GetNode(object oTarget);

void RAPU_DeactivateAll(object oCurrentNode);

void RAPU_SetOutNode(object oNode, int nOutNode);

// Destroys all placeables with the given tag. If desired, resref and location
// of the objects can be saved and restored by a call t RAPU_MassRespawnObjects
void RAPU_MassDestroyPlaceable(string sObjectTag,
                               object oDestroyer = OBJECT_SELF,
                               int bRespawnable = FALSE,
                               int bUseDeathEffect = FALSE);

// Respawns objects previously destroyed by RAPU_MassRespawnObjects
void RAPU_MassRespawnPlaceable(string sObjectTag,
                               object oDestroyer = OBJECT_SELF);

//::////////////////////////////////////////////////////////////////////////////


void RAPU_MassDestroyPlaceable(string sObjectTag, object oDestroyer = OBJECT_SELF, int bRespawnable = FALSE, int bUseDeathEffect = FALSE)
{
    int nNth = 0;

    object oTarget = GetNearestObjectByTag(sObjectTag, oDestroyer, nNth);
    if (bRespawnable)
    {
        while (GetIsObjectValid(oTarget))
        {
            SetLocalLocation(oDestroyer, RAPU_LVAR_RESPAWN_LOCATION+IntToString(nNth), GetLocation(oTarget));
            SetLocalString(oDestroyer, RAPU_LVAR_RESPAWN_RESREF+IntToString(nNth), GetResRef(oTarget));


            SetPlotFlag(oTarget, FALSE);
            if (bUseDeathEffect)
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(FALSE, FALSE), oTarget);
            }
            else
            {
                DestroyObject(oTarget);
            }

            nNth++;
            oTarget = GetNearestObjectByTag(sObjectTag, oDestroyer, nNth);
        }
    }
    else
    {
        while (GetIsObjectValid(oTarget))
        {
            SetPlotFlag(oTarget, FALSE);
            DestroyObject(oTarget);

            nNth++;
            oTarget = GetNearestObjectByTag(sObjectTag, oDestroyer, nNth);
        }
    }
}


void RAPU_MassRespawnPlaceable(string sObjectTag, object oDestroyer = OBJECT_SELF)
{
    int nNth = 0;

    location lLocation = GetLocalLocation(oDestroyer, RAPU_LVAR_RESPAWN_LOCATION+IntToString(nNth));
    string   sResRef   = GetLocalString(oDestroyer, RAPU_LVAR_RESPAWN_RESREF+IntToString(nNth));

    while (sResRef != "")
    {
        CreateObject(OBJECT_TYPE_PLACEABLE, sResRef, lLocation, FALSE, sObjectTag);

        DeleteLocalLocation(oDestroyer, RAPU_LVAR_RESPAWN_LOCATION+IntToString(nNth));
        DeleteLocalString(oDestroyer, RAPU_LVAR_RESPAWN_RESREF+IntToString(nNth));

        nNth++;

        lLocation = GetLocalLocation(oDestroyer, RAPU_LVAR_RESPAWN_LOCATION+IntToString(nNth));
        sResRef   = GetLocalString(oDestroyer, RAPU_LVAR_RESPAWN_RESREF+IntToString(nNth));
    }
}

void RAPU_CloseOrRespawn(string sTargetTag, object oNode = OBJECT_SELF)
{
    object oTarget = GetObjectByTag(sTargetTag);
    if (GetIsObjectValid(oTarget))
    {
        SetLocked(oTarget, TRUE);
        AssignCommand(oTarget, ActionPlayAnimation(ANIMATION_DOOR_CLOSE));
    }
    else
    {
        RAPU_MassRespawnPlaceable(sTargetTag, oNode);
    }
}

void RAPU_OpenOrDestroy(string sTargetTag, object oNode = OBJECT_SELF)
{
    object oTarget = GetObjectByTag(sTargetTag);

    switch (GetObjectType(oTarget))
    {
        case OBJECT_TYPE_DOOR:
        {
            SetLocked(oTarget, FALSE);
            AssignCommand(oTarget, ActionPlayAnimation(ANIMATION_DOOR_OPEN1));

            break;
        }
        case OBJECT_TYPE_PLACEABLE:
        {
            RAPU_MassDestroyPlaceable(sTargetTag, oNode, TRUE, TRUE);

            break;
        }
        case OBJECT_TYPE_CREATURE:
        {
            break;
        }
        default:
        {
            break;
        }
    }
}

object RAPU_GetNextNode(object oNode)
{
    string sNextNodeTag = GetLocalString( oNode, RAPU_LVAR_NEIGHBOUR_NODE_LIST+IntToString(GetLocalInt(oNode, RAPU_LVAR_NODE_OUT)) );
    return GetObjectByTag(sNextNodeTag);
}

object RAPU_GetNthNode(object oNode, int nNth)
{
    string sNodeTag = GetLocalString( oNode, RAPU_LVAR_NEIGHBOUR_NODE_LIST+IntToString(nNth) );
    return GetObjectByTag(sNodeTag);
}

object RAPU_GetNodeDummy(object oNode)
{
    return GetObjectByTag(RAPU_DUMMYNODE_PREFIX+GetTag(oNode));
}

object RAPU_CreateNodeDummy(object oNode)
{
    string sNodeDummyTag = RAPU_DUMMYNODE_PREFIX+GetTag(oNode);
    return CreateObject(OBJECT_TYPE_PLACEABLE, RAPU_DUMMYNODE_RESREF, GetLocation(oNode), FALSE, sNodeDummyTag);
}

void RAPU_SetNodeStatus(object oNode, int nStatus)
{
    SetLocalInt(oNode, RAPU_LVAR_NODE_STATUS, nStatus);
}

int RAPU_GetNodeStatus(object oNode)
{
    return GetLocalInt(oNode, RAPU_LVAR_NODE_STATUS);
}

void RAPU_RemoveVisualEffect(object oStartNode, object oEndNode)
{
    object oEndNodeDummy   = RAPU_GetNodeDummy(oEndNode);
    if (GetIsObjectValid(oEndNodeDummy))
        DestroyObject(oEndNodeDummy);
}

void RAPU_CreateVisualEffect(object oStartNode, object oEndNode)
{
    // The VFX is not created direcly between the original nodes, because
    // we would have to use "RemoveEffect" to get rid of them.
    // THIS IS UNRELYABLE ! Sometimes the VFX stays on the object client side.
    // Instead we create dummy nodes and apply the VFX between them. By
    // destroying the dummy nodes we can be sure that the VFX is gone
    // ... almost sure.
    object oStartNodeDummy = RAPU_GetNodeDummy(oStartNode);
    if (oStartNodeDummy == OBJECT_INVALID)
        oStartNodeDummy = RAPU_CreateNodeDummy(oStartNode);

    object oEndNodeDummy   = RAPU_GetNodeDummy(oEndNode);
    if (oEndNodeDummy == OBJECT_INVALID)
        oEndNodeDummy = RAPU_CreateNodeDummy(oEndNode);


    effect eBeam = EffectBeam(RAPU_BEAM_TYPE, oStartNodeDummy, RAPU_BODYNODE);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBeam, oEndNodeDummy);
}

void RAPU_PropagateActivate(object oCurrentNode)
{
    // Open door, destroy placeables
    string sObjectTag = GetLocalString(oCurrentNode, RAPU_LVAR_OBJECTTAG);
    if (sObjectTag != "")
    {
        RAPU_OpenOrDestroy(sObjectTag, oCurrentNode);
    }

    object oNextNode = RAPU_GetNextNode(oCurrentNode);
    if (GetIsObjectValid(oNextNode))
    {
        // SendMessageToPC(GetFirstPC(), "+++ " + GetTag(oCurrentNode) + ": Activating next node (" + GetTag(oNextNode) + ")");

        RAPU_CreateVisualEffect(oCurrentNode, oNextNode);

        RAPU_SetNodeStatus(oCurrentNode, RAPU_NODE_STATUS_ACTIVE);
        RAPU_PropagateActivate(oNextNode);
    }
}

void RAPU_PropagateDeactivate(object oCurrentNode)
{
    // Close door, respawn placeables
    string sObjectTag = GetLocalString(oCurrentNode, RAPU_LVAR_OBJECTTAG);
    if (sObjectTag != "")
    {
        RAPU_CloseOrRespawn(sObjectTag, oCurrentNode);
    }

    object oNextNode = RAPU_GetNextNode(oCurrentNode);
    if (GetIsObjectValid(oNextNode))
    {
        // SendMessageToPC(GetFirstPC(), "--- " + GetTag(oCurrentNode) + ": Deaktiviere naechsten Knoten (" + GetTag(oNextNode) + ")");

        RAPU_RemoveVisualEffect(oCurrentNode, oNextNode);

        RAPU_SetNodeStatus(oNextNode, RAPU_NODE_STATUS_INACTIVE);
        RAPU_PropagateDeactivate(oNextNode);
    }
}

//::////////////////////////////////////////////////////////////////////////////
//::
//::////////////////////////////////////////////////////////////////////////////

void RAPU_DeactivateAll(object oCurrentNode)
{
    // Tuer
    string sObjectTag = GetLocalString(oCurrentNode, RAPU_LVAR_OBJECTTAG);
    if (sObjectTag != "")
    {
        RAPU_CloseOrRespawn(sObjectTag, oCurrentNode);
    }

    // Number of children
    int nNumChildren = GetLocalInt(oCurrentNode, RAPU_LVAR_NUM_CHILDREN);

    object oNextNode;
    int i;
    for (i=0; i<nNumChildren; i++)
    {
        oNextNode = RAPU_GetNthNode(oCurrentNode, i);

        if (GetIsObjectValid(oNextNode))
        {
            // SendMessageToPC(GetFirstPC(), "||| " + GetTag(oCurrentNode) + ": Deaktiviere naechsten Knoten (" + GetTag(oNextNode) + ")");

            RAPU_RemoveVisualEffect(oCurrentNode, oNextNode);
            RAPU_SetNodeStatus(oNextNode, RAPU_NODE_STATUS_INACTIVE);
            RAPU_DeactivateAll(oNextNode);
        }
    }
}

object RAPU_GetNode(object oTarget)
{
    return GetObjectByTag(GetLocalString(oTarget, RAPU_LVAR_CONTROLLEDNODE_TAG));
}

void RAPU_TurnNode(object oNodeToTurn, int nDirection)
{
    // Old destination node/ outgoing vertex
    int nCurrentNodeOut = GetLocalInt(oNodeToTurn, RAPU_LVAR_NODE_OUT);

    // New destination node/ outgoing vertex
    int nNewNodeOut;

    // Number of children
    int nNumChildren = GetLocalInt(oNodeToTurn, RAPU_LVAR_NUM_CHILDREN);

    // ...
    object oNode;
    int    nNodeStatus = RAPU_GetNodeStatus(oNodeToTurn);

    // Deactivate beam to old nodes, before activating new beams.
    if (nNodeStatus == RAPU_NODE_STATUS_ACTIVE)
    {
        RAPU_PropagateDeactivate(oNodeToTurn);
        // SendMessageToPC(GetFirstPC(),  "### Deactivation complete ###");
    }

    // Get the new destination node/outgoing vertex
    if (nDirection == 1)
    {
        nNewNodeOut  = nCurrentNodeOut+1;
        if (nNewNodeOut >= nNumChildren)
            nNewNodeOut = 0;

        // Save the new node on the current node.
        SetLocalInt(oNodeToTurn, RAPU_LVAR_NODE_OUT, nNewNodeOut);
    }
    else if (nDirection == -1)
    {
        nNewNodeOut  = nCurrentNodeOut-1;
        if (nNewNodeOut < 0)
            nNewNodeOut = nNumChildren-1;

        // Save the new node on the current node.
        SetLocalInt(oNodeToTurn, RAPU_LVAR_NODE_OUT, nNewNodeOut);
    }
    else
    {
        // Only activate this one.
        RAPU_SetNodeStatus(oNode, RAPU_NODE_STATUS_ACTIVE);
        nNodeStatus = RAPU_NODE_STATUS_ACTIVE ;
    }

    // Activate beams to new destination node/outgoing vertex and all
    // succeeding nodes.
    if (nNodeStatus == RAPU_NODE_STATUS_ACTIVE)
    {
        RAPU_PropagateActivate(oNodeToTurn);
        // SendMessageToPC(GetFirstPC(),  "### Activation complete ###");
    }
}

void RAPU_SetOutNode(object oNode, int nOutNode)
{
    int nNodeStatus    = RAPU_GetNodeStatus(oNode);
    int nNumNeighbours = GetLocalInt(oNode, RAPU_LVAR_NUM_CHILDREN);

    if (nNodeStatus == RAPU_NODE_STATUS_ACTIVE)
    {
        RAPU_PropagateDeactivate(oNode);
        // SendMessageToPC(GetFirstPC(),  "### Deactivation complete ###");
    }

    if ((nOutNode < nNumNeighbours) && (nOutNode >= 0))
        SetLocalInt(oNode, RAPU_LVAR_NODE_OUT, nOutNode);

    // Activate beams to new destination node/outgoing vertex and all
    // succeeding nodes.
    if (nNodeStatus == RAPU_NODE_STATUS_ACTIVE)
    {
        RAPU_PropagateActivate(oNode);
        // SendMessageToPC(GetFirstPC(),  "### Activation complete ###");
    }
}

