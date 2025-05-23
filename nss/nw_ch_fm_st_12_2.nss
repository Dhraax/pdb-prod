// Monti, anyadido objeto de comida necesario
//::////////////////////////////////////////////////////////////////////////////
//:: FileName:  NW_CH_FM_ST_12_2
//::////////////////////////////////////////////////////////////////////////////
/*
   The animal heals itself fully (no effects).
*/
//::////////////////////////////////////////////////////////////////////////////
#include "HC_Inc"
//::////////////////////////////////////////////////////////////////////////////
void main()
{
object oPC = GetPCSpeaker();
object oComida = GetItemPossessedBy(oPC, "alimentoparafami");
object oAnimal = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oPC);

      if(oComida == OBJECT_INVALID)
          {
           FloatingTextStringOnCreature("*¡Necesitas algo de comida con la que alimentar a tu animal! Quizás puedas encontrar un poco en alguna arboleda o tienda especializada.*", oPC);
           return;
          }

      if(GetCurrentHitPoints(oAnimal) >= GetMaxHitPoints(oAnimal))
          {
           SendMessageToPC(oPC, "Tu compañero animal no está particularmente hambriento, pero en cualquier caso disfruta de la atención que le dispensas.");
           SetLocalInt(oPC,"Familiar_Happy",(GetLocalInt(oPC,"Familiar_Happy")+1));
           return;
          }
      else
          {
           int iVidaAnimal = GetMaxHitPoints(oAnimal);
           effect eCuracion = EffectHeal(iVidaAnimal);
           if(GetIsObjectValid(oComida)) DestroyObject(oComida);
           ApplyEffectToObject(DURATION_TYPE_INSTANT, eCuracion, oAnimal);
           SendMessageToPC(oPC, "Tu compañero animal está bastante famélico y devora el alimento que le ofreces. Parece inmediatamente revitalizado.");
           return;
          }
}
//::////////////////////////////////////////////////////////////////////////////
