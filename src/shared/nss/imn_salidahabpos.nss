void main()
{
  object oPC = GetLastUsedBy();
  object oPuntoRuta = GetNearestObjectByTag("salida_habitacion_posimneskar");
  location lPuntoRuta = GetLocation(oPuntoRuta);
  AssignCommand(oPC, ClearAllActions());
  DelayCommand(0.1, AssignCommand(oPC, JumpToLocation(lPuntoRuta)));
}
