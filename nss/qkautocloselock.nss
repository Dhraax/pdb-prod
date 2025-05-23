#include "mti_libreria"
void main()
{
object oPC = GetLastUsedBy();
location lPuntoDeRuta = GetLocation(GetWaypointByTag("coronadecobre"));

if (!GetIsPC(oPC)) return;

Teletransporte(oPC, lPuntoDeRuta);
}
