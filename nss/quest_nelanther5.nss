int StartingConditional()
{
  object oPC = GetPCSpeaker();

  if(GetIsObjectValid(GetItemPossessedBy(oPC, "grantrozodelkrak")) == TRUE)
     {
     return TRUE;
     }
  return FALSE;
}
