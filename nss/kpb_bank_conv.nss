#include "kpb_comision"

void main()
{
    int nConversation = GetListenPatternNumber();
    object oPC = GetLastSpeaker();

    int iMonth = GetCalendarMonth();
    int iDay = GetCalendarDay();
    int iYear = GetCalendarYear();

    if (nConversation == -1 && GetCommandable(OBJECT_SELF))
    {
        ClearAllActions();
        BeginConversation();
    }

    if(GetIsPC(oPC) == FALSE)
        return;

    if(nConversation == 20)
    {
        string sGold = GetMatchedSubstring(2);
        int nGold = StringToInt(sGold);
        int nBalance = GetCampaignInt("kpb_bank", "KPB_BANK_BALANCE", oPC);
        if (nBalance>=6000000)
        {
            SpeakString("Lo siento no puedes ingresar más oro en tu cámara de depósitos. No cabe ni una sola pieza más. Gracias.", TALKVOLUME_TALK);
            return;
        }
        else
        {
            int nGoldHeld = GetGold(oPC);

            if(nGoldHeld == 0)
            {
                SpeakString("¿Qué, me quieres dar eso?  ¡Aceptamos solamente oro en nuestro banco!");
                return;
            }

            if(nGold > nGoldHeld)
                {
                    SpeakString("No puedes ingresar mas dinero del que tienes!");
                }

            else if(nGold <= 0)
                {
                    SpeakString("No puedes ingresar NINGUNA pieza de oro.. no podemos hacer tales cosas!");
                }

            else
            {

                    //int nAmount = (nBalance + nGold);
                    float fComi = Comisiones_Ingresos(nGold, nBalance, TRUE);
                    int nAmount = nBalance + (FloatToInt((1.0 - fComi) * IntToFloat(nGold)));
                    int iDif = 0;
                    if (nAmount >6000000)
                    {
                        iDif = nAmount - 6000000;
                        nAmount = 6000000;
                    }
                    SetCampaignInt("kpb_bank", "KPB_BANK_BALANCE", nAmount, oPC);
                    SetCampaignInt("kpb_bank", "KPB_DEPO_YEAR", iYear, oPC);
                    SetCampaignInt("kpb_bank", "KPB_DEPO_DAY", iDay, oPC);
                    SetCampaignInt("kpb_bank", "KPB_DEPO_MONTH", iMonth, oPC);
                    SpeakString("He añadido el oro a su cuenta. Gracias por su visita.");
                    TakeGoldFromCreature(nGold, oPC, TRUE);

                    ExportSingleCharacter(oPC);

                    //////VARGATH, CANTIDAD DE ORO AL LOG/////
                    string sCDKey = GetPCPublicCDKey(oPC);
                    string sAmount = IntToString(nAmount);
                    string sGold = IntToString(FloatToInt((1.0 -fComi) * IntToFloat(nGold)));//"1000";
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
        }
    }
    if(nConversation == 21)
    {
        string sGold = GetMatchedSubstring(2);
        int nGold = StringToInt(sGold);
        int nBalance = GetCampaignInt("kpb_bank", "KPB_BANK_BALANCE", oPC);

        if(nBalance == 0)
        {
            SpeakString("Lo siento.. no puedo realizar su petición. Parece que no tiene ningun fondo almacenado en nuestro banco.");
            return;
        }

        if(nGold <= 0)
            {
            SpeakString("¡¿Qué?! ¡No me haga perder el tiempo!");
            }

        else if(nGold > nBalance)
            {
            SpeakString("No puedes sacar mas dinero del que tienes!");
            }

        else
        {
            int nAmount = (nBalance - nGold);
            SetCampaignInt("kpb_bank", "KPB_BANK_BALANCE", nAmount, oPC);
            SpeakString("Tengo sus fondos aquí. Que tenga un buen día.");
            GiveGoldToCreature(oPC, nGold);

            ExportSingleCharacter(oPC);

                //////VARGATH, CANTIDAD DE ORO AL LOG/////
                string sCDKey = GetPCPublicCDKey(oPC);
                string sAmount = IntToString(nAmount);
                string sGold = IntToString(nGold);

                WriteTimestampedLogEntry("[SISTEMA DE SEGURIDAD BANCARIO]: "
                + GetName(oPC, TRUE) + ", es decir, " + GetPCPlayerName(oPC) + ", ha sacado "
                + sGold + " po de su cuenta bancaria. Dinero total acumulado: " + sAmount + ".");
                //////////////////////////////////////////
        }
    }

    if(nConversation == 22)
    {
        int nBalance = GetCampaignInt("kpb_bank", "KPB_BANK_BALANCE", oPC);

        if(nBalance == 0)
        {
            SpeakString("No tienes oro en tu cuenta.");
            return;
        }
        if(nBalance >= 1)
        {
            SpeakString("Tu tienes actualmente " + IntToString(nBalance) + " po guardadas en nuestra caja fuerte.", TALKVOLUME_TALK);
        }
    }

    if(nConversation == 23)
    {
        int nBalance = GetCampaignInt("kpb_bank", "KPB_BANK_BALANCE", oPC);

        if(nBalance == 0)
        {
            SpeakString("Lo siento.. no puedo realizar su peticion.  Parece que no tiene ningun fondo guardado en nuestro banco");
            return;
        }

        else if(nBalance >= 1)
        {
            int nAmount = 0;
            int nGold = nBalance;
            SetCampaignInt("kpb_bank", "KPB_BANK_BALANCE", nAmount, oPC);
            SpeakString("Tengo su dinero aqui. Que tenga un buen dia.");
            GiveGoldToCreature(oPC, nGold);

            ExportSingleCharacter(oPC);

                //////VARGATH, CANTIDAD DE ORO AL LOG/////
                string sCDKey = GetPCPublicCDKey(oPC);
                string sAmount = IntToString(nAmount);
                string sGold = IntToString(nGold);

                WriteTimestampedLogEntry("[SISTEMA DE SEGURIDAD BANCARIO]: "
                + GetName(oPC, TRUE) + ", es decir, " + GetPCPlayerName(oPC) + ", ha sacado "
                + sGold + " po de su cuenta bancaria. Dinero total acumulado: " + sAmount + ".");
                //////////////////////////////////////////
        }
    }

    if(nConversation == 24)
    {
        int nBalance = GetCampaignInt("kpb_bank", "KPB_BANK_BALANCE", oPC);
        if (nBalance>=6000000)
        {
            SpeakString("Lo siento no puedes ingresar más oro en tu cámara de depósitos. No cabe ni una sola pieza más. Gracias.", TALKVOLUME_TALK);
            return;
        }
        else
        {
            int nGoldHeld = GetGold(oPC);

            if(nGoldHeld == 0)
            {
                SpeakString("¿Qué, me quieres dar eso?  ¡Aceptamos solamente oro en nuestro banco!");
                return;
            }

            else if (nGoldHeld >= 1)
            {
                    //int nAmount = (nBalance + nGoldHeld);
                    float fComi = Comisiones_Ingresos(nGoldHeld, nBalance, TRUE);
                    int nAmount = nBalance + (FloatToInt((1.0 - fComi) * IntToFloat(nGoldHeld)));
                    int iDif = 0;
                    if (nAmount >6000000)
                    {
                        iDif = nAmount - 6000000;
                        nAmount = 6000000;
                    }
                    SetCampaignInt("kpb_bank", "KPB_BANK_BALANCE", nAmount, oPC);
                    SetCampaignInt("kpb_bank", "KPB_DEPO_YEAR", iYear, oPC);
                    SetCampaignInt("kpb_bank", "KPB_DEPO_DAY", iDay, oPC);
                    SetCampaignInt("kpb_bank", "KPB_DEPO_MONTH", iMonth, oPC);
                    SpeakString("He añadido el oro a su cuenta. Gracias por su visita.");
                    TakeGoldFromCreature(nGoldHeld, oPC, TRUE);

                    ExportSingleCharacter(oPC);

                    //////VARGATH, CANTIDAD DE ORO AL LOG/////
                    string sCDKey = GetPCPublicCDKey(oPC);
                    string sAmount = IntToString(nAmount);
                    string sGoldHeld = IntToString(FloatToInt((1.0 -fComi) * IntToFloat(nGoldHeld)));//"1000";
                    if (iDif ==0)
                    {
                             WriteTimestampedLogEntry("[SISTEMA DE SEGURIDAD BANCARIO]: "
                             + GetName(oPC, TRUE) + ", es decir, " + GetPCPlayerName(oPC) + ", ha ingresado "
                             + sGoldHeld + " po en su cuenta bancaria tras el cobro de comisiones. Dinero total acumulado: " + sAmount + ".");
                    }
                    else if (iDif>0)
                    {

                            WriteTimestampedLogEntry("[SISTEMA DE SEGURIDAD BANCARIO]: "
                             + GetName(oPC, TRUE) + ", es decir, " + GetPCPlayerName(oPC) + ", ha ingresado "
                             + sGoldHeld + " po en su cuenta bancaria tras el cobro de comisiones. Dinero total acumulado: " + sAmount + ". Aunque se le devuelto un excedente de " + IntToString(iDif) + " po.");
                            SpeakString("Lo siento, no podemos ingresar en su cámara de depósito más de " + IntToString(StringToInt(sGoldHeld) - iDif) + " po. Gracias.", TALKVOLUME_TALK);
                            GiveXPToCreature (oPC, iDif);
                    }
            }
        }
    }
}
