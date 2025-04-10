#include "mti_libreria"

void main()
{
  object oPC = GetPCChatSpeaker();
  string sTexto = GetPCChatMessage();

  if(GetStringLength(sTexto) != 6)
  {
      SendMessageToPC(oPC, "<cþ<<>Una contraseña de PJ está compuesta por 6 dígitos.</c>");
      DeleteLocalInt(oPC, "SEG_CONCAMBIO");
      return;
  }

  object oJugadorSeleccionadoSeg = GetLocalObject(oPC, "SEG_JUGADOR");

  SendMessageToPC(oPC, "<c þ >La nueva contraseña de PJ de "+GetName(oJugadorSeleccionadoSeg)+" es "+sTexto+".</c>");
  SendMessageToPC(oJugadorSeleccionadoSeg, "<c þ >Tu nueva contraseña de PJ es"+sTexto+", ¡recuérdala!</c>");
  GuardarStringPersistente(oJugadorSeleccionadoSeg, "SEGCONTRASENYA", sTexto);
  DeleteLocalInt(oPC, "SEG_CONCAMBIO");
}
