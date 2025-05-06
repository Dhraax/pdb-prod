#include "nwnx_object"

void AREA_COMMANDS_ShowHelp(object oPC);
void AREA_COMMANDS_CopyArea(object oPC, string sTexto, int nCommand);
void AREA_COMMANDS_CleanArea(object oPC, object oArea, int bDelete = TRUE);
void AREA_COMMANDS_DeleteArea(object oPC, string sTexto);
void AREA_COMMANDS_SetName(object oPC, string sTexto);
void AREA_COMMANDS_SetPlotFlag(object oPC, object oArea);
void AREA_COMMANDS_SetStatic(object oPC, object oArea);
void AREA_COMMANDS_ScriptLimpiar(object oPC, object oArea);
void AREA_COMMANDS_ScriptInterior(object oPC, object oArea);
void AREA_COMMANDS_ScriptExterior(object oPC, object oArea);

int AREA_UTILS_ShouldDeleteObject(object oObject, int bDelete = TRUE);

void AreaCommandHandler(object oPC, string sTexto)
{
    if (GetStringLeft(sTexto, 13) == "dm_area_ayuda") AREA_COMMANDS_ShowHelp(oPC);
    else if (GetStringLeft(sTexto, 16) == "dm_area_copiar_o") AREA_COMMANDS_CopyArea(oPC, sTexto, 16);
    else if (GetStringLeft(sTexto, 14) == "dm_area_copiar") AREA_COMMANDS_CopyArea(oPC, sTexto, 14);
    else if (GetStringLeft(sTexto, 24) == "dm_area_limpiar_ubicados") AREA_COMMANDS_CleanArea(oPC, GetArea(oPC), 2);
    else if (GetStringLeft(sTexto, 15) == "dm_area_limpiar") AREA_COMMANDS_CleanArea(oPC, GetArea(oPC), 1);
    else if (GetStringLeft(sTexto, 14) == "dm_area_borrar") AREA_COMMANDS_DeleteArea(oPC, sTexto);
    else if (GetStringLeft(sTexto, 14) == "dm_area_nombre") AREA_COMMANDS_SetName(oPC, sTexto);
    else if (GetStringLeft(sTexto, 13) == "dm_area_trama") AREA_COMMANDS_SetPlotFlag(oPC, GetArea(oPC));
    else if (GetStringLeft(sTexto, 16) == "dm_area_estatico") AREA_COMMANDS_SetStatic(oPC, GetArea(oPC));
    else if (GetStringLeft(sTexto, 23) == "dm_area_scripts_limpiar") AREA_COMMANDS_ScriptLimpiar(oPC, GetArea(oPC));
    else if (GetStringLeft(sTexto, 24) == "dm_area_scripts_interior") AREA_COMMANDS_ScriptInterior(oPC, GetArea(oPC));
    else if (GetStringLeft(sTexto, 24) == "dm_area_scripts_exterior") AREA_COMMANDS_ScriptExterior(oPC, GetArea(oPC));
    else SendMessageToPC(oPC, "<cþ<<>Ningún comando DM corresponde a lo que has escrito.</c>");
}

//////////////////////////////////////////////////////
////////////////////// COMMANDS //////////////////////
//////////////////////////////////////////////////////

void AREA_COMMANDS_ShowHelp(object oPC)
{
    SendMessageToPC(oPC, "<c?þ>Comandos DM - Áreas</c>");
    SendMessageToPC(oPC, "<c´þd>------------------------</c>");
    SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_area_copiar' + 'Tag del área'</c> para copiar un área existente. Borrado completo de objetos excepto ubicados.</c>");
    SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_area_copiar_o' + 'Tag del área'</c> para copiar un área existente. Borrado mínimo de transiciones.</c>");
    SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_area_limpiar'</c> para eliminar los objetos del área actual excepto ubicados.</c>");
    SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_area_limpiar_ubicados'</c> para eliminar los ubicados del área actual.</c>");
    SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_area_borrar' + 'Tag del área'</c> para eliminar una área creada mediante los comandos de copiado.</c>");
    SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_area_nombre' + 'Nombre del área'</c> para modificar el nombre del área actual.</c>");
    SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_area_trama'</c> para setear todos los ubicados del área como de trama.</c>");
    SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_area_estatico'</c> para setear todos los ubicados del área como estáticos.</c>");
    SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_area_scripts_limpiar'</c> para eliminar del área los scripts.</c>");
    SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_area_scripts_interior'</c> para setear los script del área a los script de interiores.</c>");
    SendMessageToPC(oPC, "<c´þd><c?þ>-</c> <c ~ > Usa la función<c´þd> 'dm_area_scripts_exterior'</c> para setear los script del área a los script de exteriores.</c>");
}

