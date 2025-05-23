void main()
{
object oPC = GetPCSpeaker();

SetCampaignInt("ko_lyrethe", "ko_quest", 1, oPC); //Apuntamos que acepta la quest
object oLlave = CreateItemOnObject("llavedelmausoleo",GetPCSpeaker()); //damos la llave matanecrarios
}

