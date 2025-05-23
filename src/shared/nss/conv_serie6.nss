void main()
{
  object oPC = GetPCSpeaker();
  string sSerie = GetLocalString(oPC, "CONVSERIE");

  SetLocalString(oPC, "CONVSERIE", sSerie + "6");

  ExecuteScript("conv_exe", oPC);
}