void AREA_COMMANDS_CopyArea(object oPC, string sTexto, int nCommand)
{
    if ((GetStringLength(sTexto) - (nCommand+1)) < 5) {
        SendMessageToPC(oPC, "<cþ<<>¡Tienes qué introducir un tag válido! (Mínimo de 5 cáracteres)</c>");
        return;
    }

    object oArea = GetArea(oPC);
    string sResRef = GetResRef(oArea);
    string sTag = GetStringRight(sTexto, GetStringLength(sTexto)-nCommand-1);
    string sAreaName = GetName(oArea) + " - " + GetName(oPC);

    SendMessageToPC(oPC, "<c?þ>Generando área...</c>");
    object oNewArea = CreateArea(sResRef, sTag, sAreaName);

    SetLocalInt(oNewArea, "AREA_CREATED", TRUE);
    SetLocalString(oNewArea, "AREA_CREATEDBY", GetName(oPC));

    if (nCommand == 14) {
        AREA_COMMANDS_CleanArea(oPC, oNewArea, 1);
    }
    if (nCommand == 16) {
        AREA_COMMANDS_CleanArea(oPC, oNewArea, FALSE);
    }

    SendMessageToPC(oPC, "<c?þ>Área creada: '" + sAreaName + "'.</c>");
}

void AREA_COMMANDS_CleanArea(object oPC, object oArea, int bDelete = TRUE) {
    int nCreatedArea = GetLocalInt(oArea, "AREA_CREATED");
    if (!nCreatedArea) {
        SendMessageToPC(oPC, "<cþ<<>¡No puedes ejecutar este comando en esta área!</c>");
        return;
    }

    if (bDelete == 2) SendMessageToPC(oPC, "<c?þ>Limpiando ubicados...</c>");
    if (bDelete == 1) SendMessageToPC(oPC, "<c?þ>Limpiando área...</c>");
    if (!bDelete) SendMessageToPC(oPC, "<c?þ>Limpiando transiciones, puertas, disparadores y waypoints...</c>");

    object oObject = GetFirstObjectInArea(oArea);
    while(GetIsObjectValid(oObject))
    {
        if(AREA_UTILS_ShouldDeleteObject(oObject, bDelete))
        {
            if (GetObjectType(oObject) == OBJECT_TYPE_DOOR && GetTransitionTarget(oObject) != OBJECT_INVALID)
                SetTransitionTarget(oObject, OBJECT_INVALID);
            else DestroyObject(oObject);
        }
        oObject = GetNextObjectInArea(oArea);
    }

    SendMessageToPC(oPC, "<c?þ>Área limpiada.</c>");
}

void AREA_COMMANDS_DeleteArea(object oPC, string sTexto) {
    if ((GetStringLength(sTexto) - 15) < 5) {
        SendMessageToPC(oPC, "<cþ<<>¡Tienes qué introducir un tag válido! (Mínimo de 5 cáracteres)</c>");
        return;
    }

    string sTag = GetStringRight(sTexto, GetStringLength(sTexto)-14-1);
    object oArea = GetObjectByTag(sTag);

    if (!GetIsObjectValid(oArea)) {
        SendMessageToPC(oPC, "<cþ<<>¡El tag especificado no corresponde a ningún objeto!</c>");
        return;
    }

    int nCreatedArea = GetLocalInt(oArea, "AREA_CREATED");

    if (!nCreatedArea) {
        SendMessageToPC(oPC, "<cþ<<>¡El tag especificado no corresponde a ninguna área válida!</c>");
        return;
    }

    int nResult = DestroyArea(oArea);

    if (nResult == 1) SendMessageToPC(oPC, "<c?þ>Área eliminada.</c>");
    else if (nResult == 0) SendMessageToPC(oPC, "<cþ<<>¡La área no es válida!</c>");
    else if (nResult == -1) SendMessageToPC(oPC, "<cþ<<>¡No puedes borrar la área inicial del módulo!</c>");
    else if (nResult == -2) SendMessageToPC(oPC, "<cþ<<>¡No puedes borrar la área con jugadores o DM dentro!</c>");
    else SendMessageToPC(oPC, "<cþ<<>¡No se ha podido borrar la área!</c>");
}

void AREA_COMMANDS_SetName(object oPC, string sTexto) {
    object oArea = GetArea(oPC);

    if ((GetStringLength(sTexto) - 15) < 5) {
        SendMessageToPC(oPC, "<cþ<<>¡Tienes qué introducir un nombre válido! (Mínimo de 5 cáracteres)</c>");
        return;
    }

    string sName = GetStringRight(sTexto, GetStringLength(sTexto)-14-1);
    int nCreatedArea = GetLocalInt(oArea, "AREA_CREATED");

    if (!nCreatedArea) {
        SendMessageToPC(oPC, "<cþ<<>¡No puedes ejecutar este comando en esta área!</c>");
        return;
    }

    SetName(oArea, sName);

    SendMessageToPC(oPC, "<c?þ>Área renombrada a: '" + sName + "'.</c>");
}

void AREA_COMMANDS_SetPlotFlag(object oPC, object oArea)
{
    int nCreatedArea = GetLocalInt(oArea, "AREA_CREATED");
    if (!nCreatedArea)
    {
        SendMessageToPC(oPC, "<cþ<<>¡No puedes ejecutar este comando en esta área!</c>");
        return;
    }

    object oObject = GetFirstObjectInArea(oArea);
    while(GetIsObjectValid(oObject))
    {
        if(GetObjectType(oObject) == OBJECT_TYPE_PLACEABLE)
        {
            SetPlotFlag(oObject, 1);
        }
        oObject = GetNextObjectInArea(oArea);
    }

    SendMessageToPC(oPC, "<c?þUbicados hechos de trama.</c>");
}

