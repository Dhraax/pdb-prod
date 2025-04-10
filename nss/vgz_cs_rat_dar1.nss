#include "mti_libreria"

void main()
{
object oPC = GetPCSpeaker();
object oTejon = GetNearestObjectByTag("cs_tejon",oPC);
object oAbuelo = GetNearestObjectByTag("viejozarkot",oPC);

GiveXPToCreature(oPC,400);
GiveGoldToCreature(oPC,1250);
GuardarIntPersistente(oPC,"cs_ratones",100);

AssignCommand(oTejon,ClearAllActions());
AssignCommand(oTejon,ActionForceMoveToObject(oAbuelo));



}
