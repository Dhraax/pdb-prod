void main()
{
  object oPC = GetPCSpeaker();
  object oBarco_Crimm_1 = GetObjectByTag("crimmor"); //Athk_Crimm_1

  TakeGoldFromCreature(200, oPC, TRUE);
  AssignCommand(oPC, ClearAllActions());
  AssignCommand(oPC, JumpToObject(oBarco_Crimm_1));
}
