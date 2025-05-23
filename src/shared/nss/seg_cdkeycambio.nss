#include "mti_libreria"

void main()
{
  object oDM = GetPCSpeaker();
  object oJugadorSeleccionadoSeg = GetLocalObject(oDM, "SEG_JUGADOR");

  SendMessageToPC(oDM, "<cßþ>La nueva cdkey original de "+GetName(oJugadorSeleccionadoSeg)+" ha cambiado por la que usa ahora mismo.</c>");
  SendMessageToPC(oJugadorSeleccionadoSeg, "<cßþ>Tu nueva cdkey original ha cambiado por la que usas ahora mismo. Ahora el sistema de seguridad del servidor ya no te pedirá contraseña con este PJ siempre y cuando entres con esta cdkey.</c>");
  GuardarStringPersistente(oJugadorSeleccionadoSeg, "CDKEY", GetPCPublicCDKey(oJugadorSeleccionadoSeg));
}
