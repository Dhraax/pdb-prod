void main()
{
  object oPC = GetLastUsedBy();
  string sSalida = GetLocalString(OBJECT_SELF, "Salida");
  object oPuntoRuta = GetNearestObjectByTag(sSalida);
  location lPuntoRuta = GetLocation(oPuntoRuta);
  AssignCommand(oPC, ClearAllActions());
  DelayCommand(0.1, AssignCommand(oPC, JumpToLocation(lPuntoRuta)));
}
