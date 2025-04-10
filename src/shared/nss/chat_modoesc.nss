#include "esc_inc"

void main()
{
  object oPC = GetPCChatSpeaker();
  string sTexto = GetPCChatMessage();

  ModoEscritura(GetLocalInt(oPC, "MODOESCRITURA"), sTexto, oPC);
}
