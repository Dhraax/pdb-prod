int StartingConditional()
{
  object oPC = GetPCSpeaker();

  int iNivelDruida = GetLevelByClass(CLASS_TYPE_DRUID, oPC);

  // Restricción basada en la clase
  if(iNivelDruida >= 17) return TRUE;

  return FALSE;
}
