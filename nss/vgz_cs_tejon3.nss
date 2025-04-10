#include "mti_libreria"
void main()
{
object oPC = GetPCSpeaker();
object oTejon = OBJECT_SELF;


FloatingTextStringOnCreature("*El tejon sigue la barrita de queso*",oPC);
AssignCommand(oTejon,ActionForceFollowObject(oPC,1.0));
}
