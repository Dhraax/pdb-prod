void main()
{
  object oPC = GetPCSpeaker();
  object oBarco_Crimm_4 = GetObjectByTag("atk_puerto"); //Athk_Crimm_4

  TakeGoldFromCreature(200, oPC, TRUE);
  AssignCommand(oPC, ClearAllActions());
  AssignCommand(oPC, JumpToObject(oBarco_Crimm_4));
}
