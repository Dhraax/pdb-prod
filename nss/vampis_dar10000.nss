void main()
{
object oPC = GetPCSpeaker();
int iDineros = GetGold(oPC);

    if(iDineros >= 10000)
    {
int ioro = GetCampaignInt("vampiros","cripta");
SetCampaignInt("vampiros","cripta",ioro + 10000);
TakeGoldFromCreature(10000,oPC,TRUE);
AssignCommand(OBJECT_SELF,SpeakString("Gracias por tu dinero. ¡Gloria a Bodhi!"));

    }
    else
    {
    AssignCommand(OBJECT_SELF,SpeakString("No tienes suficiente oro..."));
    }
}

