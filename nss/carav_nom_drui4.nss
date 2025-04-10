void main()
{
object oPC = GetLastSpeaker();
object druida = GetObjectByTag("pb_carintdruida");//druida_corrupto_caravassar_nohos  //pnj_carintDruidaAsolador
string criatura1 = "druida_corrupto_caravassar";
object punto1 = GetWaypointByTag("Quest_caravasar_archidruida2");
object punto2 = GetWaypointByTag("Quest_caravasar_archidruida3");
location lTarget1 = GetLocation(punto1);
location lTarget2 = GetLocation(punto2);
effect eEfectos = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);

ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfectos, druida);
//AssignCommand(druida,ActionJumpToLocation(lTarget2));
DestroyObject(druida, 0.5);
FloatingTextStringOnCreature("Finalmente el asolador impio rompe su conexion del nodo y se mueve hacia ti dispuesto a aniquilarte con su vil poder",oPC,FALSE);
object sorpresa = CreateObject(OBJECT_TYPE_CREATURE, criatura1, lTarget1 ,FALSE);

}
