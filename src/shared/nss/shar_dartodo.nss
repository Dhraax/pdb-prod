void main()
{
object oPC = GetPCSpeaker();
int iDineros = GetGold(oPC);

    if(iDineros >= 1)
    {
int ioro = GetCampaignInt("ingresos","shar");
SetCampaignInt("ingresos","shar",ioro + iDineros);
TakeGoldFromCreature(iDineros,oPC,TRUE);
AssignCommand(OBJECT_SELF,SpeakString("Gracias, tu enorme sacrificio monetario ayudará inmensamente a nuestra causa."));

    }
    else
    {
    AssignCommand(OBJECT_SELF,SpeakString("No tienes oro..."));
    }
}

