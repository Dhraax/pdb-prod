int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int iNivel = GetHitDice(oPC);

  if(iNivel >= 14) return TRUE;

  return FALSE;
}
