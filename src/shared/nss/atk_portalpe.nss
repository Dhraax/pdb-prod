#include "mti_libreria"
void main()
{
  object oPC = GetLastUsedBy();
  location lPuntoDeRuta = GetLocation(GetWaypointByTag("planodelasombra"));

  if(GetHitDice(oPC) >= 11)
  {
      Teletransporte(oPC, lPuntoDeRuta);
  }
  else
  {
      SendMessageToPC(oPC, "* Percibes un gran poder al otro lado del portal y aún no te sientes preparado para ello *");
  }
}
