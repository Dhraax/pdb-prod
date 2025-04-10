void main()
{
  object oPC = GetPCSpeaker();
  object oTarget = GetWaypointByTag("Entrada_molino");
  AssignCommand(oPC,JumpToObject(oTarget));
}
