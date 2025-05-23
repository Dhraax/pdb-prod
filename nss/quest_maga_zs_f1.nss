void main()
{
  object oPC = GetPCSpeaker();
  SetLocalInt(oPC, "QUEST_MAGA_ZS_FALLO", 1);
  DelayCommand(300.0, DeleteLocalInt(oPC, "QUEST_MAGA_ZS_FALLO"));
}
