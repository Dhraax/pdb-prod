////////////////////////////////////////////
//  Kittrell's Persistent Banking System  //
//  Designed by: Brian J. Kittrell        //
//                                        //
//  This script does the following:       //
//                                        //
//  kpb_withdraw1000 - This script allows //
//  players to withdraw 1000 of their     //
//  gold that is in the vault.            //
////////////////////////////////////////////

//#include "kpb_comision"

void main()
{
object oPC = GetPCSpeaker();
int nWithdraw = 1000;
int nBalance = GetCampaignInt("kpb_bank", "KPB_BANK_BALANCE", oPC);
//float fComi = Comisiones_Sacar();
int nAmount = nBalance - nWithdraw;
int nGold = GetGold(oPC);
if (nBalance >= 1000)//1000
    {
    GiveGoldToCreature(oPC, nWithdraw);
    SetCampaignInt("kpb_bank", "KPB_BANK_BALANCE", nAmount, oPC);

    ExportSingleCharacter(oPC);

    //////VARGATH, CANTIDAD DE ORO AL LOG/////
    string sCDKey = GetPCPublicCDKey(oPC);
    string sAmount = IntToString(nAmount);
    string sGold = "1000";

    WriteTimestampedLogEntry("[SISTEMA DE SEGURIDAD BANCARIO]: "
    + GetName(oPC, TRUE) + ", es decir, " + GetPCPlayerName(oPC) + ", ha sacado "
    + sGold + " po de su cuenta bancaria. Dinero total acumulado es de: " + sAmount + " po.");
    //////////////////////////////////////////
    }
else
    {
    SpeakString("Lo siento, no tiene suficiente oro como para poder retirar esa cantidad más comisiones.", TALKVOLUME_TALK);
    }
}
