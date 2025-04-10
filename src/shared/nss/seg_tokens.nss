int StartingConditional()
{
  object oPC = GetPCSpeaker();
  string sSerieContrasenya = GetLocalString(oPC, "SEGSERIE");

  SetCustomToken(1000, sSerieContrasenya);

  return TRUE;
}
