int StartingConditional()
{
  object oPC = GetPCSpeaker();

  int iNivelExplorador = GetLevelByClass(CLASS_TYPE_RANGER, oPC);

  // Restricción basada en la clase
  if(iNivelExplorador >= 6) return TRUE;

  return FALSE;
}
