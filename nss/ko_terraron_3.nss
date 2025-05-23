#include "mti_libreria"

int StartingConditional()
{
object oPC = GetPCSpeaker();
int nComprobarVar = ObtenerIntPersistente(oPC, "ko_quest_kazad_terraron");//comprobamos que ha recibido la armadura

if(nComprobarVar == 2) return TRUE;

return FALSE;
}
