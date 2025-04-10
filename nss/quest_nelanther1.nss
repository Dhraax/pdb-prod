#include "mti_libreria"
void main()
{
object oPC = GetPCSpeaker();

GuardarIntPersistente(oPC,"QUEST_IRPHONG",1);
}
