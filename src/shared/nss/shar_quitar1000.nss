void main()
{
object oPC = GetPCSpeaker();
int iTotal = GetCampaignInt("ingresos","shar");
    if(iTotal >= 1000)
    {
SetCampaignInt("ingresos","shar",iTotal - 1000);
GiveGoldToCreature(oPC,1000);
AssignCommand(OBJECT_SELF,SpeakString("Usa sabiamente el dinero."));
    }
    else
    {
    AssignCommand(OBJECT_SELF,SpeakString("No hay tanto dinero en las arcas."));
    }
}

