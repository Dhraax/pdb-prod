void main()
{
int iTotal = GetCampaignInt("ingresos","shar");
string iConv = IntToString(iTotal);
AssignCommand(OBJECT_SELF,SpeakString("Nuestras arcas disponen de "+iConv+" monedas."));
}

