// Ir a un punto de ruta indicado en una variable de conversación

void main()
{
    object oPC = GetPCSpeaker();
    string sWaypoint = GetScriptParam("WAYPOINT");

    location lTargetLocation = GetLocation(GetWaypointByTag(sWaypoint));
    DelayCommand(0.9, AssignCommand(oPC, ClearAllActions()));
    DelayCommand(1.0, AssignCommand(oPC, ActionJumpToLocation(lTargetLocation)));
}

