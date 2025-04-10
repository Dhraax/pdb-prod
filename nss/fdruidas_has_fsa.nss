int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int iTipoPolimorfacion = GetLocalInt(oPC, "TIPO_POLIMORFACION");

  if(iTipoPolimorfacion == 1)
  {
      DeleteLocalString(oPC, "FDRUIDASSERIE");
      return TRUE;
  }

  return FALSE;
}
