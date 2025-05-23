// SISTEMA DE DESCANSO POR HABITACIONES, HABITACION DE AVENTURERO

#include "f_vampire_area_h"
#include "cle_inc"

void main()
{
  object oPC = GetEnteringObject();
  object oArea = OBJECT_SELF;

  Vampire_Enter(oPC, FALSE);
  cle_warning(oPC);
   // Por si es un area de interior o exterior (vampis)
  if(GetIsAreaInterior(oArea)) ExecuteScript("fvex_area_inside", OBJECT_SELF);
  else ExecuteScript("fvex_area_outsid", OBJECT_SELF);

  if(GetIsPC(oPC))
  {
      //Fija esto a TRUE para reconocer el sistema de descanso por habitaciones
      SetLocalInt(OBJECT_SELF, "HCINN", TRUE);
      //Fija esto a TRUE si quieres que se consuma comida mientras descansas en una posada
      SetLocalInt(OBJECT_SELF, "FOODNEEDED", FALSE);
      //Fija esto a TRUE si quieres limitar el tiempo de descanso respecto a la ultima vez que descansastes
      SetLocalInt(OBJECT_SELF, "LIMITREST", FALSE);
      //Fija esto a TRUE si quieres que se descanse una sola vez cada vez que entres
      SetLocalInt(OBJECT_SELF, "RESTONCE", TRUE);
      //Eliminar la variable para que el sistema funcione...
      DeleteLocalInt(oPC, "RESTED");
      //Fija lo siguiente a 1,2,3 o 4 para determinar el tipo de curacion.
      SetLocalInt(OBJECT_SELF, "ROOMTYPE", 1);
      //Area explorada
      if(GetLocalInt(OBJECT_SELF, "AREA_EXPLORADA") == TRUE) ExploreAreaForPlayer(OBJECT_SELF, oPC, TRUE);
  }
}
