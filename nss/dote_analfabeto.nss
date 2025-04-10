int StartingConditional()
{
  object oPC = GetPCSpeaker();

  // Bono dote soltura hablar un idioma
  int iBonoSolturaIdioma = 0;
  if(GetHasFeat(1245, oPC)) iBonoSolturaIdioma = 10;      // Soltura epica
  else if(GetHasFeat(1233, oPC)) iBonoSolturaIdioma = 3;  // Soltura normal

  if(GetHasFeat(1324, oPC) &&
     GetClassByPosition(2, oPC) == CLASS_TYPE_INVALID &&
     GetClassByPosition(3, oPC) == CLASS_TYPE_INVALID &&
     (GetSkillRank(34, oPC, TRUE) + iBonoSolturaIdioma) < 2) return TRUE;

  return FALSE;
}
