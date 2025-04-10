int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = GetCampaignInt("ko_laura", "ko_quest_nashkel_2", oPC);
int nComprobarFallo = GetLocalInt(oPC, "fallo_convencer_enterrador");

if((nComprobarVar == 1)&&(!(nComprobarFallo == 1))) return TRUE; //comprobamos que ha hablado con Darek y no ha fallado enterrador

return FALSE;
}
