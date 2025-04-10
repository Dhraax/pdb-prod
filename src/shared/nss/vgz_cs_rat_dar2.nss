#include "mti_libreria"
void main()
{
object oPC = GetPCSpeaker();
object oTejon = GetNearestObjectByTag("cs_tejon",oPC);
object oAbuelo = GetNearestObjectByTag("viejozarkot",oPC);

GiveXPToCreature(oPC,400);
CreateItemOnObject("transalquimia",oPC);

AssignCommand(oTejon,ClearAllActions());
GuardarIntPersistente(oPC,"cs_ratones",100);
AssignCommand(oTejon,ActionForceMoveToObject(oAbuelo));
}
