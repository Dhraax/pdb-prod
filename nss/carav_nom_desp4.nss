#include "mti_libreria"
void main()
{
object oPC = GetPCSpeaker();
object punto1 = GetWaypointByTag("Salto_darsidian1");
location lTarget1 = GetLocation(punto1);
object darsi = GetObjectByTag("pnj_carintDarsidian"); //uri_darsidian

GuardarIntPersistente(oPC,"DESPELLEJADOR_CARAVASSAR",1);
GuardarIntPersistente(oPC,"HABLACONTIRIS",2);
AssignCommand(darsi,ActionJumpToLocation(lTarget1));

}
