int StartingConditional()
{
  object oPC = GetPCSpeaker();
  object oPieles = GetFirstItemInInventory(oPC);
  int iContadoPieles = 0;

  while(GetIsObjectValid(oPieles) == TRUE && iContadoPieles < 5)
  {
      if(GetTag(oPieles) == "pieldeloboinvern") iContadoPieles++;
      oPieles = GetNextItemInInventory(oPC);
  }

  if(iContadoPieles == 5) return TRUE;
  else return FALSE;
}
