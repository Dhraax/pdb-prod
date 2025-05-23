int StartingConditional()
{
    return FALSE;
  object oPC = GetPCSpeaker();
  string sAuthor = GetLocalString(oPC, "PostAuthor");
  string sName = GetName(oPC) + " (" + GetPCPlayerName(oPC) + ")";

  if(sName == sAuthor || GetIsDM(oPC)) return TRUE;
  else return FALSE;
}
