
int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = GetCampaignInt("ko_edwing_malo_quest", "ko_quest_nashkel_5", oPC);

if(nComprobarVar == 1)

{return TRUE;}//comprobamos que ha hablado con Edwing

else{
return FALSE;}
}
