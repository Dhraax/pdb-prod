int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVarBueno = GetCampaignInt("ko_edwing_quest", "ko_quest_nashkel_4", oPC);
int nComprobarVarMalo = GetCampaignInt("ko_edwing_malo_quest", "ko_quest_nashkel_5", oPC);

if((nComprobarVarBueno == 2)||(nComprobarVarBueno == 1)||(nComprobarVarMalo == 2)||(nComprobarVarMalo == 1)) return TRUE; //comprobamos que ha aceptado alguna quest de Edwing

return FALSE;
}
