#include "nw_i0_tool"
int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = GetCampaignInt("ko_edwing_quest", "ko_quest_nashkel_4", oPC);

if((nComprobarVar == 1 )&&(HasItem(GetPCSpeaker(), "InformedeEdwingMatanecrarios")))

{return TRUE;}//comprobamos que ha hablado con Edwing

else{
return FALSE;}
}
