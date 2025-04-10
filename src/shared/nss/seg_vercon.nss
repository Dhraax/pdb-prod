#include "mti_libreria"

void main()
{
  object oDM = GetPCSpeaker();
  object oJugadorSeleccionado = GetLocalObject(oDM, "SEG_JUGADOR");
  string sContrasenya = ObtenerStringPersistente(oJugadorSeleccionado, "SEGCONTRASENYA");

  SendMessageToPC(oDM, "<c!}þ>La contraseña del PJ "+GetName(oJugadorSeleccionado)+" ("+GetPCPlayerName(oJugadorSeleccionado)+") es "+sContrasenya+"</c>");
}
