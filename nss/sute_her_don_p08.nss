#include "NW_I0_GENERIC"

void CrearObjetoEnLugar(string sResref, location lObjetivo){
   CreateObject(OBJECT_TYPE_PLACEABLE, sResref, lObjetivo, TRUE);
}

void main()
{
   object oDesencadenante= OBJECT_SELF;
   object oPC= GetEnteringObject();

   if (GetLocalInt(oDesencadenante, "EXISTEARBOL")==0){
      if((GetIsPC(oPC))&&((GetHasEffect(EFFECT_TYPE_TRUESEEING, oPC))||(GetHasEffect(EFFECT_TYPE_SEEINVISIBLE, oPC)))){
         CrearObjetoEnLugar("sute_her_p08", GetLocation(GetNearestObjectByTag("PRArbolFantasma", oDesencadenante)));
         SetLocalInt(oDesencadenante, "EXISTEARBOL", 1);
      }
   }
}
