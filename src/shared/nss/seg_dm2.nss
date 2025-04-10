#include "mti_libreria"

int StartingConditional()
{
  object oPC = GetPCSpeaker();
  object oJugadorSeleccionadoSeg = GetLocalObject(oPC, "SEG_JUGADOR");

  if(GetIsDM(oJugadorSeleccionadoSeg) || GetIsDMPossessed(oJugadorSeleccionadoSeg)) return FALSE;
  else return TRUE;
}

