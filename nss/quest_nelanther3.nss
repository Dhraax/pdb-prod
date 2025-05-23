int StartingConditional()
{
  object oPC = GetPCSpeaker();

  int nivel1 = GetLevelByPosition(1, oPC);
  int nivel2 = GetLevelByPosition(2, oPC);
  int nivel3 = GetLevelByPosition(3, oPC);
  int total = nivel1 + nivel2 + nivel3;

  if(total >=15) return TRUE;
  return FALSE;
}
