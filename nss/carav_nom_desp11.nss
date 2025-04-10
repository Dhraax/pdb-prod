#include "mti_libreria"

void main()
{
object oPC = GetLastSpeaker();


object punto1 = GetWaypointByTag("Salto_darsidian3");
location lTarget1 = GetLocation(punto1);

object punto2 = GetWaypointByTag("Quest_Darsidian_cuerpo_noquest");
location lTarget2 = GetLocation(punto2);

object punto3 = GetWaypointByTag("Quest_Darsidian_mujer_noquest");
location lTarget3 = GetLocation(punto3);

object punto4 = GetWaypointByTag("Salto_darsidian2");
location lTarget4 = GetLocation(punto4);

object punto5 = GetWaypointByTag("Quest_Darsidian_mujer");
location lTarget5 = GetLocation(punto5);


object darsi = GetObjectByTag("pnj_carintDarsidian"); //uri_darsidian
object chica = GetObjectByTag("pnj_carintRaissa");//Carav_verdaderaRaissa
object otrodes = GetObjectByTag("pnj_carintRaissa2");//Raissa


string criatura1 = "DarsidianMoor";
string criatura2 = "Danzantedelapiel";

effect eEfectos = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfectos, darsi);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfectos, otrodes);


AssignCommand(darsi,ActionJumpToLocation(lTarget1));
AssignCommand(chica,ActionJumpToLocation(lTarget2));
AssignCommand(otrodes,ActionJumpToLocation(lTarget3));

object sorpresa1 = CreateObject(OBJECT_TYPE_CREATURE, criatura1, lTarget4 ,FALSE);
object sorpresa2 = CreateObject(OBJECT_TYPE_CREATURE, criatura2, lTarget5 ,FALSE);

}
