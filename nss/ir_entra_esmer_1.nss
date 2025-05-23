void main()
{
  object oPC = GetPCSpeaker();
  object oTarget = GetWaypointByTag("Entrada_Esmeral");

  AssignCommand(oPC, JumpToObject(oTarget));
  TakeGoldFromCreature(250, oPC);
  FloatingTextStringOnCreature("* Los guardias te permiten entrar *", oPC);
}