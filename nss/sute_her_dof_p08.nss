#include "NW_I0_GENERIC"

void CrearObjetoEnLugar(string sResref, location lObjetivo){
   CreateObject(OBJECT_TYPE_PLACEABLE, sResref, lObjetivo, TRUE);
}

void main()
{
   object oDesencadenante= OBJECT_SELF;
   object oPC= GetExitingObject();

   if (GetLocalInt(oDesencadenante, "EXISTEARBOL")==1){
      DestroyObject(GetNearestObjectByTag("sute_her_p08", oDesencadenante), 0.5);
      SetLocalInt(oDesencadenante, "EXISTEARBOL", 0);
   }
}
