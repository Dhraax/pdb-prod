void main()
{
  object oPC = GetLastUsedBy();

  if(GetItemPossessedBy(oPC, "selloarpista")== OBJECT_INVALID)
  {
      SendMessageToPC(oPC, "La trampilla no se puede abrir.");
      return;
  }

  else
  {
      object oTarget = GetWaypointByTag("WP_out_sedearpista_in");
      location lTarget = GetLocation(oTarget);

      if(GetAreaFromLocation(lTarget)==OBJECT_INVALID) return;

      DelayCommand(2.9, AssignCommand(oPC, ClearAllActions()));
      DelayCommand(3.0, AssignCommand(oPC, ActionJumpToLocation(lTarget)));

      FloatingTextStringOnCreature("La trampilla se puede abrir.", oPC);
  }
}
