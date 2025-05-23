void main()
{
int iTotal = GetCampaignInt("donativos","hospicio");
string iConv = IntToString(iTotal);
AssignCommand(OBJECT_SELF,SpeakString("La gente ha donado en total "+iConv+" monedas."));
}

