int StartingConditional()
{
  int iVariableEspejo = GetLocalInt(OBJECT_SELF, "UBICADOACTIVADO");

  if(iVariableEspejo == TRUE) return TRUE;

  return FALSE;
}
