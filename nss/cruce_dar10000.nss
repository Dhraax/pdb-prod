void main()
{
object oPC = GetPCSpeaker();
int iDineros = GetGold(oPC);

    if(iDineros >= 10000)
    {
int ioro = GetCampaignInt("proyecto","caminoorco");
SetCampaignInt("proyecto","caminoorco",ioro + 10000);
TakeGoldFromCreature(10000,oPC,TRUE);
AssignCommand(OBJECT_SELF,SpeakString("¡Muchisimas gracias, tu dinero nos vendrá increiblemente bien!."));
    }
    else
    {
    AssignCommand(OBJECT_SELF,SpeakString("No tienes tanto oro..."));
    }
}

