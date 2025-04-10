int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = GetCampaignInt("ko_documento_haila", "ko_quest_nashkel_documento", oPC);

if(nComprobarVar == 1) return TRUE; //Comprobamos que efectivamente entrega antes el documento

return FALSE;
}
