void main()
{
object oPC = GetPCSpeaker();
int iDineros = GetGold(oPC);

    if(iDineros >= 100)
    {
int ioro = GetCampaignInt("proyecto","caminoorco");
SetCampaignInt("proyecto","caminoorco",ioro + 100);
TakeGoldFromCreature(100,oPC,TRUE);
AssignCommand(OBJECT_SELF,SpeakString("¡Muchas gracias, tu dinero nos vendrá genial!."));
    }
    else
    {
    AssignCommand(OBJECT_SELF,SpeakString("No tienes tanto oro..."));
    }
}

