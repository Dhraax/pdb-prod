void main()
{
object oPC = GetLastUsedBy();
object oTarget1 = GetWaypointByTag("Legion_selladopuerta1");
object oTarget2 = GetWaypointByTag("Legion_selladopuerta2");
location lTarget1 = GetLocation(oTarget1);
location lTarget2 = GetLocation(oTarget2);

CreateObject(OBJECT_TYPE_PLACEABLE, "x3_plc_cheval", lTarget1,FALSE,"LEGION_selladotemporal1");
CreateObject(OBJECT_TYPE_PLACEABLE, "x3_plc_cheval", lTarget2,FALSE,"LEGION_selladotemporal2");
DelayCommand(1.0, SendMessageToPC(oPC, "*Escuchas un chirrido metalico, indicando que los portones exteriores han sido sellados*."));
}
