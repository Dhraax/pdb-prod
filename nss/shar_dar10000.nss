void main()
{
object oPC = GetPCSpeaker();
int iDineros = GetGold(oPC);

    if(iDineros >= 10000)
    {
int ioro = GetCampaignInt("ingresos","shar");
SetCampaignInt("ingresos","shar",ioro + 10000);
TakeGoldFromCreature(10000,oPC,TRUE);
    AssignCommand(OBJECT_SELF,SpeakString("Gracias por dar esa enorme cantidad de dinero a la causa."));

    }
    else
    {
    AssignCommand(OBJECT_SELF,SpeakString("No tienes suficiente oro..."));
    }
}

