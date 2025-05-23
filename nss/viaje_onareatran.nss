/////////////////////////////////////////////////
// viaje_onareatrans
////////////////////////////////////////////////
/*
Utilizado para áreas de encuentro aleatorio
Se debe poner en el Ubicado o transicion para salir del area de encuentro
*/

void main()
{
    object oPC = GetLastUsedBy();
    string sDestinationWP = GetLocalString(oPC, "sTargetWP");
    string sWaypoint = GetLocalString(oPC, "WAYPOINT");
    string sArea = GetTag(GetArea(oPC));
    object oWaypoint = GetWaypointByTag(sWaypoint);
    location lLocation = GetLocation(oWaypoint);

    //Si ya hemos terminado de combatir, volvemos al transporte
    object oParty = GetFirstFactionMember(oPC, TRUE);
    while(GetIsObjectValid(oParty))
        {
          if(sArea == GetTag(GetArea(oParty)) && !GetIsInCombat(oParty))
           {
            AssignCommand(oParty, ClearAllActions());
            AssignCommand(oParty, ActionJumpToLocation(lLocation));
           }
          else SendMessageToPC(oPC, "¡No puedes huir en medio del combate!");

       oParty = GetNextFactionMember(oPC, TRUE);
        }
}

