void main()
{
  object oPC = GetPCSpeaker();
  object oTarget = GetWaypointByTag("Entrada_Esmeral");

  AssignCommand(oPC, JumpToObject(oTarget));
  TakeGoldFromCreature(100, oPC);
  FloatingTextStringOnCreature("* Los guardias te permiten entrar *", oPC);
}
