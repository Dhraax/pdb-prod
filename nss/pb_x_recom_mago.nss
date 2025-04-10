void main()
{
  GiveGoldToCreature(GetPCSpeaker(), 2500);
  GiveXPToCreature(GetPCSpeaker(), 2000);
  CreateItemOnObject("cetro_revivir", GetPCSpeaker(), 1);

  SetCampaignInt("QUESTAMNAGUATORRE", "AVANCE", 2, GetPCSpeaker());
}
