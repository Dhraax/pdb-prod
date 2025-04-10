void main()
{
  object oPC = GetPCSpeaker();
  string sSerie = GetLocalString(oPC, "CONVSERIE");

  SetLocalString(oPC, "CONVSERIE", sSerie + "140");

  ExecuteScript("conv_exe", oPC);
}
