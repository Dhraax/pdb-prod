#include "mti_libreria"
void main()
{
object oPC = GetPCSpeaker();

GuardarIntPersistente(oPC, "DESPELLEJADOR_FINAL_CHUNGO",1);
object punto = GetWaypointByTag("Quest_Darsidian_cuerpo_noquest");
location lTarget = GetLocation(punto);
object chica = GetObjectByTag("pnj_carintRaissa"); //Carav_verdaderaRaissa
AssignCommand(chica,ActionJumpToLocation(lTarget));
}
