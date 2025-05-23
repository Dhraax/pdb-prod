void main()
{
  object oPC = GetPCSpeaker();

  SetCampaignInt("QUESTCAMINOORCO", "AVANCE", 5, oPC);
  CreateItemOnObject("montolioscloak", oPC);
  SetXP(oPC, GetXP(oPC) + 2000);
}
