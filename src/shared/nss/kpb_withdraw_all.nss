////////////////////////////////////////////
//  Kittrell's Persistent Banking System  //
//  Designed by: Brian J. Kittrell        //
//                                        //
//  This script does the following:       //
//                                        //
//  kpb_withdraw_all - This script allows //
//  withdraw to deposit all of their gold //
//  that they are carrying in one foul    //
//  swoop.  For the big spender looking   //
//  to spend the day shopping around the  //
//  city. :)                              //
//  Modificado por Kronos.                //
////////////////////////////////////////////

//#include "kpb_comision"

void main()
{
object oPC = GetPCSpeaker();
int nBalance = GetCampaignInt("kpb_bank", "KPB_BANK_BALANCE", oPC);
//float fComi = Comisiones_Sacar(TRUE);
int nAmount = 0;
if (nBalance >= 1)
    {
    GiveGoldToCreature(oPC, nBalance);
    SetCampaignInt("kpb_bank", "KPB_BANK_BALANCE", nAmount, oPC);

    ExportSingleCharacter(oPC);

    //////VARGATH, CANTIDAD DE ORO AL LOG/////
    string sCDKey = GetPCPublicCDKey(oPC);
    string sAmount = IntToString(nAmount);
    string sBalance = IntToString(nBalance);

    WriteTimestampedLogEntry("[SISTEMA DE SEGURIDAD BANCARIO]: "
    + GetName(oPC, TRUE) + ", es decir, " + GetPCPlayerName(oPC) + ", ha sacado "
    + sBalance + " po de su cuenta bancaria. Dinero total acumulado es de:" + sAmount + " po.");
    //////////////////////////////////////////
    }
else
    {
    SpeakString("Lo siento, no tiene oro.", TALKVOLUME_TALK);
    }
}
