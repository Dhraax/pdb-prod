int StartingConditional()
{
  object oPC = GetPCSpeaker();

  // Restricción basada en la clase de personaje
  if((GetHitDice(oPC) >= 21) ||
(GetIsDM(GetLastSpeaker())))
  return TRUE;
  return FALSE;
}
