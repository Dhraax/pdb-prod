int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = GetCampaignInt("ko_hayla_quest", "ko_quest_nashkel_3", oPC);

if(nComprobarVar == 1) {return TRUE;} //Comprobamos que efectivamente aceptó el encargo

return FALSE;
}