void AREA_COMMANDS_SetStatic(object oPC, object oArea)
{
    int nCreatedArea = GetLocalInt(oArea, "AREA_CREATED");
    if (!nCreatedArea)
    {
        SendMessageToPC(oPC, "<cþ<<>¡No puedes ejecutar este comando en esta área!</c>");
        return;
    }

    object oObject = GetFirstObjectInArea(oArea);
    while(GetIsObjectValid(oObject))
    {
        if(GetObjectType(oObject) == OBJECT_TYPE_PLACEABLE)
        {
            NWNX_Object_SetPlaceableIsStatic(oObject, 1);
        }
        oObject = GetNextObjectInArea(oArea);
    }

    SendMessageToPC(oPC, "<c?þUbicados hechos de trama.</c>");
}


void AREA_COMMANDS_ScriptLimpiar(object oPC, object oArea)
{
    int nCreatedArea = GetLocalInt(oArea, "AREA_CREATED");
    if (!nCreatedArea)
    {
        SendMessageToPC(oPC, "<cþ<<>¡No puedes ejecutar este comando en esta área!</c>");
        return;
    }

    SetEventScript(oArea, EVENT_SCRIPT_AREA_ON_ENTER, "");
    SetEventScript(oArea, EVENT_SCRIPT_AREA_ON_EXIT, "");
    SetEventScript(oArea, EVENT_SCRIPT_AREA_ON_HEARTBEAT, "");
    SetEventScript(oArea, EVENT_SCRIPT_AREA_ON_USER_DEFINED_EVENT, "");

    SendMessageToPC(oPC, "<c?þ>Limpiados scripts del área.</c>");
}

void AREA_COMMANDS_ScriptInterior(object oPC, object oArea)
{
    int nCreatedArea = GetLocalInt(oArea, "AREA_CREATED");
    if (!nCreatedArea)
    {
        SendMessageToPC(oPC, "<cþ<<>¡No puedes ejecutar este comando en esta área!</c>");
        return;
    }

    SetEventScript(oArea, EVENT_SCRIPT_AREA_ON_ENTER, "fvex_area_inside");
    SetEventScript(oArea, EVENT_SCRIPT_AREA_ON_EXIT, "z0_area_onexit");
    SetEventScript(oArea, EVENT_SCRIPT_AREA_ON_HEARTBEAT, "");
    SetEventScript(oArea, EVENT_SCRIPT_AREA_ON_USER_DEFINED_EVENT, "");

    SendMessageToPC(oPC, "<c?þ>eteados script del área a interiores.</c>");
}

void AREA_COMMANDS_ScriptExterior(object oPC, object oArea)
{
    int nCreatedArea = GetLocalInt(oArea, "AREA_CREATED");
    if (!nCreatedArea)
    {
        SendMessageToPC(oPC, "<cþ<<>¡No puedes ejecutar este comando en esta área!</c>");
        return;
    }

    SetEventScript(oArea, EVENT_SCRIPT_AREA_ON_ENTER, "fvex_area_outsid");
    SetEventScript(oArea, EVENT_SCRIPT_AREA_ON_EXIT, "z0_area_onexit");
    SetEventScript(oArea, EVENT_SCRIPT_AREA_ON_HEARTBEAT, "");
    SetEventScript(oArea, EVENT_SCRIPT_AREA_ON_USER_DEFINED_EVENT, "");

    SendMessageToPC(oPC, "<c?þ>eteados script del área a exteriores.</c>");
}

//////////////////////////////////////////////////////
///////////////////// UTILIDADES /////////////////////
//////////////////////////////////////////////////////

int AREA_UTILS_ShouldDeleteObject(object oObject, int bDelete = 1) {
    int nObjectType = GetObjectType(oObject);

    if (bDelete == 2 && nObjectType == OBJECT_TYPE_PLACEABLE) return TRUE;
    if (bDelete == 1)
    {
        switch(nObjectType) {
            case OBJECT_TYPE_AREA_OF_EFFECT:
            case OBJECT_TYPE_CREATURE:
            case OBJECT_TYPE_DOOR:
            case OBJECT_TYPE_ENCOUNTER:
            case OBJECT_TYPE_ITEM:
            case OBJECT_TYPE_STORE:
            case OBJECT_TYPE_TRIGGER:
            case OBJECT_TYPE_WAYPOINT:
                return TRUE;
        }
    }
    else
    {
        switch(nObjectType) {
            case OBJECT_TYPE_AREA_OF_EFFECT:
            case OBJECT_TYPE_DOOR:
            case OBJECT_TYPE_TRIGGER:
            case OBJECT_TYPE_WAYPOINT:
                return TRUE;
        }
    }

    return FALSE;
}

//void main(){}
