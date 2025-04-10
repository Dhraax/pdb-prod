// Monti, anyadido objeto de comida necesario
//::////////////////////////////////////////////////////////////////////////////
//:: Nombre del guion:  NW_CH_FM_ST_12
//::////////////////////////////////////////////////////////////////////////////
/*
   El familiar es sanadp si tienes alimento para el
*/
//::////////////////////////////////////////////////////////////////////////////
#include "HC_Inc"
//::////////////////////////////////////////////////////////////////////////////
void main()
{
object oPC = GetPCSpeaker();
object oComida = GetItemPossessedBy(oPC, "alimentoparafami");
object oAnimal = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oPC);

      if(oComida == OBJECT_INVALID)
          {
           FloatingTextStringOnCreature("*¡Necesitas algo de comida con la que alimentar a tu familiar! Quizás puedas encontrar un poco en alguna tienda de un mago o en alguna arboleda.*", oPC);
           return;
          }

      if(GetCurrentHitPoints(oAnimal) >= GetMaxHitPoints(oAnimal))
          {
           SendMessageToPC(oPC, "Tu familiar no está particularmente hambriento, pero en cualquier caso disfruta de la atención que le dispensas.");
           SetLocalInt(oPC,"Familiar_Happy",(GetLocalInt(oPC,"Familiar_Happy")+1));
           return;
          }
      else
          {
           int iVidaAnimal = GetMaxHitPoints(oAnimal);
           effect eCuracion = EffectHeal(iVidaAnimal);
           if(GetIsObjectValid(oComida)) DestroyObject(oComida);
           ApplyEffectToObject(DURATION_TYPE_INSTANT, eCuracion, oAnimal);
           SendMessageToPC(oPC, "Tu familiar está bastante famélico y devora el alimento que le ofreces. Parece inmediatamente revitalizado.");
           return;
          }
}
//::////////////////////////////////////////////////////////////////////////////
