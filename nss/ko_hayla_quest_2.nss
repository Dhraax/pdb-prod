#include "nw_i0_tool"

object oPC = GetPCSpeaker();
int nComprobarVar = GetCampaignInt("ko_documento_haila", "ko_quest_nashkel_documento", oPC);
int StartingConditional()
{
if(!HasItem(GetPCSpeaker(), "ko_nash_documento")||(nComprobarVar == 1))
return FALSE;
return TRUE;
}
