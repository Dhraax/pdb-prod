void main()
{
object oPC = GetPCSpeaker();
int iTotal = GetCampaignInt("vampiros","cripta");
    if(iTotal >= 10000)
    {
SetCampaignInt("vampiros","cripta",iTotal - 10000);
GiveGoldToCreature(oPC,10000);
AssignCommand(OBJECT_SELF,SpeakString("Aquí tiene, Príncipe."));
    }
    else
    {
    AssignCommand(OBJECT_SELF,SpeakString("No hay tanto dinero en las arcas, Príncipe."));
    }
}

