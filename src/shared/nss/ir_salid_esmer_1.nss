void main()
{
  object oPC = GetPCSpeaker();
  object oTarget = GetWaypointByTag("Salida_Esmeral");
  AssignCommand(oPC, JumpToObject(oTarget));
  FloatingTextStringOnCreature("* Los guardias te permiten la salida *", oPC);
}
