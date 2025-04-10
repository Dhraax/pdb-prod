#include "mti_libreria"

void main()
{
object oPC = GetPCSpeaker();
GuardarIntPersistente(oPC,"ko_quest_kazad_terraron",1); //Apuntamos que no quiere mas placas
}
