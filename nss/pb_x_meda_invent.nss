int StartingConditional()
{
  object oPC = GetPCSpeaker();

  if(GetItemPossessedBy(oPC, "MedallndeKhauntea") != OBJECT_INVALID &&
     GetCampaignInt("QUESTPURSKUL", "AVANCE", oPC) == 1)
  {
      return TRUE;
  }

  return FALSE;
}
