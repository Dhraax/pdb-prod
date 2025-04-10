void main()
{
int iTotal = GetCampaignInt("ingresos","dinerocofr");

if (iTotal < 10000)
{
GiveGoldToCreature(GetPCSpeaker(),10000);
SetCampaignInt("ingresos","dinerocofr", iTotal - 10000);
}

else
{
ActionSpeakString ("¡Estamos en números rojos! Lo siento", FALSE);
}
}
