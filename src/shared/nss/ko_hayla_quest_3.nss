#include "nw_i0_tool"

object oPC = GetPCSpeaker();
int nComprobarVar = GetCampaignInt("ko_diario_bandido", "ko_quest_nashkel_diario", oPC);
int StartingConditional()
{
if(!HasItem(GetPCSpeaker(), "ko_nash_diario_bandido")||(nComprobarVar == 1))
return FALSE;
return TRUE;
}
