void main()
{
int iTotal = GetCampaignInt("proyecto","caminoorco");
string iConv = IntToString(iTotal);
AssignCommand(OBJECT_SELF,SpeakString("Nuestro proyecto dispone de "+iConv+" monedas. Aunque necesitamos bastante más."));
}

