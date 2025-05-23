void main()
{
int iTotal = GetCampaignInt("vampiros","cripta");
string iConv = IntToString(iTotal);
AssignCommand(OBJECT_SELF,SpeakString("Las arcas de Bodhi disponen de "+iConv+" monedas."));
}

