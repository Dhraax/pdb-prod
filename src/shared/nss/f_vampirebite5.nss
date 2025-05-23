#include "f_vampire_h"
#include "f_vampirebite_h"

void ContinueScript(object oTarget)
{
SetIsTemporaryNeutral(oTarget);
if(d2()==1) SetIsTemporaryNeutral(OBJECT_SELF, oTarget);
if(GetBadBlood(oTarget))
    {
    ApplyBloodFX(OBJECT_SELF);
    FloatingTextStringOnCreature("Has creado a otro vampiro, aunque su sangre fuera impura.", OBJECT_SELF, FALSE);
    }
else FloatingTextStringOnCreature("Has creado a otro vampiro.", OBJECT_SELF, FALSE);
}

void main()
{
object oTarget = GetLocalObject(OBJECT_SELF, "FALLEN_VAMPIRE_VICTIM");
DeleteLocalObject(OBJECT_SELF, "FALLEN_VAMPIRE_VICTIM");
if(!GetIsObjectValid(oTarget)) return;
if(!GetIsBitable(oTarget)) return;
Vampire_Fresh_Blood(OBJECT_SELF); //for the blood hunger system
DelayCommand(2.5, FloatingTextStringOnCreature("Has sido llamado por la hermandad de los muertos vivientes para empezar a vivir como uno de ellos.", oTarget, FALSE));
DelayCommand(2.5, ContinueScript(oTarget));
ExecuteScript("f_vampirebecome", oTarget);
}
