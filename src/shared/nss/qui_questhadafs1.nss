void main()
{
  object oPC = GetPCSpeaker();
  SetLocalInt(OBJECT_SELF, "LITHQUESTHADAFS" + GetName(oPC, TRUE), TRUE);
  DelayCommand(30.0, DeleteLocalInt(OBJECT_SELF, "LITHQUESTHADAFS" + GetName(oPC, TRUE)));
}
