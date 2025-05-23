void main()
{
  object oPC = GetLastOpenedBy();
  string sNombreJugador = GetName(oPC, TRUE);

  SetLocalString(OBJECT_SELF, "BANCOOCUPADO", sNombreJugador);
}
