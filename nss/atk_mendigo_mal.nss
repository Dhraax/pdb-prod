void main()
{
  object oPC = GetPCSpeaker();

  SetLocalInt(OBJECT_SELF, "ATKMENDIGO", 2);
  DelayCommand(1000.0, DeleteLocalInt(OBJECT_SELF, "ATKMENDIGO"));
}
