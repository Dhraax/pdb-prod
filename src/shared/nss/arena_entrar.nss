#include "f_vampire_area_h"
#include "inc_generic"
#include "pb_inc_mmf"
void main()
{
  object oPC = GetEnteringObject();
  //Scripts para añadir los pnj del área.
  ExecuteScript ("z0_area_onenter", oPC);
  string sArea = GetTag(GetArea(oPC));

  if(!GetIsPC(oPC)) return;

  // VAMPIROS
  Vampire_Enter(oPC, FALSE);

  // Maestro Multiples Formas
  OnEnterLoadPolymorphed(oPC);

  // ARENAS
  SendMessageToPC(oPC, "<c þ >Has entrado en el Modo Arena. No sufrirás penalización alguna al morir en esta area.</c>");
  SetLocalInt(oPC, "ARENA", 1);

  if(GetTag(OBJECT_SELF) == "ModoArenaDesencadenante") return;

  // DESCANSO INFINITO
  //Fija esto a TRUE para reconocer el sistema de descanso por habitaciones
  SetLocalInt(OBJECT_SELF, "HCINN", TRUE);
  //Fija esto a TRUE si quieres que se consuma comida al dormir
  SetLocalInt(OBJECT_SELF, "FOODNEEDED", FALSE);
  //Fija esto a TRUE si quieres limitar el tiempo de descanso respecto a la ultima vez que descansastes
  SetLocalInt(OBJECT_SELF, "LIMITREST", FALSE);
  //Fija esto a TRUE si quieres que se descanse una sola vez cada vez que entres
  SetLocalInt(OBJECT_SELF, "RESTONCE", FALSE);
  //Eliminar la variable de descanso para que el sistema funcione...
  DeleteLocalInt(oPC, "RESTED");
  //Fija lo siguiente a 1,2,3,4 o 5 para determinar el tipo de curacion.
  SetLocalInt(OBJECT_SELF, "ROOMTYPE", 5);
}
