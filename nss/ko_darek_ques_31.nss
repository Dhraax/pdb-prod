#include "nw_i0_tool"

int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = GetCampaignInt("ko_darek", "ko_quest_nashkel_1", oPC);

if((nComprobarVar == 2)&& (HasItem(GetPCSpeaker(), "llavceldanashkel"))){

return TRUE; //comprobamos que ha hablado con el bardo y con darek y que no tiene la llave
}

return FALSE;
}
