void main()
{
  object oPC = GetClickingObject();
  if(!GetIsPC(oPC)) return;

  if(GetItemPossessedBy(oPC, "circuloparamos")!= OBJECT_INVALID)

  {


      object oTarget = GetWaypointByTag("WP_enclavecueva2");
      location lTarget = GetLocation(oTarget);

      if(GetAreaFromLocation(lTarget) == OBJECT_INVALID) return;

      AssignCommand(oPC, ClearAllActions());
      AssignCommand(oPC, ActionJumpToLocation(lTarget));
  }

  else
  {
      FloatingTextStringOnCreature("*No puedes pasar sin pertenecer a este circulo.*", oPC);
  }
}
