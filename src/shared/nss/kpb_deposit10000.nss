////////////////////////////////////////////
//  Kittrell's Persistent Banking System  //
//  Designed by: Brian J. Kittrell        //
//                                        //
//  This script does the following:       //
//                                        //
//  kpb_deposit10000 - This script allows //
//  players to deposit 10000 of their     //
//  Modificado por Kronos.                //
////////////////////////////////////////////

#include "kpb_comision"

void main()
{
object oPC = GetPCSpeaker();
int nDeposit = 10000;
int nBalance = GetCampaignInt("kpb_bank", "KPB_BANK_BALANCE", oPC);
if (nBalance>=6000000) { SpeakString("Lo siento no puedes ingresar más oro en tu cámara de depósitos. No cabe ni una sola pieza más. Gracias.", TALKVOLUME_TALK);}
 else
 {

    //int nAmount = (nDeposit + nBalance);
    float fComi = Comisiones_Ingresos(nDeposit, nBalance);
    int nAmount = nBalance + (FloatToInt((1.0 -fComi) * IntToFloat(nDeposit)));
    int iDif = 0;
    if (nAmount >6000000)
    {

        iDif = nAmount - 6000000;
        nAmount = 6000000;
    }
    int nGold = GetGold(oPC);
    int iMonth = GetCalendarMonth();
    int iDay = GetCalendarDay();
    int iYear = GetCalendarYear();
    if (nGold >= 10000)
        {
        TakeGoldFromCreature(nDeposit, oPC, TRUE);
        SetCampaignInt("kpb_bank", "KPB_BANK_BALANCE", nAmount, oPC);
        SetCampaignInt("kpb_bank", "KPB_DEPO_YEAR", iYear, oPC);
        SetCampaignInt("kpb_bank", "KPB_DEPO_DAY", iDay, oPC);
        SetCampaignInt("kpb_bank", "KPB_DEPO_MONTH", iMonth, oPC);

        ExportSingleCharacter(oPC);

        //////VARGATH, CANTIDAD DE ORO AL LOG/////
         string sCDKey = GetPCPublicCDKey(oPC);
         string sAmount = IntToString(nAmount);
         string sGold = IntToString(FloatToInt((1.0 -fComi) * IntToFloat(nDeposit)));//"10000";
         if (iDif ==0)
         {
             WriteTimestampedLogEntry("[SISTEMA DE SEGURIDAD BANCARIO]: "
             + GetName(oPC, TRUE) + ", es decir, " + GetPCPlayerName(oPC) + ", ha ingresado "
             + sGold + " po en su cuenta bancaria tras el cobro de comisiones. Dinero total acumulado: " + sAmount + ".");
         }
         else if (iDif>0)
         {

            WriteTimestampedLogEntry("[SISTEMA DE SEGURIDAD BANCARIO]: "
             + GetName(oPC, TRUE) + ", es decir, " + GetPCPlayerName(oPC) + ", ha ingresado "
             + sGold + " po en su cuenta bancaria tras el cobro de comisiones. Dinero total acumulado: " + sAmount + ". Aunque se le devuelto un excedente de " + IntToString(iDif) + " po.");
            SpeakString("Lo siento, no podemos ingresar en su cámara de depósito más de " + IntToString(StringToInt(sGold) - iDif) + " po. Gracias.", TALKVOLUME_TALK);
            GiveXPToCreature (oPC, iDif);
         }


         //////////////////////////////////////////


        }
    else
        {
        SpeakString("Lo siento, no tienes suficiente oro como para poder ingresar.", TALKVOLUME_TALK);
        }
 }
}
