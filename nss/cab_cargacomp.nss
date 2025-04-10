#include "cab_inc"
int StartingConditional()
{
  object oPC = GetPCSpeaker();

  // Si no tienes animales de carga esta conversacion no aparece
  object oAnimalCarga1 = GetHenchman(oPC, 1);
  object oAnimalCarga2 = GetHenchman(oPC, 2);
  object oAnimalCarga3 = GetHenchman(oPC, 3);

  if(VerSiEsAnimalDeCarga(oAnimalCarga1) == FALSE &&
     VerSiEsAnimalDeCarga(oAnimalCarga2) == FALSE &&
     VerSiEsAnimalDeCarga(oAnimalCarga3) == FALSE) return FALSE;

  return TRUE;
}
