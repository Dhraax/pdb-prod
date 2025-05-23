#include "nw_i0_tool"

int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = GetCampaignInt("ko_darek", "ko_quest_nashkel_1", oPC);

if(((nComprobarVar == 3 )||(nComprobarVar == 4 )) && (HasItem(GetPCSpeaker(), "llavceldanashkel")))

{return TRUE;}//comprobamos que tiene la llave y ha cogido amuleto

else{
return FALSE;}
}
