void main()
{
  object oPC = GetLastUsedBy();
  string sEtiquetaPuntoRuta = GetTag(OBJECT_SELF) + "a";
  object oPuntoRuta = GetNearestObjectByTag(sEtiquetaPuntoRuta);
  location lPuntoRuta = GetLocation(oPuntoRuta);
  AssignCommand(oPC, ClearAllActions());
  DelayCommand(0.1, AssignCommand(oPC, JumpToLocation(lPuntoRuta)));
}
