int StartingConditional()
{
  if(GetLocalInt(GetPCSpeaker(), "PUESTO_VENTA_SPAM") == TRUE) return TRUE;

  return FALSE;
}
