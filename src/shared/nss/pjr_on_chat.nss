//::////////////////////////////////////////////////////////////////////////////
//:: Nombre del guion:  pjr_on_chat                                       //:://
//::////////////////////////////////////////////////////////////////////////////
//:: GUION OnPlayerChat PARA EL SERVIDOR PUERTA DE BALDUR                 //:://
//:: Creado por Monti                                                     //:://
//::////////////////////////////////////////////////////////////////////////////

#include "pjr_chat_inc"
#include "lib_disguise"
#include "nwnx_chat"
#include "nwnx_player"
#include "pb_nivellanzador"


void MakeEquippedItemVisible(object oPC, string sSlot, int iVisible=TRUE)
    {
    int iSlot = -1;
    if (GetStringLeft(sSlot, 1) == " ") sSlot = GetStringRight(sSlot, GetStringLength(sSlot)-1); //Añadimos el espacio
    if (sSlot == "ropas" || sSlot == "armadura" ) iSlot = INVENTORY_SLOT_CHEST; //ropas o armadura
    if (sSlot == "casco" || sSlot == "yelmo") iSlot = INVENTORY_SLOT_HEAD; //casco o yelmo
    if (sSlot == "capa") iSlot = INVENTORY_SLOT_CLOAK; //capa

    object oEquippedItem = GetItemInSlot(iSlot, oPC);

    if (!GetIsObjectValid(oEquippedItem) || iSlot == -1) SendMessageToPC(oPC, "<c´$$>¡Necesitas tener el objeto equipado para hacerlo visible o invisible!<c þ >");
    if (iSlot == INVENTORY_SLOT_CHEST && GetIsPC(oPC)) SendMessageToPC(oPC, "<c´$$>¡No puedes hacer invisible tu armadura!<c þ >");
    else {
        if (iVisible) { //Hacemos visible el item
            if (GetLocalInt(oEquippedItem, "NO_SHOWITEM")) SendMessageToPC(oPC, "<c´$$>Este item no se puede mostrar.<c þ >"); //Si tiene la variable "NO_SHOWITEM" no puede mostrarse.
            else if (GetHiddenWhenEquipped(oEquippedItem)) SetHiddenWhenEquipped(oEquippedItem, FALSE);
            else SendMessageToPC(oPC, "<c´$$>¡Este item ya esta visible!<c þ >");
        }
        else { //Ocultamos el item
            if (GetLocalInt(oEquippedItem, "NO_HIDEITEM")) SendMessageToPC(oPC, "<c´$$>Este item no se puede ocultar.<c þ >"); //Si tiene la variable "NO_HIDEITEM" no puede ocultarse.
            else if (!GetHiddenWhenEquipped(oEquippedItem))
                {
                    SetHiddenWhenEquipped(oEquippedItem, TRUE);
                    if(iSlot == INVENTORY_SLOT_HEAD && ObtenerIntPersistente(oPC,"Anonimo") > 0)
                    {
                        Disfrazarse_anonimo (oPC);
                        FloatingTextStringOnCreature("<c´$$>Al ocultar el casco/capucha se te hace visible el rostro.<c þ >", oPC, FALSE);
                    }
                }
            else SendMessageToPC(oPC, "<c´$$>¡Este item ya esta oculto!<c þ >");
        }
    }

  SetPCChatMessage("");
}

