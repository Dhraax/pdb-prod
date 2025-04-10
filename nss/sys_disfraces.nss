#include "lib_disguise"
#include "pb_constantes"

void main()
{
    object oPC = GetPCSpeaker();
    object oTarget = GetLocalObject(oPC, "DISFRAZ_ITEM");
    string sNombreReal = GetName(oTarget, TRUE);
    //string sNombreFalso = PB_Disguise_GetNameOverride(oTarget);
    object oSpam = GetLocalObject(oPC, sNombreReal);
    int iModo = StringToInt(GetScriptParam("Modo"));
    int iDisfraz = StringToInt(GetScriptParam("Disfraz"));


    //Modo 1: Intentamos descubrir al objetivo seleccionado.
    if(iModo == 1)
    {
        //Si no apuntamos contra una criatura...
        if(GetObjectType(oTarget)!=OBJECT_TYPE_CREATURE)
        {SendMessageToPC(oPC, "<c´$$>El objetivo no es un objeto válido.</c>"); return;}

        //Si el personaje no está disfrazado... y además no está poliformado.
        if (ObtenerIntPersistente(oTarget,"Disfrazado") == 0 && GetLocalInt(oTarget, "POLY_ON") < 1)
        {SendMessageToPC(oPC, "<c´$$>El objetivo no está disfrazado.</c>"); return;}

        //Solo lo podemos intentar una vez y si tenemos rangos en avistar
        if(oSpam == oTarget) { SendMessageToPC(oPC, "<c´$$>Ya has investigado a esta criatura...</c>"); return; }
        if(GetSkillRank(17, oPC) == 0) { FloatingTextStringOnCreature("No ves nada raro.", oPC, FALSE); return; }

        //Si el personaje sí está disfrazado.
        else if (ObtenerIntPersistente(oTarget,"Disfrazado")>= 1)
        {
            //Preparamos las tiradas.
            int CD = ObtenerIntPersistente(oTarget,"CD"); //Cuando un jugador se disfraza, hace una tirada, que se quedará permanente hasta el próximo disfraz.
            int Tirada = d20() + GetSkillRank(SKILL_SPOT,oPC); //d20 + Avistar.

            //Si se supera la tirada...
            //if(Tirada > CD && GetLevelByClass(CLASS_TYPE_SHIFTER, oTarget) == 0 && GetLevelByClass(CLASS_TYPE_DRUID, oTarget) < 5)
            //Si el PJ no está poliformado de ninguna forma.
            if(Tirada > CD && (ObtenerIntPersistente(OBJECT_SELF, "APA_CAMBIADA") == FALSE && ObtenerIntPersistente(oPC, "APTITUD_POLY_RAZA") == FALSE))
            {
                if(Tirada - CD > 5)
                {
                    SendMessageToPC(oPC, "<c þ >¡Has descubierto el disfraz de "+sNombreReal+"!</c>");
                    SendMessageToPC(oPC, "<c´$$>¡Alguien ha descubierto tu disfraz y te ha reconocido!</c>");
                    WriteTimestampedLogEntry("**SISTEMA DE DISFRACES** El personaje: "+GetName(oPC)+", descubre al personaje: "+GetName(oTarget)+", el cual iba disfrazado como "+PB_Disguise_GetNameOverride(oTarget)+".");
                }
                //Si no se supera...
                else
                {
                    SendMessageToPC(oPC, "<c þ >¡Has descubierto el disfraz! Aunque no reconoces sus facetas reales...</c>");
                    SendMessageToPC(oPC, "<c´$$>¡Alguien ha descubierto que vas disfrazado! Pero no te ha reconocido.</c>");
                }
            }
            //Si es cambiante menor de 10 y está poliformado, Druida mayor de 5 y está poliformado o estamos usando el poliformar racial usamos Vision Verdadera
            else if(GetHasSpellEffect(186, oPC) == TRUE && GetLevelByClass(CLASS_TYPE_SHIFTER, oTarget) > 0 && GetLevelByClass(CLASS_TYPE_SHIFTER, oTarget) < 10 && ObtenerIntPersistente(OBJECT_SELF, "APA_CAMBIADA") == TRUE ||   //Cambiante poliformado
            GetHasSpellEffect(186, oPC) == TRUE && GetLevelByClass(CLASS_TYPE_DRUID, oTarget) > 5 && ObtenerIntPersistente(OBJECT_SELF, "APA_CAMBIADA") == TRUE ||  //Druida poliformado
            GetHasSpellEffect(186, oPC) == TRUE && GetLevelByClass(CLASS_TYPE_MAESTRO_FORMAS, oTarget) > 0 && GetLevelByClass(CLASS_TYPE_MAESTRO_FORMAS, oTarget) < 10 && (ObtenerIntPersistente(OBJECT_SELF, "APA_CAMBIADA") == TRUE || ObtenerIntPersistente(OBJECT_SELF, "POLYMORPHED") == TRUE) ||   //MMF poliformado
            GetHasSpellEffect(186, oPC) == TRUE && ObtenerIntPersistente(oPC, "APTITUD_POLY_RAZA") == TRUE) //Razas con poliformar
            {

                if(ObtenerIntPersistente(OBJECT_SELF, "POLYMORPHED") == TRUE)
                {
                    object oContainer = GetItemPossessedBy(oPC,"dmfi_pc_emote");
                    json jOldData = GetLocalJson(oContainer,"OLD_DATA");
                    int iRacialType = JsonGetInt(JsonObjectGet(jOldData,"RacialType"));
                    int iTLKLinea = StringToInt(Get2DAString("racialtypes", "Name", iRacialType));
                    string sRaza = GetStringByStrRef(iTLKLinea);
                    SendMessageToPC(oPC, "<c þ >¡Has descubierto la forma real, es un "+sRaza+"!</c>");
                    SendMessageToPC(oPC, "<c´$$>¡Alguien ha descubierto tu verdadera forma!</c>");
                }
                if(ObtenerIntPersistente(OBJECT_SELF, "APA_CAMBIADA") == TRUE || ObtenerIntPersistente(oPC, "APTITUD_POLY_RAZA") == TRUE)
                {
                    int iRacialType = ObtenerIntPersistente(oPC, "APTITUD_POLY_RAZA_ORIGINAL");
                    int iTLKLinea = StringToInt(Get2DAString("racialtypes", "Name", iRacialType));
                    string sRaza = GetStringByStrRef(iTLKLinea);
                    SendMessageToPC(oPC, "<c þ >¡Has descubierto la forma real, es un "+sRaza+"!</c>");
                    SendMessageToPC(oPC, "<c´$$>¡Alguien ha descubierto tu verdadera forma!</c>");
                }

            }
            //Si es cambiante 10 usamos Vision Verdadera pero no sabemos quien es
            else if(GetHasSpellEffect(186, oPC) == TRUE && GetLevelByClass(CLASS_TYPE_SHIFTER, oTarget) == 10 && ObtenerIntPersistente(OBJECT_SELF, "APA_CAMBIADA") == TRUE ||
            GetHasSpellEffect(186, oPC) == TRUE && GetLevelByClass(CLASS_TYPE_SHIFTER, oTarget) == 10 && (ObtenerIntPersistente(OBJECT_SELF, "APA_CAMBIADA") == TRUE || ObtenerIntPersistente(OBJECT_SELF, "POLYMORPHED") == TRUE))
            {
                SendMessageToPC(oPC, "<c þ >¡Puedes ver una forma incorpórea, pero no logras discernir que es!</c>");
                SendMessageToPC(oPC, "<c´$$>¡Alguien te ha discernido con Visión Verdadera!</c>");
            }
                //Si no cumplimo nada, no vemos nada
            else
            FloatingTextStringOnCreature("No ves nada raro.", oPC, FALSE);
        }
        //Solo una vez cada 10 minutos
        SetLocalObject(oPC, sNombreReal, oTarget);
        DelayCommand(600.0, DeleteLocalInt(oPC, sNombreReal));
        return;
    }
    //Modo 2: Nos ponemos en modo anónimo.
    if(iModo == 2)
    {
        Disfrazarse_anonimo (oPC, FALSE);
        return;
    }
    //Modo 3: Seteo de identidades.
    if(iModo == 3)
    {
        Disfrazarse_Setear (oPC, iDisfraz);
        return;
    }
    //Modo 4: Disfrazarse
    if(iModo == 4)
    {
        Disfrazarse_disfraz (oPC, iDisfraz);
        return;
    }
    //Modo 5: Disfrazarse
    if(iModo == 5)
    {
        string NombreDisfraz1 = ObtenerStringPersistente(oPC,"DisfrazNombre1");
        string NombreDisfraz2 = ObtenerStringPersistente(oPC,"DisfrazNombre2");
        string NombreDisfraz3 = ObtenerStringPersistente(oPC,"DisfrazNombre3");
        string NombreDisfraz4 = ObtenerStringPersistente(oPC,"DisfrazNombre4");

        if(NombreDisfraz1 == "") {NombreDisfraz1 = "Sin setear";}
        if(NombreDisfraz2 == "") {NombreDisfraz2 = "Sin setear";}
        if(NombreDisfraz3 == "") {NombreDisfraz3 = "Sin setear";}
        if(NombreDisfraz4 == "") {NombreDisfraz4 = "Sin setear";}

        NWNX_Player_SetCustomToken(oPC,15001,NombreDisfraz1);
        NWNX_Player_SetCustomToken(oPC,15002,NombreDisfraz2);
        NWNX_Player_SetCustomToken(oPC,15003,NombreDisfraz3);
        NWNX_Player_SetCustomToken(oPC,15004,NombreDisfraz4);
        return;
    }
    //Modo 6: Apariencias de items.
    if(iModo == 6)
    {
        RevertirRopa (oPC, oTarget, iDisfraz);
        return;
    }
    //Miramos la apariencia del item que estamos usando.
    if(iModo == 7)
    {
        int iVersion = GetLocalInt(oTarget,"Version");
        string sVersion1, sVersion2, sVersion3, sVersion4, sVersion5;
        if(iVersion == 1) {sVersion1 = "APLICADO.";}
        else if(iVersion != 1) {sVersion1 = "";}
        if(iVersion == 2) {sVersion2 = "APLICADO.";}
        else if(iVersion != 2) {sVersion2 = "";}
        if(iVersion == 3) {sVersion3 = "APLICADO.";}
        else if(iVersion != 3) {sVersion3 = "";}
        if(iVersion == 4) {sVersion4 = "APLICADO.";}
        else if(iVersion != 4) {sVersion4 = "";}
        if(iVersion == 5) {sVersion5 = "APLICADO.";}
        else if(iVersion != 5) {sVersion5 = "";}

        string sItemName = "No seleccionado";
        if(GetIsObjectValid(oTarget)){sItemName = GetName(oTarget);}

        NWNX_Player_SetCustomToken(oPC,15005,sVersion1);
        NWNX_Player_SetCustomToken(oPC,15006,sVersion2);
        NWNX_Player_SetCustomToken(oPC,15007,sVersion3);
        NWNX_Player_SetCustomToken(oPC,15008,sVersion4);
        NWNX_Player_SetCustomToken(oPC,15009,sVersion5);
        NWNX_Player_SetCustomToken(oPC,15010,sItemName);
        return;
    }
}
