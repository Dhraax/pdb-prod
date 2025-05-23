int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int iNivelMaestroLividez = GetLevelByClass(CLASS_TYPE_PALEMASTER, oPC);
  int iNivelOrcus = GetLevelByClass(47, oPC);

  if(iNivelMaestroLividez >= 6) return TRUE;
  if(iNivelOrcus >= 6) return TRUE;

  return FALSE;
}
