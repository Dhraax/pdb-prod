#include "mti_libreria"
void main()
{
object oPC = GetLastSpeaker();

CreateItemOnObject("_cajaratones",oPC);
GuardarIntPersistente(oPC,"cs_ratones",1);
}
