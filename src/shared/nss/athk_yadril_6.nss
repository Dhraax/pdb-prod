void main()
{
  object oPC = GetPCSpeaker();

  SetLocalInt(oPC, "YADRIL_NO_NO", 1);
  DelayCommand(300.0, DeleteLocalInt(oPC,"YADRIL_NO_NO"));
}
