#include "x0_i0_spells"

void main()
{
    //Declare major variables
  //object oTarget = GetExitingObject();
  object oPC = GetAreaOfEffectCreator();
  object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(oPC));

while(GetIsObjectValid(oTarget))
    {
	if(GetIsFriend(oTarget) && oTarget != oPC && GetHasSpellEffect(1328, oTarget))
		{
		//Eliminamos los efectos al salir
		RemoveSpellEffects(1328, oPC, oTarget);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE), oTarget);
		}

	 oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(oPC));

    }
}




