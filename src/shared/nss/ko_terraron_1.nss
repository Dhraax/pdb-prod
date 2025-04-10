#include "mti_libreria"

int StartingConditional()
{
object oPC = GetPCSpeaker();
int nComprobarVar = ObtenerIntPersistente(oPC, "ko_quest_kazad_terraron");//comprobamos que ha entregado ultimo caprazon

if(nComprobarVar == 1) return TRUE;

return FALSE;
}
