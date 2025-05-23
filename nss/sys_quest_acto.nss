#include "mti_libreria"
#include "nwnx_player"

void main()
{
    object oPC = GetPCSpeaker();
    object oPNJ = OBJECT_SELF;

    //Siempre quitamos al PJ del grupo, para evitar problemas al dar premios y demasía.
    RemoveFromParty(oPC);
    ///////////////////////////////////////////////////////////
    //Leemos los parámetros configurables en la conversación.//
    ///////////////////////////////////////////////////////////
    //Leemos el nombre de la quest.
    string sTrama = GetScriptParam("NombreQuest");
    //Por si hay llave.
    string sLlave = GetScriptParam("Llave");
    //Leemos del jugador el estado de la quest.
    int iTrama = ObtenerIntPersistente(oPC,sTrama);
    //Si hay oro, leemos cuanto.
    int iOro = StringToInt(GetScriptParam("Oro"));
    //Si damos PX como premio, leemos la cantidad.
    int iPX = StringToInt(GetScriptParam("PX"));
    //Si hay que dar un objeto como premio, leemos su etiqueta.
    string sObjeto = GetScriptParam("Objeto");
    //Si hay que retirar un item...
    string sRetirar = GetScriptParam("Retirar");
    //Si tenemos que hacer tiradas de habilidad.
    string sHabilidad = GetScriptParam("Habilidad");
    int iHab, iCD;
    //Requerimos de un alineamiento.
    string sAlineamiento = GetScriptParam("Alineamiento");
    int iAlineamiento = StringToInt(sAlineamiento);
    int iAlineamientoCantidad =  StringToInt(GetScriptParam("AlineamientoCantidad"));

    ////////////////////////////////////////////////
    //Hacemos los cambios, damos lo que haga falta//
    ////////////////////////////////////////////////
    //Si hay que hacer tirada de habs.
    if(sHabilidad != "")
    {
        iHab = StringToInt(GetScriptParam("Habilidad"));
        iCD = StringToInt(GetScriptParam("CD"));
    }
    //Si no se pide habilidad para seguir, aumentamos la var sin más.
    if(sHabilidad == "")
    {
        //Avanzamos la quest con una variable
        GuardarIntPersistente(oPC,sTrama,iTrama+1);
    }
    //Si pedimos la hab para seguir, hacemos tirada y si la supera, pues le damos la var. Solo tenemos un intento por reinicio.
    if(sHabilidad != "" && GetLocalInt(oPC,GetTag(oPNJ)) != 1)
    {
        if(GetIsSkillSuccessful(oPC, iHab, iCD)) {GuardarIntPersistente(oPC,sTrama,iTrama+1);}
        else
        {
            SetLocalInt(oPC,GetTag(oPNJ),1);
            SendMessageToPC(oPC,"<c´$$>Has fracasado la tirada enfrentada, no podrás volver a intentarlo hasta el siguiente reinicio.</c>");
        }
    }
    //Si cambiamos el alineamiento.
    if(sAlineamiento != "")
    {
        AdjustAlignment(oPC,iAlineamiento,iAlineamientoCantidad, FALSE);
    }

    //Le damos la llave al jugador.
    CreateItemOnObject(sLlave,oPC,1);
    //Le damos el oro.
    GiveGoldToCreature(oPC,iOro);
    //Le damos PX
    SetXP(oPC,GetXP(oPC)+iPX);
    //Le damos el objeto
    CreateItemOnObject(sObjeto,oPC,1);
    //Borramos el item necesario.
    DestruirItemsInventario(oPC,sRetirar,2);
    SendMessageToPC(oPC,"<c þ >¡Actualizado el estado de la quest!</c>");
    //Sonido a reproducir.
    int iSonido = StringToInt(GetScriptParam("Sonido"));
    if(iSonido == 1){NWNX_Player_PlaySound(oPC,"GUI_QUEST_DONE", oPC);}
    if(iSonido == 2){NWNX_Player_PlaySound(oPC,"GUI_JOURNALAAD", oPC);}
    if(iSonido == 3){NWNX_Player_PlaySound(oPC,"GUI_LEVEL_UP", oPC);}
}

