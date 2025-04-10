void main()
{
object oPC = GetPCSpeaker();
int iTotal = GetCampaignInt("ingresos","shar");
    if(iTotal >= 10000)
    {
SetCampaignInt("ingresos","shar",iTotal - 10000);
GiveGoldToCreature(oPC,10000);
AssignCommand(OBJECT_SELF,SpeakString("Usa sabiamente el dinero, no abuses o Shar te castigará..."));
    }
    else
    {
    AssignCommand(OBJECT_SELF,SpeakString("No hay tanto dinero en las arcas."));
    }
}

