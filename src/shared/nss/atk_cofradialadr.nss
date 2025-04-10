void main()
{
  object oPC = GetClickingObject();
  location lTarget = GetLocation(GetWaypointByTag("atk_ladronesin"));

  if(GetItemPossessedBy(oPC, "pasedelacofradia")!= OBJECT_INVALID)
  {
      SendMessageToPC(oPC, "Bienvenido a la cofradía, contrabandista.");
      AssignCommand(oPC, ClearAllActions());
      AssignCommand(oPC, ActionJumpToLocation(lTarget));
  }
  else
  {
      FloatingTextStringOnCreature("No estoy autorizado a entrar en este lugar", oPC, FALSE);
  }
}
