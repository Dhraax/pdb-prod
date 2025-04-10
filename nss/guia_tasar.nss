// Tasar objetos
// By Monti, 27/12/13
#include "nwnx_item"

void main()
{
    object oPC = GetPCSpeaker();
    object oObjetivo =  GetLocalObject(oPC, "GUIAPB_OBJETIVO");

    // Errores
    // 1.1 No es un objeto
    if(GetObjectType(oObjetivo) != OBJECT_TYPE_ITEM)
    {
        SendMessageToPC(oPC, "<cþ<<>[TASAR] El objetivo no era un objeto válido para ser tasado.</c>");
        return;
    }
    // 1.2 No está identificado
    else if(!GetIdentified(oObjetivo))
    {
        SendMessageToPC(oPC, "<cþ<<>[TASAR] No puedes tasar objetos no identificados.</c>");
        return;
    }

    // 1.3 El objeto es de trama y no tiene valor
    else if(GetPlotFlag(oObjetivo))
    {
        if(GetIdentified(oObjetivo))
        {
            //Indicamos al jugador de qué nivel es el item.
            SendMessageToPC(oPC, "<c þ >Este objeto pide como mínimo nivel "+IntToString(NWNX_Item_GetMinEquipLevel(oObjetivo))+" para ser usado.</c>");
        }
        SendMessageToPC(oPC, "<cþ<<>[TASAR] No puedes tasar objetos de trama ya que no tienen 'valor'.</c>");
        return;
    }

    // 1.4 Ya lo hemos tasado
    else if(GetLocalInt(oPC, "TASADO_VALOR_" + GetName(oObjetivo)) > 0)
    {
        //Antes de la negativa, siempre le decimos a los jugadores qué nivel pide el item.
        SendMessageToPC(oPC, "<c þ >Este objeto pide como mínimo nivel "+IntToString(NWNX_Item_GetMinEquipLevel(oObjetivo))+" para ser usado.</c>");

        //Pasamos a la tasación.
        int iValor = GetLocalInt(oPC, "TASADO_VALOR_" + GetName(oObjetivo));
        if(iValor == 888888888) SendMessageToPC(oPC, "<cþ<<>[TASAR] Ya has intentado tasar "+GetName(oObjetivo)+" anteriormente y no lo lograste.</c>");
        else if(iValor == 999999999) SendMessageToPC(oPC, "<cþ<<>[TASAR] Ya has tasado "+GetName(oObjetivo)+" anteriormente, su valor estimado es de 0 po.</c>");
        else SendMessageToPC(oPC, "<cþ<<>[TASAR] Ya has tasado "+GetName(oObjetivo)+" anteriormente, su valor estimado es de "+IntToString(iValor)+" po.</c>");
        return;
    }

    // Variables
    int iTasacion = GetSkillRank(SKILL_APPRAISE, oPC);
    int iSinergiaArtesania = 0;
    if(GetSkillRank(22, oPC, TRUE) / 5 >= 1) iSinergiaArtesania = 2;
    int iOro = GetGoldPieceValue(oObjetivo) + GetGoldPieceValue(oObjetivo) / 2;
    int iError = FloatToInt(IntToFloat(iOro) * (IntToFloat(Random(10)+5) / 10.0));
    int iTirada = d20() + iTasacion + iSinergiaArtesania;
    int iCD, iValor;

    if(iOro < 1000) iCD = 12;
    else if(iOro < 2000) iCD = 15;
    else if(iOro < 5000) iCD = 18;
    else if(iOro < 10000) iCD = 20;
    else if(iOro < 15000) iCD = 22;
    else if(iOro < 20000) iCD = 25;
    else if(iOro < 25000) iCD = 28;
    else if(iOro < 30000) iCD = 30;
    else if(iOro < 40000) iCD = 32;
    else if(iOro < 50000) iCD = 35;
    else if(iOro < 65000) iCD = 38;
    else if(iOro < 75000) iCD = 40;
    else if(iOro < 100000) iCD = 42;
    else if(iOro < 130000) iCD = 45;
    else if(iOro < 250000) iCD = 48;
    else iCD = 50;

    // Animaciones
    FloatingTextStringOnCreature("<cßþ>* Examinando el objeto *</c>", oPC);
    AssignCommand(oPC, ClearAllActions(TRUE));
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.2, 10.0));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oPC, 10.0);

    // Tiradas
    if(GetSkillRank(SKILL_APPRAISE, oPC, TRUE) == 0) // No entrenada
    {
        if(iTirada >= iCD) // Exito
        {
            DelayCommand(10.0, SendMessageToPC(oPC, "<c›þþ>[TASAR: "+IntToString(iTirada)+" vs CD "+IntToString(iCD)+": Éxito] El valor estimado de "+GetName(oObjetivo)+" es de "+IntToString(iError)+" po.</c>"));
            iValor = iError;
        }
        else // Fallo
        {
            DelayCommand(10.0, SendMessageToPC(oPC, "<c›þþ>[TASAR: "+IntToString(iTirada)+" vs CD "+IntToString(iCD)+": Fracaso] No logras tasar "+GetName(oObjetivo)+".</c>"));
            iValor = 888888888;
        }
    }
    else // Si entrenada
    {
        if(iTirada >= iCD) // Exito
        {
            DelayCommand(10.0, SendMessageToPC(oPC, "<c›þþ>[TASAR: "+IntToString(iTirada)+" vs CD "+IntToString(iCD)+": Éxito] El valor estimado de " + GetName(oObjetivo) + " es de " + IntToString(iOro) + " po.</c>"));
            iValor = iOro;
        }
        else // Fallo
        {
            DelayCommand(10.0, SendMessageToPC(oPC, "<c›þþ>[TASAR: "+IntToString(iTirada)+" vs CD "+IntToString(iCD)+": Fracaso] El valor estimado de " + GetName(oObjetivo) + " es de " + IntToString(iError) + " po.</c>"));
            iValor = iError;
        }
    }

    // No más intentos
    if(iValor == 0) iValor = 999999999;
    SetLocalInt(oPC, "TASADO_VALOR_" + GetName(oObjetivo), iValor);

    //Indicamos al jugador de qué nivel es el item.
    SendMessageToPC(oPC, "<c þ >Este objeto pide como mínimo nivel "+IntToString(NWNX_Item_GetMinEquipLevel(oObjetivo))+" para ser usado.</c>");
}

