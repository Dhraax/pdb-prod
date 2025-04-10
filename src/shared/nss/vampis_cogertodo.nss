void main()
{
object oPC = GetPCSpeaker();
int iDineros = GetCampaignInt("vampiros","cripta");

    if(iDineros >= 1)
    {
SetCampaignInt("vampiros","cripta",0);
GiveGoldToCreature(oPC,iDineros);
AssignCommand(OBJECT_SELF,SpeakString("Aquí tiene todo, Príncipe."));

    }
    else
    {
    AssignCommand(OBJECT_SELF,SpeakString("No hay oro que sacar..."));
    }
}

