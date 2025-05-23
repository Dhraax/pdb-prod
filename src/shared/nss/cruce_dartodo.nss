void main()
{
object oPC = GetPCSpeaker();
int iDineros = GetGold(oPC);

    if(iDineros >= 1)
    {
int ioro = GetCampaignInt("proyecto","caminoorco");
SetCampaignInt("proyecto","caminoorco",ioro + iDineros);
TakeGoldFromCreature(iDineros,oPC,TRUE);
AssignCommand(OBJECT_SELF,SpeakString("Te adoro... Vuelve pronto y verás que tu dinero ha sido bien utilizado."));

    }
    else
    {
    AssignCommand(OBJECT_SELF,SpeakString("No tienes oro..."));
    }
}

