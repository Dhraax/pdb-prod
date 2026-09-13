#include "nwnx_chat"
#include "cnr_i_craft"

void main()
{
    object oPC = NWNX_Chat_GetSender();
    object oTarget = NWNX_Chat_GetTarget();
    int iCanal = NWNX_Chat_GetChannel();
    string sTexto = NWNX_Chat_GetMessage();

    // CNR: while a crafting station is active, a bare number selects a
    // recipe by public id and must not be emitted to chat.
    if (GetIsObjectValid(GetLocalObject(oPC, CNR_VAR_PLACEABLE))
        && CnrCraft_CaptureTypedId(oPC, sTexto))
    {
        NWNX_Chat_SkipMessage();
        return;
    }

    // EVITAMOS VERDES SI ESTAMOS EN DESCONOCIDO.
    if (iCanal == NWNX_CHAT_CHANNEL_PLAYER_TELL && GetLocalInt(oPC, "HELM_ON"))
    {
        NWNX_Chat_SkipMessage();
        SendMessageToPC(oPC, "No puedes enviar verdes estando con el rostro oculto.");
    }

    // GRITOS EN AREA, SOLO PARA DMS.
    if (GetStringLeft(sTexto, 4) == "_dma" && (GetIsDM(oPC) || GetIsDMPossessed(oPC)))
    {
        //Solo en los canales: DM, gritar y hablar.
        if(iCanal == NWNX_CHAT_CHANNEL_DM_DM || iCanal == NWNX_CHAT_CHANNEL_DM_SHOUT || iCanal == NWNX_CHAT_CHANNEL_DM_TALK ||
            iCanal == NWNX_CHAT_CHANNEL_PLAYER_DM || iCanal == NWNX_CHAT_CHANNEL_PLAYER_SHOUT || iCanal == NWNX_CHAT_CHANNEL_PLAYER_TALK)
        {
            // Hacemos que el mensaje no se envíe al chat global.
            NWNX_Chat_SkipMessage();

            object oArea = GetArea(oPC);

            // Eliminar el comando "_dma " del mensaje
            sTexto = GetSubString(sTexto, 5, GetStringLength(sTexto) - 5);

            // MENSAJES COLOREADOS
            if (GetSubString(sTexto, 0, 1) == "/")
            {
                sTexto = "<cþ<<>" + sTexto + "</c>";
            }

            // ENVIAR MENSAJE A JUGADORES EN EL MISMO ÁREA
            object oPlayer = GetFirstPC();
            while (GetIsObjectValid(oPlayer))
            {
                if (GetArea(oPlayer) == oArea)
                {
                    //Si no es un DM y el canal usado es el canal DM, no enviamos mensaje a ese jugador.
                    if(!GetIsDM(oPlayer) && (iCanal == NWNX_CHAT_CHANNEL_DM_DM || iCanal == NWNX_CHAT_CHANNEL_PLAYER_DM)) return;
                    NWNX_Chat_SendMessage(iCanal, sTexto, oPC, oPlayer);
                }
                oPlayer = GetNextPC();
            }
        }
    }

    // COMANDOS PARA IR Y TRAER JUGADORES MEDIANTE PRIVADOS.
    if (GetStringLeft(sTexto, 5) == "dm_ir" && (GetIsDM(oPC) || GetIsDMPossessed(oPC)) && (iCanal == NWNX_CHAT_CHANNEL_DM_TELL || iCanal == NWNX_CHAT_CHANNEL_PLAYER_TELL))
    {
        // Hacemos que el mensaje no se envíe al chat global.
        NWNX_Chat_SkipMessage();
        DelayCommand(0.2, AssignCommand(oPC, ClearAllActions()));
        DelayCommand(0.3, AssignCommand(oPC, ActionJumpToLocation(GetLocation(oTarget))));
    }

    // COMANDOS PARA IR Y TRAER JUGADORES MEDIANTE PRIVADOS.
    if (GetStringLeft(sTexto, 8) == "dm_traer" && (GetIsDM(oPC) || GetIsDMPossessed(oPC)) && (iCanal == NWNX_CHAT_CHANNEL_DM_TELL || iCanal == NWNX_CHAT_CHANNEL_PLAYER_TELL))
    {
        // Hacemos que el mensaje no se envíe al chat global.
        NWNX_Chat_SkipMessage();
        DelayCommand(0.2, AssignCommand(oTarget, ClearAllActions()));
        DelayCommand(0.3, AssignCommand(oTarget, ActionJumpToLocation(GetLocation(oPC))));
    }
}
