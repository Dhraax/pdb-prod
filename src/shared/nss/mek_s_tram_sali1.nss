void main()
{
object oPC = GetLastUsedBy();

if(!GetIsPC(oPC)) return;

if(GetItemPossessedBy(oPC, "mek_RefugioSalida1")== OBJECT_INVALID)
     {
       return;
     }
else
     {
       object oTarget = GetWaypointByTag("mek_waypointSalidaBajaA");
       location lTarget = GetLocation(oTarget);
       DelayCommand(0.9, AssignCommand(oPC, ClearAllActions()));

DelayCommand(1.0, AssignCommand(oPC, ActionJumpToLocation(lTarget)));

     }
}

