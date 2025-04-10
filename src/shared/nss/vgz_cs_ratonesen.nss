#include "mti_libreria"
void main()
{
object oPC = GetLastSpeaker();
object oCaja = GetItemPossessedBy(oPC,"_cajaratones");

GuardarIntPersistente(oPC,"cs_ratones",8);
DestroyObject(oCaja);
GiveXPToCreature(oPC,200);

}
