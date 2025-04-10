int StartingConditional()
{
  if(GetCampaignInt("QUESTPURSKUL", "AVANCE", GetPCSpeaker()) == 3) return TRUE;

  return FALSE;
}
