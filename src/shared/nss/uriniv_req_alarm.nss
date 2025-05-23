int StartingConditional()
{
  object oPC = GetPCSpeaker();

  int iNivelBardo = GetLevelByClass(CLASS_TYPE_BARD, oPC);
  int iNivelExplorador = GetLevelByClass(CLASS_TYPE_RANGER, oPC);
  int iNivelMago = GetLevelByClass(CLASS_TYPE_WIZARD, oPC);
  int iNivelHechicero = GetLevelByClass(CLASS_TYPE_SORCERER, oPC);

  // Restricción basada en la clase
  if(iNivelBardo      >= 1 ||
     iNivelExplorador >= 1 ||
     iNivelMago       >= 1 ||
     iNivelHechicero  >= 1) return TRUE;

  return FALSE;
}

