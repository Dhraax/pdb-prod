void main()
{
  object oPC = GetPCSpeaker();
  object oTarget = GetNearestObjectByTag("atk_burdel2");
  object oMod = GetModule();

  DeleteLocalInt(oMod, "ATK_BURDELMUJER");

  DelayCommand(0.5, AssignCommand(oPC, ClearAllActions(TRUE)));
  DelayCommand(0.6, AssignCommand(oPC, JumpToObject(oTarget)));
}
