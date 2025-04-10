int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int iNivel = GetHitDice(oPC);

  if(iNivel >= 10) return TRUE;

  return FALSE;
}
