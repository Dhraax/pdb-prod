 int StartingConditional()
{
  object oPC = GetPCSpeaker();

  int iNivelMago = GetLevelByClass(CLASS_TYPE_WIZARD, oPC);
  int iNivelHechicero = GetLevelByClass(CLASS_TYPE_SORCERER, oPC);

  // Restricción basada en la clase
  if(iNivelMago >= 15 || iNivelHechicero > 15 ) return TRUE;

  return FALSE;
}
