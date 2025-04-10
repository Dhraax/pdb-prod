#include "mti_libreria"
void main()
{
object oPC = GetPCSpeaker();

object punto1 = GetWaypointByTag("Salto_darsidian2");
location lTarget1 = GetLocation(punto1);

object punto2 = GetWaypointByTag("Quest_Darsidian_cuerpo");
location lTarget2 = GetLocation(punto2);

object punto3 = GetWaypointByTag("Quest_Darsidian_mujer");
location lTarget3 = GetLocation(punto3);


object darsi = GetObjectByTag("pnj_carintDarsidian"); //uri_darsidian
object chica = GetObjectByTag("pnj_carintRaissa"); //Carav_verdaderaRaissa
object otrodes = GetObjectByTag("pnj_carintRaissa2"); //Raissa

GuardarIntPersistente(oPC,"DESPELLEJADOR_CARAVASSAR",2);
AssignCommand(darsi,ActionJumpToLocation(lTarget1));
AssignCommand(chica,ActionJumpToLocation(lTarget2));
AssignCommand(otrodes,ActionJumpToLocation(lTarget3));
AssignCommand(chica,ActionPlayAnimation(ANIMATION_LOOPING_DEAD_BACK,1.0));
}
