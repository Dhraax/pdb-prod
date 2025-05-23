int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = GetCampaignInt("ko_diario_bandido", "ko_quest_nashkel_diario", oPC);

if(nComprobarVar == 1) return TRUE; //Comprobamos que efectivamente entrega antes el diario

return FALSE;
}
