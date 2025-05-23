#include "nw_i0_tool"
#include "kpb_comision"

void main()
{
object oPC = GetPCSpeaker();
object oItem10 = GetItemPossessedBy(oPC, "bullionbond10");
object oItem25 = GetItemPossessedBy(oPC, "bullionbond25");
object oItem50 = GetItemPossessedBy(oPC, "bullionbond50");
int nDeposit;
int nBalance = GetCampaignInt("kpb_bank", "KPB_BANK_BALANCE", oPC);
if (nBalance>=6000000) { SpeakString("Lo siento no puedes ingresar más oro en tu cámara de depósitos. No cabe ni una sola pieza más. Gracias.", TALKVOLUME_TALK);}
 else
 {

    //int nAmount = (nDeposit + nBalance);
    if (HasItem(oPC, "bullionbond10") || HasItem(oPC, "bullionbond25") || HasItem(oPC, "bullionbond50"))
    {
        if (HasItem(GetPCSpeaker(), "bullionbond10"))
        {
        nDeposit = 5000;
        SpeakString("Has ingresado una fianza de 5000 monedas menos comisión");
        DestroyObject(oItem10);
        }
        if (HasItem(GetPCSpeaker(), "bullionbond25"))
        {
        nDeposit = 10000;
        SpeakString("Has ingresado una fianza de 10000 monedas menos comisión");
        DestroyObject(oItem25);
        }
        if (HasItem(GetPCSpeaker(), "bullionbond50"))
        {
        nDeposit = 50000;
        SpeakString("Has ingresado una fianza de 50000 monedas menos comisión");
        DestroyObject(oItem50);
        }
    }
    else
    {
    SpeakString("¡Debes de tener una fianza de un lingote para poder venderla!");
    return;
    }

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
             + GetName(oPC) + ", es decir, " + GetPCPlayerName(oPC) + ", ha ingresado "
             + sGold + " po en su cuenta bancaria tras el cobro de comisiones. Dinero total acumulado: " + sAmount + ".");
         }
         else if (iDif>0)
         {

            WriteTimestampedLogEntry("[SISTEMA DE SEGURIDAD BANCARIO]: "
             + GetName(oPC) + ", es decir, " + GetPCPlayerName(oPC) + ", ha ingresado "
             + sGold + " po en su cuenta bancaria tras el cobro de comisiones. Dinero total acumulado: " + sAmount + ". Aunque se le devuelto un excedente de " + IntToString(iDif) + " po.");
            SpeakString("Lo siento, no podemos ingresar en su cámara de depósito más de " + IntToString(StringToInt(sGold) - iDif) + " po. Gracias.", TALKVOLUME_TALK);
            GiveXPToCreature (oPC, iDif);
         }


         //////////////////////////////////////////

 }
}
