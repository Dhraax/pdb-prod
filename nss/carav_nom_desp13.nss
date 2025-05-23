#include "mti_libreria"

void main()
{
object oPC = GetPCSpeaker();
object punto1 = GetWaypointByTag("Salto_darsidian3");
location lTarget1 = GetLocation(punto1);
object punto3 = GetWaypointByTag("Quest_Darsidian_mujer_noquest");
location lTarget3 = GetLocation(punto3);
object darsi = GetObjectByTag("pnj_carintDarsidian");//uri_darsidian
object otrodes = GetObjectByTag("pnj_carintRaissa2");//Raissa

AssignCommand(darsi,ActionJumpToLocation(lTarget1));
AssignCommand(otrodes,ActionJumpToLocation(lTarget3));
GiveGoldToCreature(oPC, 2000);
GiveXPToCreature(oPC, 100);

GuardarIntPersistente(oPC,"DESPELLEJADOR_FINAL_CHUNGO",2);
}






