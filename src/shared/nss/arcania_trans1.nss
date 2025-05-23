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
          object oTarget = GetWaypointByTag("Arcania_secreto1");
          location lTarget = GetLocation(oTarget);

          if(GetAreaFromLocation(lTarget)==OBJECT_INVALID) return;

          ActionPlayAnimation(ANIMATION_PLACEABLE_OPEN);
          DelayCommand(0.9, AssignCommand(oPC, ClearAllActions()));
          DelayCommand(1.0, AssignCommand(oPC, ActionJumpToLocation(lTarget)));
          DelayCommand(4.0, ActionPlayAnimation(ANIMATION_PLACEABLE_CLOSE));
          }
}
