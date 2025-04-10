void main()
{
  object oPC = GetClickingObject();
  location lTarget = GetLocation(GetWaypointByTag("atk_arpista"));

  if(GetItemPossessedBy(oPC, "selloarpista")!= OBJECT_INVALID)
  {
      SendMessageToPC(oPC, "Bienvenido a la cofradía, Arpista.");
      AssignCommand(oPC, ClearAllActions());
      AssignCommand(oPC, ActionJumpToLocation(lTarget));
  }
  else
  {
      FloatingTextStringOnCreature("No estoy autorizado a entrar en este lugar", oPC, FALSE);
  }
}
