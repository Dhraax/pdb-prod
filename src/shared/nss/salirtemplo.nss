#include "alintemplos_inc"

void main()
{
  object oPC = GetExitingObject();
  //Scripts para eliminar los pnj del área.
  ExecuteScript ("z0_area_onexit", oPC);
  alineamiento_templo_salir(oPC);
}
