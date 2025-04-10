#include "nwnx_creature"
#include "pb_fecha_inc"
#include "mti_libreria"
#include "chat_dm_areas"
#include "pb_constantes"
#include "nwnx_object"
#include "lib_disguise"


//Aplicamos el daño por asalto definido en dm_dañoasalto
void ApplyRoundDamage(object oObjetivo)
{
    int iVariable = GetLocalInt(oObjetivo, "DAMAGE_ROUND");
    int iHitPoints = GetCurrentHitPoints(oObjetivo);

    if(iVariable > 0)
    {
        SetCurrentHitPoints(oObjetivo, iHitPoints - iVariable);
        DelayCommand(6.0, ApplyRoundDamage(oObjetivo));
    }
    else return;
}

void main()
{
    object oPC = GetPCChatSpeaker();
    string sTexto = GetPCChatMessage();
    object oDMFIObjetivo = GetLocalObject(oPC, "dmfi_univ_target");

    // Ayuda
    if(GetStringLeft(sTexto, 8) == "dm_ayuda")
    {
        SendMessageToPC(oPC, "<c?þ>Comandos DM por chat</c>");
        SendMessageToPC(oPC, "<c´þd>------------------------</c>");
        SendMessageToPC(oPC, "<c´þd>Lo primero de todo: selecciona un objetivo, usa para ello la varita DMFI de objetivo.</c>");
        SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_dardote' + 'ID de la dote'</c> para dar dotes al objetivo</c>");
        SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_quitardote' + 'ID de la dote'</c> para eliminar dotes al objetivo</c>");
        SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_nombre' + 'Nombre deseado'</c> para aplicar el nombre escogido al objetivo.</c>");
        SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_descripcion' + 'Descripción deseada'</c> para aplicar la descripción escogida al objetivo</c>");
        SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_hablar' + 'Frase deseada'</c> para que el objetivo hable lo deseado</c>");
        SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_apariencia' + 'ID de la apariencia'</c> para cambiar la apariencia al objetivo</c>");
        SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_planar'</c> para teleportar al jugador a la Bolsa Plana</c>");
        SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_teleport' + 'Etiqueta de un Punto de Ruta conocido'</c> para teleportar al punto de ruta seleccionado</c>");
        SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_planargrupo'</c> para teleportar a todo el grupo del jugador a la Bolsa Planar</c>");
        SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_traergrupo'</c> para teleportar a todo el grupo del jugador hacia ti</c>");
        SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_darxpgrupo' + 'cantidad'</c> para dar XP a todo el grupo del jugador</c>");
        SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_darorogrupo' + 'cantidad'</c> para dar Oro a todo el grupo del jugador</c>");
        SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_darcanatural' + 'cantidad'</c> para dar CA a una criatura</c>");
        SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_voz' + 'ID del conjunto de voz'</c> para cambiar las voces al objetivo.</c>");
        SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_pasos' + 'ID del sonido de pasos'</c> para cambiar el sonido de pasos al objetivo</c>");
        SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_fecha'</c> para obtener la fecha de creación del PJ objetivo</c>");
        SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_deidad' + 'Nombre de la deidad'</c> para cambiar la deidad del PJ objetivo</c>");
        SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_idioma'</c> para que el idioma cláseo objetivo no desaparezca aunque no le corresponda (mérito de rol)</c>");
        SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_resetbrujo'</c> para eliminar todas las invocaciones y pueda volver a seleccionarlas</c>");
        SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_escalar' + 'cantidad'</c> para cambiar el tamaño de una criatura o ubicado 1.5 aumenta en un 50%</c>");
        SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_guardar'</c> Guarda la criatura para recuperarla tras reinicio.</c>");
        SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_resetfacciones'</c> para reiniciar las facciones del objetivo.</c>");
        SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_area_ayuda'</c> Ver el menú de ayuda de las herramientas de gestión de áreas.</c>");
        //SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ >Usa la función 'dm_dominio' + 'Posicion Dominio (1 o 2)' + 'ID del dominio'</c> para aplicar un dominio a la criatura clérigo objetivo.</c>");
        SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ >Usa la función 'dm_genero' + 'ID del género'</c> paraaplicar un género al objetivo. 0 = Hombre; 1= Mujer;</c>");
        //SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ >Usa la función 'dm_espmagia' + 'ID de la especialización mágica'</c> para aplicar una especialización mágica al objetivo.</c>");
        SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función 'dm_tamaño' + 'ID del tamanyo'</c> para aplicar un tamaño al objetivo.</c>");
        SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_dañoarea' + 'cantidad'</c> Para hacer'd6*cantidad' a todos los miembros del grupo en el mismo area.</c>");
        SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_dañoasalto' + 'cantidad'</c> Para hacer esa cantidad de daño por asalto al objetivo.</c>");
        SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_quitardaño' Para dejar de hacer daño por asalto al objetivo.</c>");
        SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_limpiardaño'</c> Para eliminar daño magico por asalto a todos los jugadores del area.</c>");
        SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_resetraza'</c> Para reiniciar los ajustes de la raza del jugador.</c>");
        SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_ubicado'</c> Para modificar la apariencia de un ubicado.</c>");
        SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_niveles'</c> Para ver la tabla de subidas de nivel de un jugador.</c>");
        SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_names'</c> Para que se te actualice los nombres de los PJs.</c>");
        SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_real'</c> Para ver el nombre real del PJ y de jugador..</c>");
        SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_vida' + 'cantidad'</c> Para hacer esa cantidad de daño por asalto al objetivo.</c>");
        SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_avampsafe'</c> Para hacer este área segura para los vampiros.</c>");
        SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_ir'</c> en un mensaje privado al objetivo para saltar al receptor del privado.</c>");
        SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_traer'</c> en un mensaje privado al objetivo para traer al receptor del privado.</c>");
        SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> '_dma' + 'texto'</c> Para enviar un grito (en el canal que desees, puedes usar cualquier canal) a los jugadores que estén en tu mismo área.</c>");
        SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_ia'</c> Para añadir IA a una criatura.</c>");
    }

    // Funcion dar dote
    else if(GetStringLeft(sTexto, 10) == "dm_dardote")
    {
        if(GetIsObjectValid(oDMFIObjetivo) == FALSE) {SendMessageToPC(oPC, "<cþ<<>No has seleccionado un objetivo válido.</c>"); return;}

        int iDote = StringToInt(GetStringRight(sTexto, GetStringLength(sTexto)-10));
        string sNombreDote = GetStringByStrRef(StringToInt(Get2DAString("feat", "FEAT", iDote)));

        if(sNombreDote == "")
        {
            SendMessageToPC(oPC, "<cþ<<>Ninguna dote corresponde a lo que has escrito.</c>");
            return;
        }

        NWNX_Creature_AddFeat(oDMFIObjetivo, iDote);
        SendMessageToPC(oPC, "<c?þ>Dote '"+sNombreDote+"' añadida a "+GetName(oDMFIObjetivo, TRUE)+".</c>");
    }

    // Funcion quitar dote
    else if(GetStringLeft(sTexto, 13) == "dm_quitardote")
    {
        if(GetIsObjectValid(oDMFIObjetivo) == FALSE) {SendMessageToPC(oPC, "<cþ<<>No has seleccionado un objetivo válido.</c>"); return;}

        int iDote = StringToInt(GetStringRight(sTexto, GetStringLength(sTexto)-13));
        string sNombreDote = GetStringByStrRef(StringToInt(Get2DAString("feat", "FEAT", iDote)));

        if(sNombreDote == "")
        {
            SendMessageToPC(oPC, "<cþ<<>Ninguna dote corresponde a lo que has escrito.</c>");
            return;
        }

        NWNX_Creature_RemoveFeat(oDMFIObjetivo, iDote);
        SendMessageToPC(oPC, "<c?þ>Dote '"+sNombreDote+"' eliminada a "+GetName(oDMFIObjetivo, TRUE)+".</c>");
    }

    // Funcion fijar nombre
    else if(GetStringLeft(sTexto, 9) == "dm_nombre")
    {
        if(GetIsObjectValid(oDMFIObjetivo) == FALSE) {SendMessageToPC(oPC, "<cþ<<>No has seleccionado un objetivo válido.</c>"); return;}

        string sNombre = GetStringRight(sTexto, GetStringLength(sTexto)-10);
        string sNombreAntiguo = GetName(oDMFIObjetivo);

        SetName(oDMFIObjetivo, sNombre);
        SendMessageToPC(oPC, "<c?þ>Nombre '"+sNombre+"' aplicado a "+sNombreAntiguo+".</c>");
    }

    // Funcion fijar descripcion
    else if(GetStringLeft(sTexto, 14) == "dm_descripcion")
    {
        if(GetIsObjectValid(oDMFIObjetivo) == FALSE) {SendMessageToPC(oPC, "<cþ<<>No has seleccionado un objetivo válido.</c>"); return;}

        string sDescripcion = GetStringRight(sTexto, GetStringLength(sTexto)-15);

        SetDescription(oDMFIObjetivo, sDescripcion);
        SendMessageToPC(oPC, "<c?þ>Descripción aplicada a "+GetName(oDMFIObjetivo)+".</c>");
    }

    // Funcion hablar por otro
    else if(GetStringLeft(sTexto, 9) == "dm_hablar")
    {
        if(GetIsObjectValid(oDMFIObjetivo) == FALSE) {SendMessageToPC(oPC, "<cþ<<>No has seleccionado un objetivo válido.</c>"); return;}

        string sCharla = GetStringRight(sTexto, GetStringLength(sTexto)-9);
        AssignCommand(oDMFIObjetivo, SpeakString(sCharla));
    }

    // Funcion fijar apariencia
    else if(GetStringLeft(sTexto, 13) == "dm_apariencia")
    {
        if(GetIsObjectValid(oDMFIObjetivo) == FALSE) {SendMessageToPC(oPC, "<cþ<<>No has seleccionado un objetivo válido.</c>"); return;}

        int iApariencia = StringToInt(GetStringRight(sTexto, GetStringLength(sTexto)-13));
        string sNombreApariencia = GetStringByStrRef(StringToInt(Get2DAString("appearance", "LABEL", iApariencia)));

        if(sNombreApariencia == "")
        {
            SendMessageToPC(oPC, "<cþ<<>Ninguna apariencia corresponde a lo que has escrito.</c>");
            return;
        }

        SetCreatureAppearanceType(oDMFIObjetivo, iApariencia);
        SendMessageToPC(oPC, "<c?þ>Apariencia '"+sNombreApariencia+"' ajustada a "+GetName(oDMFIObjetivo)+".</c>");
    }

    // Funcion teleportar a la planar
    else if(GetStringLeft(sTexto, 9) == "dm_planar")
    {
        if(GetIsObjectValid(oDMFIObjetivo) == FALSE) {SendMessageToPC(oPC, "<cþ<<>No has seleccionado un objetivo válido.</c>"); return;}

        DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_GOOD_HELP), oDMFIObjetivo));
        DelayCommand(0.2, AssignCommand(oDMFIObjetivo, ClearAllActions()));
        DelayCommand(0.3, AssignCommand(oDMFIObjetivo, ActionJumpToLocation(GetStartingLocation())));
    }

    // Funcion teleportar a la planar al grupo entero
    else if(GetStringLeft(sTexto, 14) == "dm_planargrupo")
    {

        if(!GetIsPC(oDMFIObjetivo) || (GetIsObjectValid(oDMFIObjetivo) == FALSE)) {SendMessageToPC(oPC, "<cþ<<>No has seleccionado un objetivo válido.</c>"); return;}

        object oParty = GetFirstFactionMember(oDMFIObjetivo);
        while (GetIsObjectValid(oParty))
        {
            DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_GOOD_HELP), oParty));
            DelayCommand(0.2, AssignCommand(oParty, ClearAllActions()));
            DelayCommand(0.3, AssignCommand(oParty, ActionJumpToLocation(GetStartingLocation())));
            oParty = GetNextFactionMember(oDMFIObjetivo);
        }

    }

    //Funcion traer todo el grupo hacia DM
    else if(GetStringLeft(sTexto, 13) == "dm_traergrupo")
    {

        if(!GetIsPC(oDMFIObjetivo) || (GetIsObjectValid(oDMFIObjetivo) == FALSE)) {SendMessageToPC(oPC, "<cþ<<>No has seleccionado un objetivo válido.</c>"); return;}

        location lJumpLoc = GetLocation(oPC);
        object oParty = GetFirstFactionMember(oDMFIObjetivo);
        while (GetIsObjectValid(oParty))
        {
            DelayCommand(0.2, AssignCommand(oParty, ClearAllActions()));
            DelayCommand(0.3, AssignCommand(oParty, ActionJumpToLocation(lJumpLoc)));
            oParty = GetNextFactionMember(oDMFIObjetivo);
        }
    }

    // Dar XP al grupo
    else if(GetStringLeft(sTexto, 13) == "dm_darxpgrupo")
    {
        if(!GetIsPC(oDMFIObjetivo) || (GetIsObjectValid(oDMFIObjetivo) == FALSE)) {SendMessageToPC(oPC, "<cþ<<>No has seleccionado un objetivo válido.</c>"); return;}

        int sXP = StringToInt(GetStringRight(sTexto, GetStringLength(sTexto)-13));

        object oParty = GetFirstFactionMember(oDMFIObjetivo);
        while (GetIsObjectValid(oParty))
        {
            GiveXPToCreature (oParty, sXP);
            SendMessageToPC(oPC, "Has dado "+IntToString(sXP)+" puntos de experiencia a "+GetName(oParty, TRUE)+".");
            oParty = GetNextFactionMember(oDMFIObjetivo);
        }
    }

    // Dar Oro al grupo
    else if(GetStringLeft(sTexto, 14) == "dm_darorogrupo")
    {
        if(!GetIsPC(oDMFIObjetivo) || (GetIsObjectValid(oDMFIObjetivo) == FALSE)) {SendMessageToPC(oPC, "<cþ<<>No has seleccionado un objetivo válido.</c>"); return;}

        int sOro = StringToInt(GetStringRight(sTexto, GetStringLength(sTexto)-14));

        object oParty = GetFirstFactionMember(oDMFIObjetivo);
        while (GetIsObjectValid(oParty))
        {
            GiveGoldToCreature (oParty, sOro);
            SendMessageToPC(oPC, "Has dado "+IntToString(sOro)+" monedas de oro a "+GetName(oDMFIObjetivo, TRUE)+".");
            oParty = GetNextFactionMember(oDMFIObjetivo);
        }
    }

    // Funcion dar CA a una criatura
    else if(GetStringLeft(sTexto, 15) == "dm_darcanatural")
    {
        if(GetIsPC(oDMFIObjetivo) || (GetIsObjectValid(oDMFIObjetivo) == FALSE)) {SendMessageToPC(oPC, "<cþ<<>No has seleccionado un objetivo válido.</c>"); return;}

        int sCA = StringToInt(GetStringRight(sTexto, GetStringLength(sTexto)-15));

        NWNX_Creature_SetBaseAC(oDMFIObjetivo, sCA);
        SendMessageToPC(oPC, "Has aumentado la CA en "+IntToString(sCA)+" a "+GetName(oDMFIObjetivo)+".");
    }

    // Funcion Escalar  una criatura
    else if(GetStringLeft(sTexto, 10) == "dm_escalar")
    {
        if(GetIsObjectValid(oDMFIObjetivo) == FALSE) {SendMessageToPC(oPC, "<cþ<<>No has seleccionado un objetivo válido.</c>"); return;}

        float sCA = StringToFloat(GetStringRight(sTexto, GetStringLength(sTexto)-10));
        if (sCA <= 0.0){ SendMessageToPC(oPC, "<cþ<<>¡"+FloatToString(sCA)+" No es un valor valido!.</c>"); return;}

        SetObjectVisualTransform(oDMFIObjetivo, OBJECT_VISUAL_TRANSFORM_SCALE, sCA);
        if(GetObjectType(oDMFIObjetivo) == OBJECT_TYPE_PLACEABLE)
        {
            SetName(oDMFIObjetivo, GetName(oDMFIObjetivo) + "DMESC_"+FloatToString(sCA));
        }
        SendMessageToPC(oPC, "Has aumentado el tamaño de "+GetName(oDMFIObjetivo)+" a "+FloatToString(sCA)+".");
    }


    // Funcion teleport
    else if(GetStringLeft(sTexto, 11) == "dm_teleport")
    {
        if(GetIsObjectValid(oDMFIObjetivo) == FALSE) {SendMessageToPC(oPC, "<cþ<<>No has seleccionado un objetivo válido.</c>"); return;}

        string sEtiquetaPR = GetStringRight(sTexto, GetStringLength(sTexto)-12);
        location lPR = GetLocation(GetWaypointByTag(sEtiquetaPR));

        DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_GOOD_HELP), oDMFIObjetivo));
        DelayCommand(0.2, AssignCommand(oDMFIObjetivo, ClearAllActions()));
        DelayCommand(0.3, AssignCommand(oDMFIObjetivo, ActionJumpToLocation(lPR)));
    }

    // Funcion fijar conjunto de voz
    else if(GetStringLeft(sTexto, 6) == "dm_voz")
    {
        if(GetIsObjectValid(oDMFIObjetivo) == FALSE) {SendMessageToPC(oPC, "<cþ<<>No has seleccionado un objetivo válido.</c>"); return;}

        int iVoz = StringToInt(GetStringRight(sTexto, GetStringLength(sTexto)-6));
        string sNombreVoz = GetStringByStrRef(StringToInt(Get2DAString("soundset", "LABEL", iVoz)));

        if(sNombreVoz == "")
        {
            SendMessageToPC(oPC, "<cþ<<>Ninguna voz corresponde a lo que has escrito.</c>");
            return;
        }

        SetSoundset(oDMFIObjetivo, iVoz);
        SendMessageToPC(oPC, "<c?þ>Conjunto de voz '"+sNombreVoz+"' ajustado a "+GetName(oDMFIObjetivo)+".</c>");
    }

    // Funcion fijar sonido de pasos
    else if(GetStringLeft(sTexto, 8) == "dm_pasos")
    {
        if(GetIsObjectValid(oDMFIObjetivo) == FALSE) {SendMessageToPC(oPC, "<cþ<<>No has seleccionado un objetivo válido.</c>"); return;}

        int iPasos = StringToInt(GetStringRight(sTexto, GetStringLength(sTexto)-8));
        string sNombrePasos = GetStringByStrRef(StringToInt(Get2DAString("footstepsounds", "Label", iPasos)));

        if(sNombrePasos == "")
        {
            SendMessageToPC(oPC, "<cþ<<>Ningún sonido de pasos corresponde a lo que has escrito.</c>");
            return;
        }

        SetFootstepType(iPasos, oDMFIObjetivo);
        SendMessageToPC(oPC, "<c?þ>Sonidos de pasos '"+sNombrePasos+"' ajustado a "+GetName(oDMFIObjetivo)+".</c>");
    }

    // Funcion ver la fecha de creacion
    else if(GetStringLeft(sTexto, 8) == "dm_fecha")
    {
        if(GetIsObjectValid(oDMFIObjetivo) == FALSE) {SendMessageToPC(oPC, "<cþ<<>No has seleccionado un objetivo válido.</c>"); return;}

        int iUnixTime = ObtenerIntPersistente(oDMFIObjetivo, "PB_FECHA_CREACION");

        if(!GetIsPC(oDMFIObjetivo) || iUnixTime == 0) {SendMessageToPC(oPC, "<cþ<<>El objetivo debe ser un PJ creado después de la actualización de haks de Septiembre de 2012. Para consultar fechas de creación más antiguas revisa el log o el foro.</c>"); return;}

        int iAjusteHorario = 7200;
        if(GetCampaignInt("AJUSTEHORARIO", "AJUSTEHORARIO", GetModule()) == TRUE) iAjusteHorario = 3600;

        PrintHumanDate(oPC, oDMFIObjetivo, iUnixTime, iAjusteHorario, TRUE);
    }

    // Funcion fijar deidad
    else if(GetStringLeft(sTexto, 9) == "dm_deidad")
    {
        if(GetIsObjectValid(oDMFIObjetivo) == FALSE) {SendMessageToPC(oPC, "<cþ<<>No has seleccionado un objetivo válido.</c>"); return;}

        string sDeidad = GetStringRight(sTexto, GetStringLength(sTexto)-10);

        SetDeity(oDMFIObjetivo, sDeidad);
        SendMessageToPC(oPC, "<c?þ>" + GetName(oDMFIObjetivo, TRUE) + " adora ahora a " + sDeidad + ".</c>");
    }

    // Funcion para que un idioma claseo no desapareza aunque no le corresponda (mérito de rol)
    else if(GetStringLeft(sTexto, 9) == "dm_idioma")
    {
        if(GetIsObjectValid(oDMFIObjetivo) == FALSE) {SendMessageToPC(oPC, "<cþ<<>No has seleccionado un objetivo válido.</c>"); return;}
        if(GetTag(oDMFIObjetivo) != "hlslang_14" && GetTag(oDMFIObjetivo) != "hlslang_8" && GetTag(oDMFIObjetivo) != "hlslang_9" &&
            GetTag(oDMFIObjetivo) != "hlslang_37" && GetTag(oDMFIObjetivo) != "hlslang_71") {SendMessageToPC(oPC, "<cþ<<>No has seleccionado un idioma cláseo válido (animal, druida, agots o mágico).</c>"); return;}

        SetLocalInt(oDMFIObjetivo, "IDIOMA_POR_ROL", TRUE);
        SendMessageToPC(oPC, "<c?þ>" + GetName(oDMFIObjetivo, TRUE) + " ahora no desaparecerá aunque no le corresponda (mérito de rol).</c>");
    }

    // Funcion reset Brujo - Elimina todas las invocaciones y restaura la variable
    else if(GetStringLeft(sTexto, 13) == "dm_resetbrujo")
    {
        if(GetIsObjectValid(oDMFIObjetivo) == FALSE) {SendMessageToPC(oPC, "<cþ<<>No has seleccionado un objetivo válido.</c>"); return;}

        NWNX_Creature_RemoveFeat(oDMFIObjetivo, 1470);
        NWNX_Creature_RemoveFeat(oDMFIObjetivo, 1471);
        NWNX_Creature_RemoveFeat(oDMFIObjetivo, 1472);
        NWNX_Creature_RemoveFeat(oDMFIObjetivo, 1473);
        NWNX_Creature_RemoveFeat(oDMFIObjetivo, 1474);
        NWNX_Creature_RemoveFeat(oDMFIObjetivo, 1475);
        NWNX_Creature_RemoveFeat(oDMFIObjetivo, 1476);
        NWNX_Creature_RemoveFeat(oDMFIObjetivo, 1477);
        NWNX_Creature_RemoveFeat(oDMFIObjetivo, 1478);
        NWNX_Creature_RemoveFeat(oDMFIObjetivo, 1479);
        NWNX_Creature_RemoveFeat(oDMFIObjetivo, 1480);
        NWNX_Creature_RemoveFeat(oDMFIObjetivo, 1481);
        NWNX_Creature_RemoveFeat(oDMFIObjetivo, 1482);
        NWNX_Creature_RemoveFeat(oDMFIObjetivo, 1483);
        NWNX_Creature_RemoveFeat(oDMFIObjetivo, 1484);
        NWNX_Creature_RemoveFeat(oDMFIObjetivo, 1485);
        NWNX_Creature_RemoveFeat(oDMFIObjetivo, 1486);
        NWNX_Creature_RemoveFeat(oDMFIObjetivo, 1487);
        NWNX_Creature_RemoveFeat(oDMFIObjetivo, 1488);
        NWNX_Creature_RemoveFeat(oDMFIObjetivo, 1489);
        NWNX_Creature_RemoveFeat(oDMFIObjetivo, 1490);
        NWNX_Creature_RemoveFeat(oDMFIObjetivo, 1491);
        NWNX_Creature_RemoveFeat(oDMFIObjetivo, 1492);
        NWNX_Creature_RemoveFeat(oDMFIObjetivo, 1493);
        NWNX_Creature_RemoveFeat(oDMFIObjetivo, 1494);
        NWNX_Creature_RemoveFeat(oDMFIObjetivo, 1495);
        NWNX_Creature_RemoveFeat(oDMFIObjetivo, 1496);
        NWNX_Creature_RemoveFeat(oDMFIObjetivo, 1497);
        NWNX_Creature_RemoveFeat(oDMFIObjetivo, 1502);
        NWNX_Creature_RemoveFeat(oDMFIObjetivo, 1514);

        SendMessageToPC(oPC, "<c þ>Todas las Invocaciones eliminadas a "+GetName(oDMFIObjetivo, TRUE)+".</c>");
        GuardarIntPersistente(oDMFIObjetivo, "INVOCACIONES", 0 );
    }

    // Funcion Guardar Criatura - Guarda una criatura para poder recuperarla tras reinicio
    else if (GetStringLeft(sTexto, 10) == "dm_guardar")
    {
        if (GetIsPC(oDMFIObjetivo) || GetIsDM(oDMFIObjetivo) || GetObjectType(oDMFIObjetivo) != OBJECT_TYPE_CREATURE || GetIsObjectValid(oDMFIObjetivo) == FALSE)
        {
            SendMessageToPC(oPC, "<cþ<<>No has seleccionado un objetivo válido.</c>"); return;
        }

        string sName = GetName(oDMFIObjetivo);
        object oItem = CreateItemOnObject("savecreature", oPC);

        //Guardamos la variable para recuperarlo después
        if(oItem != OBJECT_INVALID)
        {
            SetName(oItem, sName);
            SetDescription(oItem, NWNX_Object_Serialize(oDMFIObjetivo));
            SendMessageToPC(oPC, "<c?þ>Objeto "+ sName + " creado en tu inventario. ¡Recuerda guardar tu avatar DM! Recuerda, las criaturas con más de una pestaña de inventario en objetos y/o con conversaciones, pueden provocar que la información supere los carácteres límite de la descripción y no se guarde. No uséis PNJs para copiar con conversaciones o con demasiado inventario.</c>");
        }
        else SendMessageToPC(oPC, "<cþ<<>No se ha podido generar el item con la criatura, comprueba tu inventario.</c>");
    }

    else if(GetStringLeft(sTexto, 7) == "dm_area")
    {
        AreaCommandHandler(oPC, sTexto);
    }

    // Funcion reiniciar facciones
    else if(GetStringLeft(sTexto, 17) == "dm_resetfacciones")
    {
        if(GetIsObjectValid(oDMFIObjetivo) == FALSE || !GetIsPC(oDMFIObjetivo)) {SendMessageToPC(oPC, "<cþ<<>No has seleccionado un objetivo válido.</c>"); return;}

        ExecuteScript("facciones", oDMFIObjetivo);
        SendMessageToPC(oPC, "<c?þ>Facciones reiniciadas.</c>");
    }

    // Funcion fijar tamanyo
    else if(GetStringLeft(sTexto, 9) == "dm_tamaño")
    {
        if(GetIsObjectValid(oDMFIObjetivo) == FALSE) { SendMessageToPC(oPC, "<cþ<<>No has seleccionado un objetivo válido.</c>"); return; }

        int iFeno = StringToInt(GetStringRight(sTexto, GetStringLength(sTexto)-9));
        string sFeno;
        switch(iFeno)
        {
            case 1: sFeno = "Diminuto"; break;
            case 2: sFeno = "Pequeño"; break;
            case 3: sFeno = "Mediano"; break;
            case 4: sFeno = "Gigante"; break;
            case 5: sFeno = "Colosal"; break;
        }

        if(iFeno <= 5 && iFeno >= 1)
        {
            NWNX_Creature_SetSize(oDMFIObjetivo, iFeno);
            SendMessageToPC(oPC, "Has modificado el tamaño de "+GetName(oDMFIObjetivo)+" a "+sFeno+".");
        }
        else SendMessageToPC(oPC, "No has indicado un valor valido. Debe ser de 1 a 5");

    }

    //Hacer daño magico en area
    else if(GetStringLeft(sTexto, 11) == "dm_dañoarea")
    {
        if(GetIsObjectValid(oDMFIObjetivo) == FALSE) {SendMessageToPC(oPC, "<cþ<<>No has seleccionado un objetivo válido.</c>"); return;}

        int sDam = StringToInt(GetStringRight(sTexto, GetStringLength(sTexto)-11));
        int iDG = GetCurrentHitPoints(oDMFIObjetivo);
        int eDamage = d6(sDam);

        object oParty = GetFirstFactionMember(oDMFIObjetivo);
        while (GetIsObjectValid(oParty))
        {
            int iHitPoints = GetCurrentHitPoints(oDMFIObjetivo);
            if(GetArea(oDMFIObjetivo) == GetArea(oParty)) SetCurrentHitPoints(oDMFIObjetivo, iHitPoints - eDamage);
            oParty = GetNextFactionMember(oDMFIObjetivo);
        }

    }

    // Daño por asalto
    else if(GetStringLeft(sTexto, 13) == "dm_dañoasalto")
    {
        if(!GetIsPC(oDMFIObjetivo) || (GetIsObjectValid(oDMFIObjetivo) == FALSE)) {SendMessageToPC(oPC, "<cþ<<>No has seleccionado un objetivo válido.</c>"); return;}

        int sDam = StringToInt(GetStringRight(sTexto, GetStringLength(sTexto)-13));

        //Añadimos la variable de daño
        SetLocalInt(oDMFIObjetivo, "DAMAGE_ROUND", sDam);
        int eDam = GetLocalInt(oDMFIObjetivo, "DAMAGE_ROUND");
        ApplyRoundDamage(oDMFIObjetivo);
        SendMessageToPC(oPC, "Has aplicado "+IntToString(eDam)+" daños por asalto a "+GetName(oDMFIObjetivo)+".");
    }

    // Quitar Daño por asalto
    else if(GetStringLeft(sTexto, 13) == "dm_quitardaño")
    {
        if(GetIsObjectValid(oDMFIObjetivo) == FALSE) {SendMessageToPC(oPC, "<cþ<<>No has seleccionado un objetivo válido.</c>"); return;}

        //Borramos la variable
        DeleteLocalInt(oDMFIObjetivo, "DAMAGE_ROUND");
        SendMessageToPC(oPC, "Has anulado el daño por asalto a "+GetName(oDMFIObjetivo, TRUE)+".");
    }

    // Quitar Daño por asalto en grupo
    else if(GetStringLeft(sTexto, 14) == "dm_limpiardaño")
    {
        if(!GetIsPC(oDMFIObjetivo) || (GetIsObjectValid(oDMFIObjetivo) == FALSE)) {SendMessageToPC(oPC, "<cþ<<>No has seleccionado un objetivo válido.</c>"); return;}

        object oParty = GetFirstFactionMember(oDMFIObjetivo);
        while (GetIsObjectValid(oParty))
        {
            DeleteLocalInt(oParty, "DAMAGE_ROUND");
            SendMessageToPC(oPC, "Has anulado el daño por asalto a "+GetName(oParty)+".");
        oParty = GetNextFactionMember(oDMFIObjetivo);
        }

    }

    //Cambiar el genero
    else if(GetStringLeft(sTexto, 9) == "dm_genero")
    {
        if(GetIsObjectValid(oDMFIObjetivo) == FALSE) {SendMessageToPC(oPC, "<cþ<<>No has seleccionado un objetivo válido.</c>"); return;}

        int iGenero = StringToInt(GetStringRight(sTexto, GetStringLength(sTexto)-9));
        string sGenero;
        switch(iGenero)
        {
            case 0: sGenero = "Hombre"; break;
            case 1: sGenero = "Mujer"; break;
        }
        if(iGenero == 1 || iGenero == 0)
        {
            SetGender(oDMFIObjetivo, iGenero);
            SendMessageToPC(oPC, "Has modificado el genero de "+GetName(oDMFIObjetivo)+" a "+sGenero+". Cambia la apariencia a una acorde.");
        }
        else SendMessageToPC(oPC, "No has indicado un valor valido. Debe ser 0 para hombre o 1 para mujer");
    }

    //Cambiar la apariencia de un ubicado
    else if(GetStringLeft(sTexto, 10) == "dm_ubicado")
    {
        if (GetIsObjectValid(oDMFIObjetivo) == FALSE || GetObjectType(oDMFIObjetivo) != OBJECT_TYPE_PLACEABLE) {SendMessageToPC(oPC, "<cþ<<>No has seleccionado un objetivo válido.</c>"); return;}

        int iUbicado = StringToInt(GetStringRight(sTexto, GetStringLength(sTexto)-10));
        string sNombreUbicado = Get2DAString("placeables", "Label", iUbicado);

        if(sNombreUbicado == "")
        {
            SendMessageToPC(oPC, "<cþ<<>Ningún ubicado corresponde a lo que has escrito.</c>");
            return;
        }

        NWNX_Object_SetAppearance(oDMFIObjetivo, iUbicado);
        SetName(oDMFIObjetivo, "DMAPA_"+IntToString(iUbicado));
        SendMessageToPC(oPC, "<c?þ>Nueva apariencia de '"+GetName(oDMFIObjetivo)+"' ajustada a '"+sNombreUbicado+"'.</c>");
        object oUbicadoNuevo = CopyObject(oDMFIObjetivo, GetLocation(oDMFIObjetivo),OBJECT_INVALID,GetTag(oDMFIObjetivo),TRUE);
        DestroyObject(oDMFIObjetivo);
        SetLocalObject(oPC, "dmfi_univ_target", oUbicadoNuevo);
    }

    // Reiniciar los ajustes de la raza de un jugador
    else if(GetStringLeft(sTexto, 12) == "dm_resetraza")
    {
        if (GetIsObjectValid(oDMFIObjetivo) == FALSE) {SendMessageToPC(oPC, "<cþ<<>No has seleccionado un objetivo válido.</c>"); return;}

        int i, nRacialType = GetRacialType(oDMFIObjetivo);
        string sTag;

        switch(nRacialType)
        {
            case RACIAL_TYPE_FEYRI:
                for (i = FEAT_APTDEM_TS_LIGHTNING; i < FEAT_APTDEM_SUGGESTION; i++)
                {
                    NWNX_Creature_RemoveFeat(oDMFIObjetivo, i);
                    if (i >= FEAT_APTDEM_CHARM_PERSON && i <= FEAT_APTDEM_SUGGESTION)
                    {
                        switch(i)
                        {
                            case FEAT_APTDEM_CHARM_PERSON:   sTag = "crr_ogro_hecper";   break;
                            case FEAT_APTDEM_CLAIRVOYANCE:   sTag = "crr_clairvoyance";  break;
                            case FEAT_APTDEM_ENERVATION:     sTag = "crr_ennervation";   break;
                            case FEAT_APTDEM_DARKNESS:       sTag = "crr_subrace_2";     break;
                            case FEAT_APTDEM_DIMENSION_DOOR: sTag = "crr_gtele_feyri";   break;
                            case FEAT_APTDEM_SUGGESTION:     sTag = "crr_suggestion";    break;
                        }
                        object oItem = GetItemPossessedBy(oDMFIObjetivo, sTag);
                        if (GetIsObjectValid(oItem)) DestroyObject(oItem, 0.1);
                    }
                }
                GuardarIntPersistente(oDMFIObjetivo, "FEYRI_APTDEM", FALSE);
                SendMessageToPC(oPC, "La raza del jugador ha sido reiniciada.");
                break;
            default:
                SendMessageToPC(oPC, "<cþ<<>La raza del jugador seleccionado no es compatible con este comando.</c>");
                break;
        }
    }

    //Imprimir la tabla de subida de niveles de un jugador
    else if(GetStringLeft(sTexto, 10) == "dm_niveles")
    {
        if(!GetIsPC(oDMFIObjetivo) || (GetIsObjectValid(oDMFIObjetivo) == FALSE)) {SendMessageToPC(oPC, "<cþ<<>No has seleccionado un objetivo válido.</c>"); return;}

        int i, nTotalLevel = GetHitDice(oDMFIObjetivo);

        for (i = 1; i <= nTotalLevel; i++)
        {
            int nLevel = NWNX_Creature_GetClassByLevel(oDMFIObjetivo, i);
            string sClass = GetStringByStrRef(StringToInt(Get2DAString("classes", "Name", nLevel)));
            SendMessageToPC(oPC, "Nivel " + IntToString(i) + ": " + sClass);
        }
    }

    //Actualizar el listado de nombres de los PJs.
    else if(GetStringLeft(sTexto, 8) == "dm_names")
    {
        PB_Disguise_HandleOnEnter(oPC);
        SendMessageToPC(oPC, "Lista de PJs actualizada.");
    }

    //Actualizar el listado de nombres de los PJs.
    else if(GetStringLeft(sTexto, 7) == "dm_real")
    {
        if(!GetIsPC(oDMFIObjetivo) || (GetIsObjectValid(oDMFIObjetivo) == FALSE)) {SendMessageToPC(oPC, "<cþ<<>No has seleccionado un objetivo válido.</c>"); return;}
        SendMessageToPC(oPC, "Nombre real de PJ: "+PB_Disguise_GetNameOverride(oDMFIObjetivo)+". Nombre de jugador: "+GetPCPlayerName(oDMFIObjetivo)+".");
    }

    // Función setear vida extra a una criatura.
    else if(GetStringLeft(sTexto, 7) == "dm_vida")
    {
        if(GetIsPC(oDMFIObjetivo) || (GetIsObjectValid(oDMFIObjetivo) == FALSE)) {SendMessageToPC(oPC, "<cþ<<>No has seleccionado un objetivo válido.</c>"); return;}

        int sVida = StringToInt(GetStringRight(sTexto, GetStringLength(sTexto)-8));

        NWNX_Object_SetMaxHitPoints(oDMFIObjetivo, sVida);
        NWNX_Object_SetCurrentHitPoints(oDMFIObjetivo, sVida);
        SendMessageToPC(oPC, "Has aumentado la vida en "+IntToString(sVida)+" a "+GetName(oDMFIObjetivo)+".");
    }

    // Limitamos al PJ para que no pueda curarse.
    else if(GetStringLeft(sTexto, 10) == "dm_nocurar")
    {
        if(!GetIsPC(oDMFIObjetivo) || (GetIsObjectValid(oDMFIObjetivo) == FALSE)) {SendMessageToPC(oPC, "<cþ<<>No has seleccionado un objetivo válido.</c>"); return;}
        if(GetLocalInt(oDMFIObjetivo, "dm_nocurar") != 1)
        {
            SetLocalInt(oDMFIObjetivo, "dm_nocurar",1);
            SendMessageToPC(oDMFIObjetivo,ColorTexto("Un DM te ha deshabilitado la posibilidad de curarte.",TXT_COLOR_ROJO));
            SendMessageToPC(oPC, "Impides la curación a "+GetName(oDMFIObjetivo)+".");
            return;
        }
        if(GetLocalInt(oDMFIObjetivo, "dm_nocurar") == 1)
        {
           DeleteLocalInt(oDMFIObjetivo, "dm_nocurar");
           SendMessageToPC(oDMFIObjetivo,ColorTexto("Un DM te ha habilitado la posibilidad de curarte.",TXT_COLOR_VERDE));
           SendMessageToPC(oPC, "Habilitas la curación a "+GetName(oDMFIObjetivo)+".");
           return;
        }

    }

    // Limitamos al PJ para que no pueda curarse.
    else if(GetStringLeft(sTexto, 8) == "dm_noreg")
    {
        if(!GetIsPC(oDMFIObjetivo) || (GetIsObjectValid(oDMFIObjetivo) == FALSE)) {SendMessageToPC(oPC, "<cþ<<>No has seleccionado un objetivo válido.</c>"); return;}
        if(GetLocalInt(oDMFIObjetivo, "dm_noreg") != 1)
        {
            SetLocalInt(oDMFIObjetivo, "dm_noreg",1);
            int sDam;
            //Calculamos la reg de un PJ.
            //ITEM REG
            sDam = sDam +1;
            //BRUJOS
            if(GetLevelByClass(57, oPC) >= 18 ) sDam = sDam +5;
            else if(GetLevelByClass(57, oPC) >= 13 && GetLevelByClass(57, oPC) < 18 ) sDam = sDam +2;
            else if(GetLevelByClass(57, oPC) >= 8 && GetLevelByClass(57, oPC) < 13 ) sDam = sDam +1;
            //OGROS HECHICEROS
            if(GetRacialType(oDMFIObjetivo) == RACIAL_TYPE_SEMIOGRO) sDam = sDam +5;
            //VAMPIROS
            if(GetSubRace(oDMFIObjetivo) == "vampiro" || GetSubRace(oDMFIObjetivo) == "Vampiro") sDam = sDam +5;
            //ENGENDROS
            if(GetSubRace(oDMFIObjetivo) == "engendro" || GetSubRace(oDMFIObjetivo) == "Engendro") sDam = sDam +1;
            //UMBRAS
            if(GetLocalInt(oDMFIObjetivo, "BONOS_UMBRA") == TRUE) sDam = sDam +2;

            //Añadimos la variable de daño
            SetLocalInt(oDMFIObjetivo, "DAMAGE_ROUND", sDam);
            ApplyRoundDamage(oDMFIObjetivo);
            SendMessageToPC(oDMFIObjetivo,ColorTexto("Un DM te ha deshabilitado la posibilidad de regenerarte.",TXT_COLOR_ROJO));
            SendMessageToPC(oPC, "Impides la curación y la regeneración a "+GetName(oDMFIObjetivo)+".");
            return;
        }
        if(GetLocalInt(oDMFIObjetivo, "dm_noreg") == 1)
        {
           DeleteLocalInt(oDMFIObjetivo, "dm_noreg");
           DeleteLocalInt(oDMFIObjetivo, "DAMAGE_ROUND");
           SendMessageToPC(oDMFIObjetivo,ColorTexto("Un DM te ha habilitado la posibilidad de regenerarte.",TXT_COLOR_VERDE));
           SendMessageToPC(oPC, "Habilitas la curación y la regeneración a "+GetName(oDMFIObjetivo)+".");
           return;
        }

    }

    // Convertimos en segura un área para los vampiros
    else if(GetStringLeft(sTexto, 12) == "dm_avampsafe")
    {
        if(GetLocalInt(GetArea(oPC), "dm_vampsafe") != 1)
        {
            SetLocalInt(GetArea(oPC), "dm_vampsafe",1);
            SendMessageToPC(oPC, "El sistema de sol en este área no se aplicará a los vampiros.");
            return;
        }
        if(GetLocalInt(GetArea(oPC), "dm_vampsafe") == 1)
        {
            DeleteLocalInt(GetArea(oPC), "dm_vampsafe");
            SendMessageToPC(oPC, "El sistema de sol en este área volverá a afectar a los vampiros.");
            return;
        }
    }

    // Convertimos en segura un área para los vampiros
    else if(GetStringLeft(sTexto, 11) == "dm_vampsafe")
    {
        if(GetLocalInt(oDMFIObjetivo, "dm_vampsafe") != 1)
        {
            SetLocalInt(oDMFIObjetivo, "dm_vampsafe",1);
            SendMessageToPC(oPC, "El sistema de sol no aplicará al vampiro " +GetName(oDMFIObjetivo,TRUE)+".");
            SendMessageToPC(oDMFIObjetivo, "El sistema de sol no te afecta en este momento gracias al comando DM. Si tras finalizar el rol para el que se ha dado esta ayuda no hay DM para eliminarte la inmunidad, deberás eliminarte la inmunidad con el comando !vampsafe, permanecer inmune cuando el rol para el que se te ha hecho inmune ha terminado está prohibido.");
            return;
        }
        if(GetLocalInt(oDMFIObjetivo, "dm_vampsafe") == 1)
        {
            DeleteLocalInt(oDMFIObjetivo, "dm_vampsafe");
            SendMessageToPC(oPC, "El sistema de sol aplicará al vampiro " +GetName(oDMFIObjetivo,TRUE)+".");
            SendMessageToPC(oDMFIObjetivo, "El sistema de sol te vuelve a afectar.");
            return;
        }
    }

    //Metemos IA a una criatura.
    else if(GetStringLeft(sTexto, 5) == "dm_ia")
    {
        if(GetIsPC(oDMFIObjetivo))
        {
            SendMessageToPC(oPC, "<cþ<<>Solo se puede usar con PNJs.</c>");
            return;
        }
        SetEventScript(oDMFIObjetivo, EVENT_SCRIPT_CREATURE_ON_BLOCKED_BY_DOOR, "nw_c2_defaulte");
        SetEventScript(oDMFIObjetivo, EVENT_SCRIPT_CREATURE_ON_END_COMBATROUND, "nw_c2_default3");
        SetEventScript(oDMFIObjetivo, EVENT_SCRIPT_CREATURE_ON_DIALOGUE, "nw_c2_default4");
        SetEventScript(oDMFIObjetivo, EVENT_SCRIPT_CREATURE_ON_DAMAGED, "nw_c2_default6");
        SetEventScript(oDMFIObjetivo, EVENT_SCRIPT_CREATURE_ON_DEATH, "nw_c2_default7");
        SetEventScript(oDMFIObjetivo, EVENT_SCRIPT_CREATURE_ON_DISTURBED, "nw_c2_default8");
        SetEventScript(oDMFIObjetivo, EVENT_SCRIPT_CREATURE_ON_HEARTBEAT, "nw_c2_default1");
        SetEventScript(oDMFIObjetivo, EVENT_SCRIPT_CREATURE_ON_NOTICE, "nw_c2_default2");
        SetEventScript(oDMFIObjetivo, EVENT_SCRIPT_CREATURE_ON_MELEE_ATTACKED, "nw_c2_default5");
        SetEventScript(oDMFIObjetivo, EVENT_SCRIPT_CREATURE_ON_RESTED, "nw_c2_defaulta");
        SetEventScript(oDMFIObjetivo, EVENT_SCRIPT_CREATURE_ON_SPAWN_IN, "nw_c2_default9");
        SetEventScript(oDMFIObjetivo, EVENT_SCRIPT_CREATURE_ON_SPELLCASTAT, "nw_c2_defaultb");
        SetEventScript(oDMFIObjetivo, EVENT_SCRIPT_CREATURE_ON_USER_DEFINED_EVENT, "nw_c2_defaultd");
        SendMessageToPC(oPC, "Activa y desactiva la IA, lo mismo tienes que ajustarle la facción.");
    }
    // No comando
    else SendMessageToPC(oPC, "<cþ<<>Ningún comando DM corresponde a lo que has escrito.</c>");
}
