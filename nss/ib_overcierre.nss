void main()
{
object oPC = GetLastUsedBy();

object oTarget1 = GetWaypointByTag("WP_ko_skaug_palacio_sede");
object oTarget2 = GetWaypointByTag("WP_ko_skaug_sede_cierreportal");
location lTarget1 = GetLocation(oTarget1);
location lTarget2 = GetLocation(oTarget2);
CreateObject(OBJECT_TYPE_PLACEABLE, "x0_obelisk", lTarget1,FALSE,"IB_selladotemporal");
CreateObject(OBJECT_TYPE_PLACEABLE, "x0_obelisk", lTarget2,FALSE,"IB_selladotemporal");
FloatingTextStringOnCreature("Activado cierre de emergencia",oPC,FALSE);
}
