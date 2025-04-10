void main()
{
object oPC = GetPCSpeaker();
int iDineros = GetGold(oPC);

    if(iDineros >= 1)
    {
int ioro = GetCampaignInt("vampiros","cripta");
SetCampaignInt("vampiros","cripta",ioro + iDineros);
TakeGoldFromCreature(iDineros,oPC,TRUE);
AssignCommand(OBJECT_SELF,SpeakString("Gracias, tu enorme sacrificio monetario ayudará inmensamente a nuestra causa. Bodhi estará complacida."));

    }
    else
    {
    AssignCommand(OBJECT_SELF,SpeakString("No tienes oro..."));
    }
}

