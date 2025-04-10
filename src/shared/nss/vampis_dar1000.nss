void main()
{
object oPC = GetPCSpeaker();
int iDineros = GetGold(oPC);

    if(iDineros >= 1000)
    {
int ioro = GetCampaignInt("vampiros","cripta");
SetCampaignInt("vampiros","cripta",ioro + 1000);
TakeGoldFromCreature(1000,oPC,TRUE);
AssignCommand(OBJECT_SELF,SpeakString("Gracias por tu dinero. ¡Gloria a Bodhi!"));

    }
    else
    {
    AssignCommand(OBJECT_SELF,SpeakString("No tienes suficiente oro..."));
    }
}

