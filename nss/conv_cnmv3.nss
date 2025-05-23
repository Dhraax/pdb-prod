int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int iNivelMaestroLividez = GetLevelByClass(CLASS_TYPE_PALEMASTER, oPC);
  int iNivelOrcus = GetLevelByClass(47, oPC);

  if(iNivelMaestroLividez >= 8) return TRUE;
  if(iNivelOrcus >= 8) return TRUE;

  return FALSE;
}
