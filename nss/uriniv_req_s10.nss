int StartingConditional()
{
  object oPC = GetPCSpeaker();

  int iNivelMago = GetLevelByClass(CLASS_TYPE_WIZARD, oPC);
  int iNivelML = GetLevelByClass(CLASS_TYPE_PALEMASTER, oPC);
  int iNivelHechicero = GetLevelByClass(CLASS_TYPE_SORCERER, oPC);

  // Restricción basada en la clase
  if(iNivelMago + iNivelML >= 9 ||
     iNivelHechicero >= 10) return TRUE;

  return FALSE;
}
