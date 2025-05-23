void main()
{
  object oPC = GetPCSpeaker();
  string sSerie = GetLocalString(oPC, "SEGSERIE");

  SetLocalString(oPC, "SEGSERIE", sSerie + "4");
}
