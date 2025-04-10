int StartingConditional()
{
  object oPC = GetPCSpeaker();

  int iNivelDruida = GetLevelByClass(CLASS_TYPE_DRUID, oPC);
  int iNivelExplorador = GetLevelByClass(CLASS_TYPE_RANGER, oPC);

  // Restricción basada en la clase
  if(iNivelDruida >= 1 || iNivelExplorador >= 6) return TRUE;

  return FALSE;
}