void main()
{
  object oPC = GetPCChatSpeaker();
  string sTexto = GetPCChatMessage();
  int iCasterLevel = GetCL(oPC);


  // HORA Y FECHA REAL
  if(sTexto == "_hora") {ExecuteScript("chat_hora", OBJECT_SELF); SetPCChatMessage("");}

  // MODO ESCRITURA (Crear libros o notas con texto)
  else if(GetLocalInt(oPC, "MODOESCRITURA") > 0) {ExecuteScript("chat_modoesc", OBJECT_SELF); SetPCChatMessage("");}

  // ATAQUE PODEROSO
  else if(GetStringLeft(sTexto, 2) == "AP" && GetHasFeat(1220, oPC)) {ExecuteScript("dote_atapod2", OBJECT_SELF); SetPCChatMessage("");}

  // PERICIA EN COMBATE
  else if(GetStringLeft(sTexto, 2) == "PC" && GetHasFeat(1223, oPC)) {ExecuteScript("dote_pericia2", OBJECT_SELF); SetPCChatMessage("");}

  // HABLAR POR ALIADOS
  else if(GetStringLeft(GetStringLowerCase(sTexto), 7) == "aliado_") {ExecuteScript("chat_habaliados", OBJECT_SELF); SetPCChatMessage("");}

  // DADOS MEDIANTE COMANDOS
  else if(GetStringLeft(sTexto, 2) == "!d") {ExecuteScript("chat_dados", OBJECT_SELF); SetPCChatMessage("");}

  // ELIMINAR INMUNIDAD DEL VAMPIRO SI SE TIENE
  else if(GetStringLeft(sTexto, 9) == "!vampsafe")
  {
    if(GetLocalInt(oPC, "dm_vampsafe") == 0)
    {
        SendMessageToPC(oPC, "No tienes el sistema activado sobre ti mismo.");
    }
    if(GetLocalInt(oPC, "dm_vampsafe") == 1)
    {
        DeleteLocalInt(oPC, "dm_vampsafe");
        SendMessageToPC(oPC, "El sistema de sol te vuelve a afectar.");
        SendMessageToAllDMs("El vampiro "+GetName(oPC,TRUE)+" ha desactivado por si mismo el sistema de inmunidad solar que le ha otorgado un DM.");
    }
    SetPCChatMessage("");
  }

  // IDIOMAS
  else if(GetLocalInt(oPC, "pr_speaking"))
  {
      int iLanguage = GetLocalInt(oPC,"pr_language");
      string sSpeaking = GetLanguageName(iLanguage);
      string sOutput=TranslateCommonToLanguage(iLanguage,sTexto);
      string sTranslate = TMESSAGE_TEXT + (PB_Disguise_GetNameOverride(oPC) == "" ? GetName(oPC) : PB_Disguise_GetNameOverride(oPC)) + " dice en " + sSpeaking + ": " + COLOR_LT_GREEN + sTexto + COLOR_END + COLOR_END;
      float fRange = 20.0;
      if(GetPCChatVolume() == TALKVOLUME_WHISPER) fRange = 3.0;

      object oListener = GetFirstObjectInShape(SHAPE_SPHERE, 30.0, GetLocation(oPC), TRUE, OBJECT_TYPE_ALL);
      while(GetIsObjectValid(oListener))
      {
          if(GetIsPC(oListener) && GetDistanceBetween(oPC, oListener) <= fRange)
          {
              if(GetIsDM(oListener) || GetIsDMPossessed(oListener) ||
                 GetHasSpellEffect(1128, oListener) || GetHasSpellEffect(1114, oListener) ||
                 GetHasFeat(1264, oListener) || GetLanguageWidgetMatch(oListener,iLanguage)) DelayCommand(0.3,SendMessageToPC(oListener,sTranslate));
          }
          oListener= GetNextObjectInShape(SHAPE_SPHERE, 30.0, GetLocation(oPC), TRUE, OBJECT_TYPE_ALL);
      }
      SetPCChatMessage(sOutput);
  }

  // DM: COMANDOS AVANZADOS DM
  else if(GetStringLeft(sTexto, 3) == "dm_" && GetIsDM(oPC)) {ExecuteScript("chat_consoladm", OBJECT_SELF); SetPCChatMessage("");}

  // DM: CAMBIO DE CONTRASENYA DE PJ
  else if(GetLocalInt(oPC, "SEG_CONCAMBIO")) {ExecuteScript("chat_segcondm", OBJECT_SELF); SetPCChatMessage("");}

  // MENSAJES COLOREADOS: Barrar of rol (rojo)
  else if(GetSubString(sTexto, 0, 1) == "/") SetPCChatMessage("<cþ<<>" + sTexto + "</c>");

  // MENSAJES COLOREADOS: Susurros (gris)
  else if(GetSubString(sTexto, 0, 4) == "*ss*") SetPCChatMessage("<c€€€>" + sTexto + "</c>");


  /*//OCULTAMOS EL NOMBRE SI TENEMOS CASCO
  else if (GetStringLeft(sTexto, 15) == "!ocultar nombre")
    {
    object oEquippedItem = GetItemInSlot(INVENTORY_SLOT_HEAD, oPC);
    int nAleatorio = Random(500);

        if(GetLocalInt(oPC, "HELM_ON") < 1 && GetIsObjectValid(oEquippedItem) && GetHiddenWhenEquipped(oEquippedItem) == FALSE)
        {
        PB_Disguise_SetNameOverride(oPC, "Desconocido"+ IntToString(nAleatorio), NWNX_RENAME_PLAYERNAME_OVERRIDE);
        FloatingTextStringOnCreature("Has ocultado tu rostro.", oPC, FALSE);
        SetLocalInt(oPC, "HELM_ON" , 1);
        }
        else if(GetHiddenWhenEquipped(oEquippedItem)) SendMessageToPC(oPC, "¡Necesitas tener el casco visible para ocultar tu rostro!");
        else SendMessageToPC(oPC, "¡Necesitas tener el casco equipado o ya tienes el rostro oculto!");

    SetPCChatMessage("");
    }  */

    /*//MOSTRAMOS EL NOMBRE SI LO TENEMOS OCULTO
  else if (GetStringLeft(sTexto, 15) == "!mostrar nombre")
    {
        if(GetLocalInt(oPC, "HELM_ON") > 0)
        {
        PB_Disguise_ClearNameOverride(oPC);
        FloatingTextStringOnCreature("Vuelves a mostrar tu rostro.", oPC, FALSE);
        DeleteLocalInt(oPC, "HELM_ON");
        }
        else SendMessageToPC(oPC, "¡No estas ocultando tu nombre!");

     SetPCChatMessage("");
    }*/

   //MODIFICAMOS EL NOMBRE DISFRAZADOS
   else if(GetStringLeft(sTexto, 10) == "!renombrar")
   {
       //Nada de nombres en blanco
       string sNombreReal = GetName(oPC, TRUE);
       string sNombre = GetStringRight(sTexto, GetStringLength(sTexto)-11);
       if(GetStringLength(sNombre) < 3 )
        {
          SendMessageToPC(oPC, "<c´$$>¡Debes escribir un nombre tras !renombrar de mínimo tres letras!</c>");
          SetPCChatMessage("");
          return;
        }
        //Nada de nombres usados
        string iPJExistente = GetCampaignString(ObjectToString(GetModule()), sNombre);
        if(iPJExistente == "Existe")
        {
          SendMessageToPC(oPC, "<c´$$>¡No puedes usar el nombre de otro personaje!</c>");
          SetPCChatMessage("");
          return;
        }

        //Solo si estamos disfrazados
        if (ObtenerIntPersistente(oPC,"Disfrazado")> 0)
            {
                WriteTimestampedLogEntry("Informe: El PJ: " + sNombreReal + " de la cuenta: "  + GetPCPlayerName(oPC) + " se ha disfrazado de : " + sNombre + ".");
                SendMessageToPC(oPC, "<c þ >Ahora te llamas: " +sNombre+ "</c>");
                SendMessageToPC(oPC, "<c þ >Seteado el nuevo nombre que usará la identidad " +IntToString(ObtenerIntPersistente(oPC,"Disfrazado"))+ "</c>");
                GuardarStringPersistente(oPC,"DisfrazNombre"+IntToString(ObtenerIntPersistente(oPC,"Disfrazado")),sNombre);
                GuardarStringPersistente(oPC,"Disfrazado_nombre", sNombre);
                PB_Disguise_SetNameOverride(oPC, sNombre, NWNX_RENAME_PLAYERNAME_OVERRIDE);
                DelayCommand(1.0, PB_Disguise_SetNameOverride(oPC, sNombre, NWNX_RENAME_PLAYERNAME_OVERRIDE));
            }
        else SendMessageToPC(oPC, "<c´$$>¡Debes estar disfrazado!</c>");

      SetPCChatMessage("");
  }
  //Comando de Debug
  else if (GetStringLeft(sTexto, 4) == "!ecl") {
    SendMessageToPC(oPC,"Nivel de Lanzador: "+ IntToString(iCasterLevel));
    SetPCChatMessage("");
  }
  //OCULTAR MOSTRAR CASCO, ARMADURA, CAPA
  else if (GetStringLeft(sTexto, 8) == "!ocultar") MakeEquippedItemVisible(oPC, GetStringRight(sTexto, GetStringLength(sTexto)-8), FALSE);
  else if (GetStringLeft(sTexto, 8) == "!mostrar") MakeEquippedItemVisible(oPC, GetStringRight(sTexto, GetStringLength(sTexto)-8));
  else if (GetStringLeft(sTexto, 8) == "!caminar") {
    int bWalk = !GetLocalInt(oPC, "WALK_MODE");
    FloatingTextStringOnCreature("*Se ha " + (bWalk ? "activado" : "desactivado") + " el Modo Caminar (Correr " + (bWalk ? "desactivado" : "activado") + ")*", oPC, FALSE);
    SetLocalInt(oPC, "WALK_MODE", bWalk);
    SetActionMode(oPC, ACTION_MODE_STEALTH, FALSE);
    NWNX_Player_SetAlwaysWalk(oPC, bWalk);

    SetPCChatMessage("");
  }

  // MENSAJES COLOREADOS: Acciones (azul) y Pensamientos (verde claro)
  else
  {
      string sMensajeFinal;
      int iEncontradoAsterisco = FALSE;
      int iEncontradoParentesis = 0;
      int iEmocionesUnaSolaVez = 0;

      while(GetStringLength(sTexto) > 0)
      {
          if(GetStringLeft(sTexto, 1) == "*")
          {
              if(iEmocionesUnaSolaVez == 0)
              {
                  iEmocionesUnaSolaVez = 1;
                  ExecuteScript("chat_emociones", OBJECT_SELF);
              }
              if(iEncontradoAsterisco == TRUE)
              {
                  iEncontradoAsterisco = FALSE;
                  sMensajeFinal = sMensajeFinal + GetStringLeft(sTexto, 1) + "</c>";
              }
              else if(iEncontradoAsterisco == FALSE)
              {
                  iEncontradoAsterisco = TRUE;
                  sMensajeFinal = sMensajeFinal + "<c!}þ>" + GetStringLeft(sTexto, 1);
              }
          }

          else if(GetStringLeft(sTexto, 1) == "(")
          {
              sMensajeFinal = sMensajeFinal + "<cQ‹8>" + GetStringLeft(sTexto, 1);
              iEncontradoParentesis++;
          }
          else if(GetStringLeft(sTexto, 1) == ")")
          {
              if(iEncontradoParentesis > 0)
              {
                  sMensajeFinal = sMensajeFinal + GetStringLeft(sTexto, 1) + "</c>";
                  iEncontradoParentesis--;
              }
              else sMensajeFinal = sMensajeFinal + GetStringLeft(sTexto, 1);
          }
          else sMensajeFinal = sMensajeFinal + GetStringLeft(sTexto, 1);

          sTexto = GetStringRight(sTexto, GetStringLength(sTexto)-1);
      }

      if(sMensajeFinal != "") SetPCChatMessage(sMensajeFinal);
  }
}
