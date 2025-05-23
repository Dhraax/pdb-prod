#include "mti_libreria"
void main()
{
object oPC = GetLastUsedBy();
object oTarget = GetWaypointByTag("salir_aguj_oro");
location lTarget = GetLocation(oTarget);

Teletransporte(oPC, lTarget);
}
