#include "mti_libreria"
void main()
{
object oPC = GetPCSpeaker();
object oRaton = OBJECT_SELF;
object oCaja = GetItemPossessedBy(oPC,"_cajaratones");

DestroyObject(oRaton);
int iRatones = ObtenerIntPersistente(oPC,"cs_ratones");
GuardarIntPersistente(oPC,"cs_ratones",iRatones +1);

GiveXPToCreature(oPC,50);

}
