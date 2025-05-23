int StartingConditional()
{
  int iIfritiUsado = GetLocalInt(OBJECT_SELF, "IFRITIUSADO");

  if(iIfritiUsado != 1) return TRUE;
  return FALSE;
}
