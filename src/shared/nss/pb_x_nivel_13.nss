int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int iNivel = GetHitDice(oPC);

  if(iNivel >= 13) return TRUE;

  return FALSE;
}
