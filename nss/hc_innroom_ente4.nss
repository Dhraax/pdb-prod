// SISTEMA DE DESCANSO POR HABITACIONES, HABITACION DE NOBLE

#include "f_vampire_area_h"
#include "cle_inc"

void main()
{
  object oPC = GetEnteringObject();

  Vampire_Enter(oPC, FALSE);
  if(GetTag(OBJECT_SELF) != "bolsa_planar") cle_warning(oPC);

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
      SetLocalInt(OBJECT_SELF, "ROOMTYPE", 4);
  }
}
