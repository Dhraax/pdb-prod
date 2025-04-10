int StartingConditional()
{
  object oPC = GetPCSpeaker();

  int iNivelClerigo = GetLevelByClass(CLASS_TYPE_CLERIC, oPC);

  // Restricción basada en la clase
  if(iNivelClerigo >= 5) return TRUE;

  return FALSE;
}
