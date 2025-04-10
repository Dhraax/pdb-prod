#include "nw_i0_plot"

void main()
{
  object oStore = GetObjectByTag("mercado_negro_2");

  if(GetIsObjectValid(oStore) == TRUE) gplotAppraiseOpenStore(oStore, GetPCSpeaker());
  else PlayVoiceChat(VOICE_CHAT_CUSS);
}
