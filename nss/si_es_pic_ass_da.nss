int StartingConditional()
{
  // Restricción basada en la clase de personaje
  int iPassed = 0;

  if(GetLevelByClass(CLASS_TYPE_ASSASSIN, GetPCSpeaker()) >= 1)
  iPassed = 1;

  if((iPassed == 0) && (GetLevelByClass(CLASS_TYPE_SHADOWDANCER, GetPCSpeaker()) >= 1))
  iPassed = 1;

  if((iPassed == 0) && (GetLevelByClass(CLASS_TYPE_ROGUE, GetPCSpeaker()) >= 1))
  iPassed = 1;

  if(iPassed == 0)  return FALSE;
  return TRUE;
}
