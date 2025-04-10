void main()
{
  object oPC = GetPCSpeaker();
  string sSerie = GetLocalString(oPC, "FDRUIDASSERIE");

  SetLocalString(oPC, "FDRUIDASSERIE", sSerie + "150");

  ExecuteScript("fdruidas_exe", oPC);
}
