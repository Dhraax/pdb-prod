/* BANCO, DERECHOS DE ALMACENAMIENTO */
void main()
{
object oPC = GetPCSpeaker();
int nRentalFee = 100;
int nRentalCheck = GetCampaignInt("kpb_bank", "KPB_BANK_RENTAL", oPC);
int nGold = GetGold(oPC);
if (nRentalCheck == 1)
    {
    SpeakString("¡Ya has comprado los derechos de almacenamiento! No hay necesidad de comprarlos otra vez.");
    }
if (nGold < 100 && nRentalCheck != 1)
    {
    SpeakString("Lo siento, no tienes suficiente oro como para poder comprar los derechos.", TALKVOLUME_TALK);
    }
if (nGold >= 100 && nRentalCheck != 1)
    {
    TakeGoldFromCreature(nRentalFee, oPC, TRUE);
    SetCampaignInt("kpb_bank", "KPB_BANK_RENTAL", 1, oPC);
    SpeakString("Ahora puedes utilizar la caja fuerte persistente.");
    }
}
