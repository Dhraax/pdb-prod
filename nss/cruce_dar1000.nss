void main()
{
object oPC = GetPCSpeaker();
int iDineros = GetGold(oPC);

    if(iDineros >= 1000)
    {
int ioro = GetCampaignInt("proyecto","caminoorco");
SetCampaignInt("proyecto","caminoorco",ioro + 1000);
TakeGoldFromCreature(1000,oPC,TRUE);
AssignCommand(OBJECT_SELF,SpeakString("¡Muchas gracias, tu dinero nos vendrá genial!."));
    }
    else
    {
    AssignCommand(OBJECT_SELF,SpeakString("No tienes tanto oro..."));
    }
}

