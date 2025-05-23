void main()
{
object oPC = GetLastUsedBy();

if(!GetIsPC(oPC)) return;

       if(GetItemPossessedBy(oPC, "Simboloimperiobanita")== OBJECT_INVALID)
          {
          return;
          }
       else
          {
          object oTarget = GetWaypointByTag("Arcania_secreto2");
          location lTarget = GetLocation(oTarget);

          if(GetAreaFromLocation(lTarget)==OBJECT_INVALID) return;

          DelayCommand(0.9, AssignCommand(oPC, ClearAllActions()));
          DelayCommand(1.0, AssignCommand(oPC, ActionJumpToLocation(lTarget)));
          }
}
