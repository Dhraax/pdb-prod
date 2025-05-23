int StartingConditional()
{
  object oPC = GetPCSpeaker();
  object oFragmento1 = GetItemPossessedBy(oPC, "quest_ts_simb1");
  object oFragmento2 = GetItemPossessedBy(oPC, "quest_ts_simb2");
  object oFragmento3 = GetItemPossessedBy(oPC, "quest_ts_simb3");

  if(oFragmento1 != OBJECT_INVALID && oFragmento2 != OBJECT_INVALID && oFragmento3 != OBJECT_INVALID)
  {
      return TRUE;
  }

  return FALSE;
}
