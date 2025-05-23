#include "nw_i0_plot"

void main()
{
  object oStore = GetObjectByTag("ko_piedras_ioun");

  if(GetIsObjectValid(oStore) == TRUE) gplotAppraiseOpenStore(oStore, GetPCSpeaker());
  else PlayVoiceChat(VOICE_CHAT_CUSS);
}
