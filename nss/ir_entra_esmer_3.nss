void main()
{
  object oPC = GetPCSpeaker();
  object oTarget = GetNearestObjectByTag("Entrada_Esmeral");

  AssignCommand(oPC, JumpToObject(oTarget));
  TakeGoldFromCreature(150, oPC);
  FloatingTextStringOnCreature("* Los guardias te permiten entrar en Esmeltaran *", oPC);
}
