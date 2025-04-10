// DOTE Falange para PdB
//Lucha en falange: +1 CA si luchas con escudo pesado y arma ligera
// y si además estás con un compañero (en grupo) con la misma dote y escudo pesado y arma ligera añades tanto a ti como a él otro +2 CA y +1 reflejos.//

#include "x0_i0_spells"

int GetNumAliados(object oPC)
{
   int nLoop = 0;
   object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(oPC));
   // Keep processing while oTarget is valid
   while(GetIsObjectValid(oTarget))
    {
       if(GetHasSpellEffect(1328, oTarget) && GetIsFriend(oTarget, oPC) && oTarget != oPC)
         {
           nLoop++;
         }

        // Get next object in the sphere
   oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(oPC));
    }

    //Si son menos de 3 no se ajusta nada, si somos mas siempre +3 de CA maximo.
    if(nLoop <= 3 ) nLoop = 0;
	else nLoop = nLoop -2;

    return nLoop;

}

void main()
{
    //Declare major variables
  //object oTarget = GetEnteringObject();
  object oPC = GetAreaOfEffectCreator();
  int oCA = GetNumAliados(oPC);
  effect eCA = EffectACIncrease(1, AC_DODGE_BONUS);
  effect nCA = EffectACDecrease(oCA, AC_DODGE_BONUS);
  effect eReflex = EffectSavingThrowIncrease(SAVING_THROW_REFLEX, 1, SAVING_THROW_TYPE_ALL);
  effect eLink = EffectLinkEffects(eCA, eReflex);
  eLink = ExtraordinaryEffect(eLink);

  object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(oPC));
  object oManoIzq = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
  while(GetIsObjectValid(oTarget))
    {
       if(GetIsFriend(oTarget, oPC) && oTarget != oPC)
      {
         if(GetHasFeat(1442, oTarget) && GetHasSpellEffect(1328, oTarget) && GetBaseItemType(oManoIzq) == BASE_ITEM_TOWERSHIELD )
             {
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, nCA, oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PDK_INSPIRE_COURAGE), oTarget);
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
             }
          }

   oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(oPC));

    }
}


