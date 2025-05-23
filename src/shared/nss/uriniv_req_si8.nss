int StartingConditional()
{
  object oPC = GetPCSpeaker();

  int iNivelClerigo = GetLevelByClass(CLASS_TYPE_CLERIC, oPC);

  // Restricción basada en la clase
  if(iNivelClerigo >= 9) return TRUE;

  return FALSE;
}
