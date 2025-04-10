int StartingConditional()
{
  object oPC = GetPCSpeaker();

  int iNivelBardo = GetLevelByClass(CLASS_TYPE_BARD, oPC);

  // Restricción basada en la clase
  if(iNivelBardo >= 3) return TRUE;

  return FALSE;
}
