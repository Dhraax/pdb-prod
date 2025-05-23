#include "mti_libreria"
#include "nwnx_player"
#include "nwnx_rename"
#include "nwnx_item"
#include "x2_inc_itemprop"
#include "x3_inc_string"

// Librería de disfraces de Puerta de Baldur

// El objetivo de esta librería es unificar todas las funciones relacionadas con los disfraces / rename
// para así poder realizar una gestión más sencilla de estos

// Función utilizada para obtener el cambio de nombre aplicado a un jugador
string PB_Disguise_GetNameOverride(object oTarget, object oObserver = OBJECT_INVALID);

// Función utilizada para modificar el nombre de un jugador
// Para más información acerca del uso de la función, consultar documentación del NWNX
void PB_Disguise_SetNameOverride(object oTarget, string sNewName, int iPlayerNameState = NWNX_RENAME_PLAYERNAME_DEFAULT);

// Función utilizada para eliminar la modificación de nombre de un jugador
// Para más información acerca del uso de la función, consultar documentación del NWNX
void PB_Disguise_ClearNameOverride(object oTarget, object oObserver = OBJECT_INVALID);

//Función utilizada para que un DM al entrar tenga actualizados los nombres de los PJs.
void PB_Disguise_HandleDMOnEnter(object oDM);

//Función encargada de guardar en variables la apariencia física de un PJ.
void GuardaApariencia (object oPC, int iDisfraz);

//Función que recupera la apariencia física de una identidad.
void AplicarApariencia (object oPC, int iDisfraz);

//Función encargada de "poner en anónimo" a los jugadores.
//OnEnter == Script usado en el script de entrada al servidor.
void Disfrazarse_anonimo (object oPC, int OnEnter = FALSE);

//Función encargada de "disfrazar" a los jugadores.
//OnEnter == Script usado en el script de entrada al servidor.
void Disfrazarse_disfraz (object oPC, int iDisfraz);

//Función que ha de colocarse en el script de entrada al servidor, se encarga de disfrazar, anonimatizar o poner el nombre del PJ como cuenta
//cuando la gente conecta al servidor.
void Disfrazarse_ModEnter(object oPC);

//Función encargada de setear las identidades.
void Disfrazarse_Setear (object oPC, int iDisfraz);

//Función para hacer no visible y visible las prendas de un PJ para que no salga desnudo después de poliformarse.
void DespoliformarRopasVisibles(object oPC);

void PB_Disguise_SetNameOverride(object oTarget, string sNewName, int iPlayerNameState = NWNX_RENAME_PLAYERNAME_OVERRIDE)
{
    string sNombre = ObtenerStringPersistente(oTarget,"Disfrazado_nombre");
    NWNX_Rename_SetPCNameOverride(oTarget, sNombre, "" , "" , NWNX_RENAME_PLAYERNAME_OVERRIDE);

    object oObserver = GetFirstPC();
    while (GetIsObjectValid(oObserver))
    {
        if(oObserver != oTarget)
        {
            if(!GetIsDM(oTarget) && !GetIsDMPossessed(oTarget))
            {
                //Si es un DM o un DM con una criatura poseída.
                if (GetIsDM(oObserver) || GetIsDMPossessed(oObserver))
                {
                    //Si está disfrazado, ponemos más detales.
                    if(ObtenerIntPersistente(oTarget,"Disfrazado") > 0 || ObtenerIntPersistente(oTarget,"Anonimo") > 0)
                    {
                        NWNX_Rename_SetPCNameOverride(oTarget, "<cÍÌ >"+sNombre+"</c>", "", " (" + GetPCPlayerName(oTarget) + ")(" + GetName(oTarget, TRUE) + ")", NWNX_RENAME_PLAYERNAME_OVERRIDE, oObserver);
                    }
                    //Si no lo está, nombre normal.
                    if(ObtenerIntPersistente(oTarget,"Disfrazado") < 1 && ObtenerIntPersistente(oTarget,"Anonimo") < 1)
                    {
                        NWNX_Rename_SetPCNameOverride(oTarget, "<cÍÌ >"+sNombre+"</c>", "" , " (" + GetPCPlayerName(oTarget) + ")", NWNX_RENAME_PLAYERNAME_OVERRIDE, oObserver);
                    }
                }
            }
        }
        oObserver = GetNextPC();
    }
}

string PB_Disguise_GetNameOverride(object oTarget, object oObserver = OBJECT_INVALID)
{
    return ObtenerStringPersistente(oTarget,"Disfrazado_nombre");
}

void PB_Disguise_ClearNameOverride(object oTarget, object oObserver = OBJECT_INVALID)
{
    if (oObserver == OBJECT_INVALID) NWNX_Rename_ClearPCNameOverride(oTarget, oObserver, TRUE);
    else NWNX_Rename_ClearPCNameOverride(oTarget, oObserver);
}

void PB_Disguise_HandleOnEnter(object oEnter)
{
    object oPJ = GetFirstPC();
    while (GetIsObjectValid(oPJ))
    {
        if(oPJ != oEnter)
        {
            if(!GetIsDM(oPJ) && !GetIsDMPossessed(oPJ))
            {
                //No queremos que los DMs salgan disfrazados.
                if (GetIsDM(oEnter) || GetIsDMPossessed(oEnter))
                {
                    string sNombre = ObtenerStringPersistente(oPJ,"Disfrazado_nombre");
                    //Si está disfrazado, ponemos más detales.
                    if(ObtenerIntPersistente(oPJ,"Disfrazado") > 0 || ObtenerIntPersistente(oPJ,"Anonimo") > 0)
                    {
                        NWNX_Rename_SetPCNameOverride(oPJ, "<cÍÌ >"+sNombre+"</c>", "", " (" + GetPCPlayerName(oPJ) + ")(" + GetName(oPJ, TRUE) + ")", NWNX_RENAME_PLAYERNAME_OVERRIDE, oEnter);
                    }
                    //Si no lo está, nombre normal.
                    if(ObtenerIntPersistente(oPJ,"Disfrazado") < 1 && ObtenerIntPersistente(oPJ,"Anonimo") < 1)
                    {
                        NWNX_Rename_SetPCNameOverride(oPJ, "<cÍÌ >"+sNombre+"</c>", "" , " (" + GetPCPlayerName(oPJ) + ")", NWNX_RENAME_PLAYERNAME_OVERRIDE, oEnter);
                    }
                }

            }
        }
        oPJ = GetNextPC();
    }
}

void GuardaApariencia (object oPC, int iDisfraz)
{
    int Phenotipo = GetPhenoType(oPC);
    GuardarIntPersistente(oPC,"Phenotipo"+IntToString(iDisfraz),Phenotipo);

    int Alas = GetCreatureWingType(oPC);
    GuardarIntPersistente(oPC,"Alas"+IntToString(iDisfraz),Alas);

    int Cola = GetCreatureTailType(oPC);
    GuardarIntPersistente(oPC,"Cola"+IntToString(iDisfraz),Cola);

    int Cabeza = GetCreatureBodyPart(CREATURE_PART_HEAD, oPC);
    GuardarIntPersistente(oPC,"Cabeza"+IntToString(iDisfraz),Cabeza);

    int Cuello = GetCreatureBodyPart(CREATURE_PART_NECK, oPC);
    GuardarIntPersistente(oPC,"Cuello"+IntToString(iDisfraz),Cuello);

    int BicepIzquierdo = GetCreatureBodyPart(CREATURE_PART_LEFT_BICEP, oPC);
    GuardarIntPersistente(oPC,"BicepIzquierdo"+IntToString(iDisfraz),BicepIzquierdo);

    int BicepDerecho = GetCreatureBodyPart(CREATURE_PART_RIGHT_BICEP, oPC);
    GuardarIntPersistente(oPC,"BicepDerecho"+IntToString(iDisfraz),BicepDerecho);

    int AntebrazoIzquierdo = GetCreatureBodyPart(CREATURE_PART_LEFT_FOREARM, oPC);
    GuardarIntPersistente(oPC,"AntebrazoIzquierdo"+IntToString(iDisfraz),AntebrazoIzquierdo);

    int AntebrazoDerecho = GetCreatureBodyPart(CREATURE_PART_RIGHT_FOREARM, oPC);
    GuardarIntPersistente(oPC,"AntebrazoDerecho"+IntToString(iDisfraz),AntebrazoDerecho);

    int ManoIzquierda = GetCreatureBodyPart(CREATURE_PART_LEFT_HAND, oPC);
    GuardarIntPersistente(oPC,"ManoIzquierda"+IntToString(iDisfraz),ManoIzquierda);

    int ManoDerecha = GetCreatureBodyPart(CREATURE_PART_RIGHT_HAND, oPC);
    GuardarIntPersistente(oPC,"ManoDerecha"+IntToString(iDisfraz),ManoDerecha);

    int Torso = GetCreatureBodyPart(CREATURE_PART_TORSO, oPC);
    GuardarIntPersistente(oPC,"Torso"+IntToString(iDisfraz),Torso);

    int Pelvis = GetCreatureBodyPart(CREATURE_PART_PELVIS, oPC);
    GuardarIntPersistente(oPC,"Pelvis"+IntToString(iDisfraz),Pelvis);

    int MusloIzquierdo = GetCreatureBodyPart(CREATURE_PART_LEFT_THIGH, oPC);
    GuardarIntPersistente(oPC,"MusloIzquierdo"+IntToString(iDisfraz),MusloIzquierdo);

    int MusloDerecho = GetCreatureBodyPart(CREATURE_PART_RIGHT_THIGH, oPC);
    GuardarIntPersistente(oPC,"MusloDerecho"+IntToString(iDisfraz),MusloDerecho);

    int EspinillaIzquierda = GetCreatureBodyPart(CREATURE_PART_LEFT_SHIN, oPC);
    GuardarIntPersistente(oPC,"EspinillaIzquierda"+IntToString(iDisfraz),EspinillaIzquierda);

    int EspinillaDerecha = GetCreatureBodyPart(CREATURE_PART_RIGHT_SHIN, oPC);
    GuardarIntPersistente(oPC,"EspinillaDerecha"+IntToString(iDisfraz),EspinillaDerecha);

    int PieIzquierdo = GetCreatureBodyPart(CREATURE_PART_LEFT_FOOT, oPC);
    GuardarIntPersistente(oPC,"PieIzquierdo"+IntToString(iDisfraz),PieIzquierdo);

    int PieDerecho = GetCreatureBodyPart(CREATURE_PART_RIGHT_FOOT, oPC);
    GuardarIntPersistente(oPC,"PieDerecho"+IntToString(iDisfraz),PieDerecho);

    int ColorPiel =  GetColor(oPC, COLOR_CHANNEL_SKIN);
    GuardarIntPersistente(oPC,"ColorPiel"+IntToString(iDisfraz),ColorPiel);

    int ColorPelo = GetColor(oPC, COLOR_CHANNEL_HAIR);
    GuardarIntPersistente(oPC,"ColorPelo"+IntToString(iDisfraz),ColorPelo);

    int Color1Tatto = GetColor(oPC, COLOR_CHANNEL_TATTOO_1);
    GuardarIntPersistente(oPC,"Color1Tatto"+IntToString(iDisfraz),Color1Tatto);

    int Color2Tatto = GetColor(oPC, COLOR_CHANNEL_TATTOO_2);
    GuardarIntPersistente(oPC,"Color2Tatto"+IntToString(iDisfraz),Color2Tatto);

}

void AplicarApariencia (object oPC, int iDisfraz)
{
    SetPhenoType(ObtenerIntPersistente(oPC,"Phenotipo"+IntToString(iDisfraz)), oPC);
    SetCreatureWingType(ObtenerIntPersistente(oPC,"Alas"+IntToString(iDisfraz)), oPC);
    SetCreatureTailType(ObtenerIntPersistente(oPC,"Cola"+IntToString(iDisfraz)), oPC);
    SetCreatureBodyPart(CREATURE_PART_HEAD, ObtenerIntPersistente(oPC,"Cabeza"+IntToString(iDisfraz)), oPC);
    SetCreatureBodyPart(CREATURE_PART_NECK, ObtenerIntPersistente(oPC,"Cuello"+IntToString(iDisfraz)), oPC);
    SetCreatureBodyPart(CREATURE_PART_LEFT_BICEP, ObtenerIntPersistente(oPC,"BicepIzquierdo"+IntToString(iDisfraz)), oPC);
    SetCreatureBodyPart(CREATURE_PART_RIGHT_BICEP, ObtenerIntPersistente(oPC,"BicepDerecho"+IntToString(iDisfraz)), oPC);
    SetCreatureBodyPart(CREATURE_PART_LEFT_FOREARM, ObtenerIntPersistente(oPC,"AntebrazoIzquierdo"+IntToString(iDisfraz)), oPC);
    SetCreatureBodyPart(CREATURE_PART_RIGHT_FOREARM, ObtenerIntPersistente(oPC,"AntebrazoDerecho"+IntToString(iDisfraz)), oPC);
    SetCreatureBodyPart(CREATURE_PART_LEFT_HAND, ObtenerIntPersistente(oPC,"ManoIzquierda"+IntToString(iDisfraz)), oPC);
    SetCreatureBodyPart(CREATURE_PART_RIGHT_HAND, ObtenerIntPersistente(oPC,"ManoDerecha"+IntToString(iDisfraz)), oPC);
    SetCreatureBodyPart(CREATURE_PART_TORSO, ObtenerIntPersistente(oPC,"Torso"+IntToString(iDisfraz)), oPC);
    SetCreatureBodyPart(CREATURE_PART_PELVIS, ObtenerIntPersistente(oPC,"Pelvis"+IntToString(iDisfraz)), oPC);
    SetCreatureBodyPart(CREATURE_PART_LEFT_THIGH, ObtenerIntPersistente(oPC,"MusloIzquierdo"+IntToString(iDisfraz)), oPC);
    SetCreatureBodyPart(CREATURE_PART_RIGHT_THIGH, ObtenerIntPersistente(oPC,"MusloDerecho"+IntToString(iDisfraz)), oPC);
    SetCreatureBodyPart(CREATURE_PART_LEFT_SHIN, ObtenerIntPersistente(oPC,"EspinillaIzquierda"+IntToString(iDisfraz)), oPC);
    SetCreatureBodyPart(CREATURE_PART_RIGHT_SHIN, ObtenerIntPersistente(oPC,"EspinillaDerecha"+IntToString(iDisfraz)), oPC);
    SetCreatureBodyPart(CREATURE_PART_LEFT_FOOT, ObtenerIntPersistente(oPC,"PieIzquierdo"+IntToString(iDisfraz)), oPC);
    SetCreatureBodyPart(CREATURE_PART_RIGHT_FOOT, ObtenerIntPersistente(oPC,"PieDerecho"+IntToString(iDisfraz)), oPC);
    SetColor(oPC, COLOR_CHANNEL_SKIN, ObtenerIntPersistente(oPC,"ColorPiel"+IntToString(iDisfraz)));
    SetColor(oPC, COLOR_CHANNEL_HAIR, ObtenerIntPersistente(oPC,"ColorPelo"+IntToString(iDisfraz)));
    SetColor(oPC, COLOR_CHANNEL_TATTOO_1, ObtenerIntPersistente(oPC,"Color1Tatto"+IntToString(iDisfraz)));
    SetColor(oPC, COLOR_CHANNEL_TATTOO_2, ObtenerIntPersistente(oPC,"Color2Tatto"+IntToString(iDisfraz)));
}

void Disfrazarse_anonimo (object oPC, int OnEnter = FALSE)
{
    //Si estamos disfrazados, no podemos pasar al modo anónimo (siempre hay que volver primero a la identidad real).
    if (ObtenerIntPersistente(oPC,"Disfrazado")> 0)
    {
        SendMessageToPC(oPC, "<c´$$>No puedes entrar en modo anónimo si estás disfrazado.</c>"); return;
    }
    if(ObtenerIntPersistente(oPC, "CAB_MONTADO") > 0)
    {
        SendMessageToPC(oPC, StringToRGBString("No puede usarse estando montado.","711")); return;
        return;
    }
    //Si no estamos ya como anónimo o estamos en el OnEnter del Mod y estamos disfrazados..
    if (ObtenerIntPersistente(oPC,"Anonimo")== 0 || OnEnter == TRUE && ObtenerIntPersistente(oPC,"Anonimo")== 1)
    {
        object oEquippedItem = GetItemInSlot(INVENTORY_SLOT_HEAD, oPC);

        //Si no tiene casco...
        if(!GetIsObjectValid(oEquippedItem)) {SendMessageToPC(oPC, "<c´$$>¡Necesitas tener un casco para ocultar tu rostro!</c>"); return;}
        //Si tiene casco, pero lo tiene oculto...
        if(GetHiddenWhenEquipped(oEquippedItem)) {SendMessageToPC(oPC, "<c´$$>¡Necesitas tener el casco visible para ocultar tu rostro!</c>"); return;}

        //Indicamos el nombre de anónimo que se pondrá
        string Nombre_Anonimo = "Anónimo "+IntToString(GetLocalInt(GetModule(),"IDAnonimo"));
        //Indicamos cual es el nombre real del personaje.
        string sNombreReal = GetName(oPC, TRUE);
        //Actualizamos su estado.
        GuardarIntPersistente(oPC,"Anonimo",1);
        //Sumamos a la variable del módulo de anominos 1, para evitar repetir apodos.
        SetLocalInt(GetModule(),"IDAnonimo",GetLocalInt(GetModule(),"IDAnonimo")+1);
        //Guardamos los datos que cambiaremos al hacernos anónimos (Retrato y Descripción) solo si no es en el OnEnter.
        if(OnEnter == FALSE)
        {
            GuardarStringPersistente(oPC,"AnonimoFoto",GetPortraitResRef(oPC));
            GuardarStringPersistente(oPC,"AnonimoDescripcion",GetDescription(oPC));
        }´
        //Cambiamos el portrait
        if(GetGender(oPC) == 0){SetPortraitResRef(oPC,"Human_male_99");}        //Retrato de hombre encapuchado.
        else if(GetGender(oPC) == 1){SetPortraitResRef(oPC,"Human_female_99");} //Retrato de mujer encapuchada.
        //Borramos la descripción.
        SetDescription(oPC, "\n");
        //Mensaje de actualizado.
        SendMessageToPC(oPC, "<c þ >Entras en el modo anónimo, recuerda que por limitaciones del sistema, debes reentrar al servidor para que tu cuenta sea la misma que el nombre del PJ.</c>");
        //Sistema de seguridad para evitar ponernos en anónimo para insultar a la gente, queda registrado en el log todo.
        WriteTimestampedLogEntry("**SISTEMA DE DISFRACES** El personaje: "+sNombreReal+"; entra en modo anónimo como: "+Nombre_Anonimo);
        GuardarStringPersistente(oPC,"Disfrazado_nombre", Nombre_Anonimo);
        //Lo ponemos como anónimo para todos.
        PB_Disguise_SetNameOverride(oPC, Nombre_Anonimo, NWNX_RENAME_PLAYERNAME_OVERRIDE);
    }
    //Si estamos como anónimo, solo se activa si no es cuando se entra al servidor (cuando el PJ quiere quitarse el anonimo).
    else if (OnEnter == FALSE && ObtenerIntPersistente(oPC,"Anonimo")== 1)
    {
        //Indicamos el nombre de anónimo que se pondrá
        string Nombre_Original = GetName(oPC,TRUE);
        //Cambiamos el portrait y retrato
        SetPortraitResRef(oPC,ObtenerStringPersistente(oPC,"AnonimoFoto"));
        SetDescription(oPC,ObtenerStringPersistente(oPC,"AnonimoDescripcion"));
        //Borramos las variables
        BorrarIntPersistente(oPC,"Anonimo");
        BorrarStringPersistente(oPC,"AnonimoFoto");
        BorrarStringPersistente(oPC,"AnonimoDescripcion");
        //Mensaje de actualizado.
        SendMessageToPC(oPC, "<c þ >Sales del modo anónimo, recuerda que por limitaciones del sistema, debes reentrar al servidor para que tu cuenta sea la misma que el nombre del PJ.</c>");
        GuardarStringPersistente(oPC,"Disfrazado_nombre", Nombre_Original);
        PB_Disguise_SetNameOverride(oPC, Nombre_Original, NWNX_RENAME_PLAYERNAME_OVERRIDE);
    }
}

void Disfrazarse_disfraz (object oPC, int iDisfraz)
{
    //No puedes disfrazarte si estás en modo anónimo.
    if (ObtenerIntPersistente(oPC,"Anonimo")== 1)
    {
        SendMessageToPC(oPC, "<c´$$>No puedes disfrazarte en modo anónimo.</c>"); return;
    }

    //Si no se ha seteado la identidad normal e intentamos disfrazarnos con una identidad alternativa, cancelamos.
    if(ObtenerIntPersistente(oPC,"Seteado0")!= 1 && iDisfraz > 0)
    {
        SendMessageToPC(oPC, "<c´$$>Debes setear tu identidad normal.</c>"); return;
    }

    //Obligamos a tener 1 punto a disfrazarse para poder usar el sistema.
    if (iDisfraz > 0 && GetSkillRank(30,oPC,TRUE) < 1)
    {
         //Si no tiene puntos a disfrazar y además, no es cambiante, entonces sí damos error.
         if(iDisfraz > 0 && GetLevelByClass(CLASS_TYPE_SHIFTER, oPC) < 1)
         {
            SendMessageToPC(oPC, "<c´$$>No puedes disfrazarte si no tienes puntos en la habilidad disfraz.</c>"); return;
         }
    }

    //No dejamos disfrazarnos estando montado.
    if(ObtenerIntPersistente(oPC, "CAB_MONTADO") > 0)
    {
        SendMessageToPC(oPC, StringToRGBString("No puede usarse estando montado.","711")); return;
        return;
    }

    //Sacamos los asaltos de los efectos, por si tenemos que aplicarlos.
    //Según nuestro rango tardamos mas o menos en disfrazarnos
    int iAsaltos;
    if(GetSkillRank(30, oPC) > 20 ){iAsaltos = 1;}
    else if(GetSkillRank(30, oPC) <= 20 && GetSkillRank(30, oPC) >= 10 ){iAsaltos = 2;}
    else if(GetSkillRank(30, oPC) < 10){iAsaltos = 3;}
    float fAsaltos = RoundsToSeconds(iAsaltos);

    //Efecto visual.
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);

    //Pasamos con el disfraz.
    //El disfraz que queremos ya está seteado.
    if (ObtenerIntPersistente(oPC,"Seteado"+IntToString(iDisfraz)) == 1)
    {
        //Indicamos el nombre que se usará
        string Nombre_Disfraz = ObtenerStringPersistente(oPC,"DisfrazNombre"+IntToString(iDisfraz));
        //Aplicamos los efectos...
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oPC, fAsaltos);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_PARALYZED), oPC, fAsaltos);
        DelayCommand(fAsaltos, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC));
        //Mensaje de aviso.
        if(iDisfraz > 0)
        {
            SendMessageToPC(oPC,"Disfrazarte te llevará " + IntToString(iAsaltos) + " asaltos.");
        }
        if(iDisfraz == 0)
        {
            SendMessageToPC(oPC,"Retirarte el disfraz te llevará " + IntToString(iAsaltos) + " asaltos.");
        }
        //AntiSpam de la varita.
        GuardarIntPersistente(oPC,"DISFRAZ_SPAM",iDisfraz);
        //Cambiamos el portrait y la descripción.
        DelayCommand(fAsaltos + 0.5,SetPortraitResRef(oPC,ObtenerStringPersistente(oPC,"DisfrazFoto"+IntToString(iDisfraz))));
        DelayCommand(fAsaltos + 0.5,SetDescription(oPC, ObtenerStringPersistente(oPC,"DisfrazDescripcion"+IntToString(iDisfraz))));
        //Aplicamos la apariencia seteada.
        DelayCommand(fAsaltos + 0.5,AplicarApariencia (oPC, iDisfraz));
        //Estas variables y mensajes solo aparecen cuando se disfraza uno con una identidad no real.
        if (iDisfraz > 0)
        {
            //Mensaje de aviso.
            DelayCommand(fAsaltos + 0.5,SendMessageToPC(oPC, "<c þ >Disfraz "+IntToString(iDisfraz)+" aplicado, recuerda que por limitaciones del sistema, debes reentrar al servidor para que tu cuenta sea la misma que el nombre del PJ.</c>"));
            //Guardamos la CD.
            GuardarIntPersistente(oPC,"CD",d20() + GetSkillRank(30,oPC));
            //SendMessageToPC(oPC, "Tu tirada de d20 + Disfrazarse da total de: "+IntToString(ObtenerIntPersistente(oPC,"CD"))+".");
            WriteTimestampedLogEntry("**SISTEMA DE DISFRACES** El personaje: "+GetName(oPC,TRUE)+"; entra en modo disfrazado como: "+Nombre_Disfraz);
        }
        //Cuando se disfraza con la identidad real, limpia la variable de la CD.
        else if (iDisfraz == 0)
        {
            BorrarIntPersistente(oPC,"CD");
            //Mensaje de aviso.
            DelayCommand(fAsaltos + 0.5,SendMessageToPC(oPC, "<c þ >Disfraz retirado, recuerda que por limitaciones del sistema, debes reentrar al servidor para que tu cuenta sea la misma que el nombre del PJ.</c>"));
        }
        //Indicamos que está disfrazado
        GuardarIntPersistente(oPC,"Disfrazado",iDisfraz);
        DelayCommand(fAsaltos + 2.0, BorrarIntPersistente(oPC, "DISFRAZ_SPAM"));
        GuardarStringPersistente(oPC,"Disfrazado_nombre", Nombre_Disfraz);
        //Cambiamos el nombre del PJ.
        DelayCommand(fAsaltos + 0.5,PB_Disguise_SetNameOverride(oPC, Nombre_Disfraz, NWNX_RENAME_PLAYERNAME_OVERRIDE));
    }
    if (ObtenerIntPersistente(oPC,"Seteado"+IntToString(iDisfraz)) == 0 && iDisfraz != 5)
    {
        SendMessageToPC(oPC,"<c´$$>Esta identidad no está seteada.</c>"); return;
    }
    //Usamos la opción de aleatorio.
    else if (iDisfraz== 5)
    {
        //Aplicamos los efectos...
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oPC, fAsaltos);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_PARALYZED), oPC, fAsaltos);
        DelayCommand(fAsaltos, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC));
        //Mensaje de aviso.
        SendMessageToPC(oPC,"Disfrazarte te llevará " + IntToString(iAsaltos) + " asaltos.");
        //Asignamos un nombre aleatorio y portrait
        string AleatorioName, sPortrait;
        switch (GetRacialType(oPC))
        {
            case RACIAL_TYPE_DWARF: switch (GetGender(oPC))
            {
                case 0:
                    AleatorioName = RandomName(NAME_FIRST_DWARF_MALE);
                    sPortrait = "po_dw_m_0" + IntToString(Random(6)+1) + "_";
                    break;
                case 1:
                    AleatorioName = RandomName(NAME_FIRST_DWARF_FEMALE);
                    sPortrait = "po_dw_f_0" + IntToString(Random(6)+1) + "_";
                    break;
            }
            break;
            case RACIAL_TYPE_ELF: switch (GetGender(oPC))
            {
                case 0:
                    AleatorioName = RandomName(NAME_FIRST_ELF_MALE);
                    sPortrait = "po_el_m_0" + IntToString(Random(6)+1) + "_";
                    break;
                case 1:
                    AleatorioName = RandomName(NAME_FIRST_ELF_FEMALE);
                    sPortrait = "po_el_f_0" + IntToString(Random(6)+1) + "_";
                    break;
                }
            break;
            case RACIAL_TYPE_GNOME: switch (GetGender(oPC))
            {
                case 0:
                    AleatorioName = RandomName(NAME_FIRST_GNOME_MALE);
                    sPortrait = "po_gn_m_0" + IntToString(Random(6)+1) + "_";
                    break;
                case 1:
                    AleatorioName = RandomName(NAME_FIRST_GNOME_FEMALE);
                    sPortrait = "po_gn_f_0" + IntToString(Random(6)+1) + "_";
                    break;
            }
            break;
            case RACIAL_TYPE_HALFELF: switch (GetGender(oPC))
            {
                case 0:
                AleatorioName = RandomName(NAME_FIRST_HALFELF_MALE);
                sPortrait = "po_hu_m_0" + IntToString(Random(6)+1) + "_";
                break;
                case 1:
                    AleatorioName = RandomName(NAME_FIRST_HALFELF_FEMALE);
                    sPortrait = "po_hu_f_0" + IntToString(Random(6)+1) + "_";
                    break;
            }
            break;
            case RACIAL_TYPE_HALFLING: switch (GetGender(oPC))
            {
                case 0:
                    AleatorioName = RandomName(NAME_FIRST_HALFLING_MALE);
                    sPortrait = "po_ha_m_0" + IntToString(Random(6)+1) + "_";
                    break;
                case 1:
                    AleatorioName = RandomName(NAME_FIRST_HALFLING_FEMALE);
                    sPortrait = "po_ha_f_0" + IntToString(Random(6)+1) + "_";
                    break;
            }
            break;
            case RACIAL_TYPE_HALFORC: switch (GetGender(oPC))
            {
                case 0: AleatorioName = RandomName(NAME_FIRST_HALFLING_MALE);
                sPortrait = "po_or_m_0" + IntToString(Random(6)+1) + "_";
                break;
            case 1:
                AleatorioName = RandomName(NAME_FIRST_HALFLING_FEMALE);
                sPortrait = "po_or_f_0" + IntToString(Random(6)+1) + "_";
                break;
            }
            break;
            default:
                switch (GetGender(oPC))
                {
                    case 0:
                        AleatorioName = RandomName(NAME_FIRST_HUMAN_MALE);
                        sPortrait = "po_hu_m_0" + IntToString(Random(6)+1) + "_";
                        break;
                    case 1:
                        AleatorioName = RandomName(NAME_FIRST_HUMAN_FEMALE);
                        sPortrait = "po_hu_f_0" + IntToString(Random(6)+1) + "_";
                        break;
                }
            break;
        }
        if(AleatorioName == "")
        {
            switch (GetGender(oPC))
            {
                case 0:
                    AleatorioName = RandomName(NAME_FIRST_HUMAN_MALE);
                    sPortrait = "po_hu_m_0" + IntToString(Random(6)+1) + "_";
                    break;
                case 1:
                    AleatorioName = RandomName(NAME_FIRST_HUMAN_FEMALE);
                    sPortrait = "po_hu_f_0" + IntToString(Random(6)+1) + "_";
                    break;
            }

        }
        //AntiSpam de la varita.
        GuardarIntPersistente(oPC, "DISFRAZ_SPAM", 1);
        //Cambiamos el portrait y la descripción.
        DelayCommand(fAsaltos + 0.5,SetPortraitResRef(oPC,sPortrait));
        DelayCommand(fAsaltos + 0.5,SetDescription(oPC, "\n"));
        //Aplicamos la apariencia seteada.
        //DelayCommand(fAsaltos + 0.5,AplicarApariencia (oPC, iDisfraz));
        //Indicamos que está disfrazado
        GuardarIntPersistente(oPC,"Disfrazado",iDisfraz);
        //Mensaje de aviso.
        DelayCommand(fAsaltos + 0.5,SendMessageToPC(oPC, "<c þ >Disfraz "+IntToString(iDisfraz)+" aplicado, recuerda que por limitaciones del sistema, debes reentrar al servidor para que tu cuenta sea la misma que el nombre del PJ.</c>"));
        //Guardamos la CD.
        GuardarIntPersistente(oPC,"CD",d20() + GetSkillRank(30,oPC));
        //SendMessageToPC(oPC, "Tu tirada de d20 + Disfrazarse da total de: "+IntToString(ObtenerIntPersistente(oPC,"CD"))+".");
        WriteTimestampedLogEntry("**SISTEMA DE DISFRACES** El personaje: "+GetName(oPC,TRUE)+"; entra en modo disfrazado como: "+AleatorioName);
        DelayCommand(fAsaltos + 2.0, BorrarIntPersistente(oPC, "DISFRAZ_SPAM"));
        GuardarStringPersistente(oPC,"Disfrazado_nombre", AleatorioName);
        //Cambiamos el nombre del PJ.
        DelayCommand(fAsaltos + 0.5,PB_Disguise_SetNameOverride(oPC, AleatorioName, NWNX_RENAME_PLAYERNAME_OVERRIDE));
    }
}

//Un jugador entra al servidor estando disfrazado.
void Disfrazarse_Disfraz_OnEnter (object oPC, int iDisfraz)
{
    if (iDisfraz!= 5)
    {
        //Indicamos el nombre que se usará
        string Nombre_Disfraz = ObtenerStringPersistente(oPC,"DisfrazNombre"+IntToString(iDisfraz));
        //Cambiamos el portrait y la descripción.
        SetPortraitResRef(oPC,ObtenerStringPersistente(oPC,"DisfrazFoto"+IntToString(iDisfraz)));
        SetDescription(oPC, ObtenerStringPersistente(oPC,"DisfrazDescripcion"+IntToString(iDisfraz)));
        //Aplicamos la apariencia seteada.
        AplicarApariencia (oPC, iDisfraz);
        WriteTimestampedLogEntry("**SISTEMA DE DISFRACES** El personaje: "+GetName(oPC,TRUE)+"; entra en modo disfrazado como: "+Nombre_Disfraz);
        DelayCommand(2.0,BorrarIntPersistente(oPC, "DISFRAZ_SPAM"));
        GuardarStringPersistente(oPC,"Disfrazado_nombre", Nombre_Disfraz);
        //Cambiamos el nombre del PJ.
        PB_Disguise_SetNameOverride(oPC, Nombre_Disfraz, NWNX_RENAME_PLAYERNAME_OVERRIDE);
    }
    //Usamos la opción de aleatorio.
    else if (iDisfraz== 5)
    {
        //Asignamos un nombre aleatorio y portrait
        string AleatorioName, sPortrait;
        switch (GetRacialType(oPC))
        {
            case RACIAL_TYPE_DWARF: switch (GetGender(oPC))
            {
                case 0:
                    AleatorioName = RandomName(NAME_FIRST_DWARF_MALE);
                    sPortrait = "po_dw_m_0" + IntToString(Random(6)+1) + "_";
                    break;
                case 1:
                    AleatorioName = RandomName(NAME_FIRST_DWARF_FEMALE);
                    sPortrait = "po_dw_f_0" + IntToString(Random(6)+1) + "_";
                    break;
            }
            break;
            case RACIAL_TYPE_ELF: switch (GetGender(oPC))
            {
                case 0:
                    AleatorioName = RandomName(NAME_FIRST_ELF_MALE);
                    sPortrait = "po_el_m_0" + IntToString(Random(6)+1) + "_";
                    break;
                case 1:
                    AleatorioName = RandomName(NAME_FIRST_ELF_FEMALE);
                    sPortrait = "po_el_f_0" + IntToString(Random(6)+1) + "_";
                    break;
                }
            break;
            case RACIAL_TYPE_GNOME: switch (GetGender(oPC))
            {
                case 0:
                    AleatorioName = RandomName(NAME_FIRST_GNOME_MALE);
                    sPortrait = "po_gn_m_0" + IntToString(Random(6)+1) + "_";
                    break;
                case 1:
                    AleatorioName = RandomName(NAME_FIRST_GNOME_FEMALE);
                    sPortrait = "po_gn_f_0" + IntToString(Random(6)+1) + "_";
                    break;
            }
            break;
            case RACIAL_TYPE_HALFELF: switch (GetGender(oPC))
            {
                case 0:
                AleatorioName = RandomName(NAME_FIRST_HALFELF_MALE);
                sPortrait = "po_hu_m_0" + IntToString(Random(6)+1) + "_";
                break;
                case 1:
                    AleatorioName = RandomName(NAME_FIRST_HALFELF_FEMALE);
                    sPortrait = "po_hu_f_0" + IntToString(Random(6)+1) + "_";
                    break;
            }
            break;
            case RACIAL_TYPE_HALFLING: switch (GetGender(oPC))
            {
                case 0:
                    AleatorioName = RandomName(NAME_FIRST_HALFLING_MALE);
                    sPortrait = "po_ha_m_0" + IntToString(Random(6)+1) + "_";
                    break;
                case 1:
                    AleatorioName = RandomName(NAME_FIRST_HALFLING_FEMALE);
                    sPortrait = "po_ha_f_0" + IntToString(Random(6)+1) + "_";
                    break;
            }
            break;
            case RACIAL_TYPE_HALFORC: switch (GetGender(oPC))
            {
                case 0: AleatorioName = RandomName(NAME_FIRST_HALFLING_MALE);
                sPortrait = "po_or_m_0" + IntToString(Random(6)+1) + "_";
                break;
            case 1:
                AleatorioName = RandomName(NAME_FIRST_HALFLING_FEMALE);
                sPortrait = "po_or_f_0" + IntToString(Random(6)+1) + "_";
                break;
            }
            break;
            default:
                switch (GetGender(oPC))
                {
                    case 0:
                        AleatorioName = RandomName(NAME_FIRST_HUMAN_MALE);
                        sPortrait = "po_hu_m_0" + IntToString(Random(6)+1) + "_";
                        break;
                    case 1:
                        AleatorioName = RandomName(NAME_FIRST_HUMAN_FEMALE);
                        sPortrait = "po_hu_f_0" + IntToString(Random(6)+1) + "_";
                        break;
                }
            break;
        }
        if(AleatorioName == "")
        {
            switch (GetGender(oPC))
            {
                case 0:
                    AleatorioName = RandomName(NAME_FIRST_HUMAN_MALE);
                    sPortrait = "po_hu_m_0" + IntToString(Random(6)+1) + "_";
                    break;
                case 1:
                    AleatorioName = RandomName(NAME_FIRST_HUMAN_FEMALE);
                    sPortrait = "po_hu_f_0" + IntToString(Random(6)+1) + "_";
                    break;
            }

        }
        //Cambiamos el portrait y la descripción.
        SetPortraitResRef(oPC,sPortrait);
        SetDescription(oPC, "\n");
        //Aplicamos la apariencia seteada.
        //AplicarApariencia (oPC, iDisfraz);
        //SendMessageToPC(oPC, "Tu tirada de d20 + Disfrazarse da total de: "+IntToString(ObtenerIntPersistente(oPC,"CD"))+".");
        WriteTimestampedLogEntry("**SISTEMA DE DISFRACES** El personaje: "+GetName(oPC,TRUE)+"; entra en modo disfrazado como: "+AleatorioName);
        DelayCommand(2.0,BorrarIntPersistente(oPC, "DISFRAZ_SPAM"));
        GuardarStringPersistente(oPC,"Disfrazado_nombre", AleatorioName);
        //Cambiamos el nombre del PJ.
        PB_Disguise_SetNameOverride(oPC, AleatorioName, NWNX_RENAME_PLAYERNAME_OVERRIDE);
    }
}

void Disfrazarse_ModEnter(object oPC)
{
    //Esta sección del sistema de disfraces, solo salta en PJs (a no ser que que se quiera lo contrario).
    if(!GetIsDM(oPC))
    {
        //Los jugadores entran al servidor habiéndose desconectado en anónimo.
        if(ObtenerIntPersistente(oPC,"Anonimo")== 1)
        {
            Disfrazarse_anonimo (oPC, TRUE);
        }
        //Los jugadores entran al servidor habiéndose desconectado disfrazados.
        else if(ObtenerIntPersistente(oPC,"Disfrazado")>0)
        {
            Disfrazarse_Disfraz_OnEnter (oPC, ObtenerIntPersistente(oPC,"Disfrazado"));
        }
        else
        {
            GuardarStringPersistente(oPC,"Disfrazado_nombre", GetName(oPC,TRUE));
            //Cambiamos el nombre del PJ y cuenta, al nombre del PJ (sistema anti metarroleos).
            PB_Disguise_SetNameOverride(oPC, GetName(oPC,TRUE), NWNX_RENAME_PLAYERNAME_OVERRIDE);
        }
    }
}

void Disfrazarse_Setear (object oPC, int iDisfraz)
{
    if (ObtenerIntPersistente(oPC,"Anonimo")== 1)
    {
        SendMessageToPC(oPC, "<c´$$>No puedes setear la identidad en modo anónimo.</c>"); return;
    }
    //Si no se ha seteado la identidad normal e intentamos setear otras identidades...
    if(ObtenerIntPersistente(oPC,"Seteado0")!= 1 && iDisfraz > 0)
    {
        SendMessageToPC(oPC, "<c´$$>Debes setear tu identidad normal.</c>"); return;
    }
    //No dejamos disfrazarnos estando montado.
    if(ObtenerIntPersistente(oPC, "CAB_MONTADO") > 0)
    {
        SendMessageToPC(oPC, StringToRGBString("No puede usarse estando montado.","711")); return;
        return;
    }

    //Guardamos datos interesantes del personaje antes de cambiarlo.
    GuardarStringPersistente(oPC,"DisfrazFoto"+IntToString(iDisfraz),GetPortraitResRef(oPC));
    GuardarStringPersistente(oPC,"DisfrazDescripcion"+IntToString(iDisfraz),GetDescription(oPC));
    //Si estamos seteando la identidad normal, siempre ponemos el nombre original.
    if(iDisfraz == 0)
    {
        GuardarStringPersistente(oPC,"DisfrazNombre"+IntToString(iDisfraz),GetName(oPC,TRUE));
    }
    //Si estamos seteando la identidad falsa, siempre ponemos de nombre falso: Identidad "x" y decimos a los jugadores que seteen el nombre con el comando !renombrar.
    if(iDisfraz > 0)
    {
        GuardarStringPersistente(oPC,"DisfrazNombre"+IntToString(iDisfraz),"Identidad "+IntToString(iDisfraz));
        SendMessageToPC(oPC, "Recuerda, para setear a esta identidad un nombre diferente, deberás disfrazarte con la misma y usar el comando !renombrar.");
    }
    //Guardamos apariencia del pj en ese momento.
    GuardaApariencia (oPC, iDisfraz);
    //Aplicamos la identidad básicas como seteada
    GuardarIntPersistente(oPC,"Seteado"+IntToString(iDisfraz),1);
    SendMessageToPC(oPC, "<c þ >Identidad seteada.</c>");
}

void RevertirRopa (object oPC, object oObjetivo, int iApaElegida)
{
    //Miramos el tipo de objeto que es.
    int iTipo = GetBaseItemType(oObjetivo);

    //El objeto no es aún reversible.
    if(GetLocalInt(oObjetivo,"iRopaReversible")!=1)
    {
        string sApariencia = NWNX_Item_GetEntireItemAppearance(oObjetivo);
        SetLocalString(oObjetivo,"sApariencia1",sApariencia);
        SetLocalString(oObjetivo,"sApariencia2",sApariencia);
        SetLocalString(oObjetivo,"sApariencia3",sApariencia);
        SetLocalString(oObjetivo,"sApariencia4",sApariencia);
        SetLocalString(oObjetivo,"sApariencia5",sApariencia);
        SetLocalInt(oObjetivo,"Version",1);
        SetLocalInt(oObjetivo,"iRopaReversible",1);
        SendMessageToPC(oPC,"<c´$$>Tu objeto ahora es reversible, ahora mismo estás usando la apariencia base del mismo.</c>");
        return;
    }
    //El objeto es reversible.
    if(GetLocalInt(oObjetivo,"iRopaReversible")==1)
    {
        //Miramos primero qué versión estamos usando.
        int iVersion = GetLocalInt(oObjetivo,"Version");

        //Intentamos poner la misma apariencia que ya tiene.
        if(iVersion == iApaElegida)
        {
            SendMessageToPC(oPC,"<c´$$>Tu objeto ya tiene esa apariencia guardada aplicada.</c>");
            return;
        }

        //Otra apariencia...

        //Guardamos la apariencia actual para su posterior uso.
        string sAparienciaActual = NWNX_Item_GetEntireItemAppearance(oObjetivo);
        SetLocalString(oObjetivo,"sApariencia"+IntToString(iVersion),sAparienciaActual);

        //Cargamos la apariencia que queremos.
        NWNX_Item_RestoreItemAppearance(oObjetivo,GetLocalString(oObjetivo,"sApariencia"+IntToString(iApaElegida)));

        //Pasamos con el retirado y entrega del nuevo item.
        //Copiamos el item original en el PJ.
        object oItem = CopyItem(oObjetivo, oPC, TRUE);
        //Destruimos el item antiguo del PJ.
        DestroyObject(oObjetivo);
        //Miramos el Slot que usamos.
        int iSlot;
        if(iTipo==BASE_ITEM_ARMOR){iSlot = INVENTORY_SLOT_CHEST;}
        if(iTipo==BASE_ITEM_HELMET){iSlot = INVENTORY_SLOT_HEAD;}
        if(iTipo==BASE_ITEM_CLOAK){iSlot = INVENTORY_SLOT_CLOAK;}
        if((iTipo==BASE_ITEM_SMALLSHIELD)||(iTipo==BASE_ITEM_LARGESHIELD)||(iTipo==BASE_ITEM_TOWERSHIELD)){iSlot = INVENTORY_SLOT_LEFTHAND;}
        if(IPGetIsMeleeWeapon(oObjetivo) == TRUE || IPGetIsRangedWeapon(oObjetivo) == TRUE)
        {
            if(!GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC))){iSlot = INVENTORY_SLOT_RIGHTHAND;}
            if(GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC))){iSlot = INVENTORY_SLOT_LEFTHAND;}
        }
        //Guardamos la versión que estamos usando.
        SetLocalInt(oItem,"Version",iApaElegida);
        //Equipamos el item.
        AssignCommand(oPC, ActionEquipItem(oItem, iSlot));
    }
}


void DespoliformarRopasVisibles(object oPC)
{
    object oYelmo = GetItemInSlot(INVENTORY_SLOT_HEAD,oPC);
    if(GetIsObjectValid(oYelmo))
    {
        SetHiddenWhenEquipped(oYelmo, TRUE);
        DelayCommand(1.0, SetHiddenWhenEquipped(oYelmo, FALSE));
    }
    object oArmadura = GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
    if(GetIsObjectValid(oArmadura))
    {
        SetHiddenWhenEquipped(oArmadura, TRUE);
        DelayCommand(1.0, SetHiddenWhenEquipped(oArmadura, FALSE));
    }
    object oCapa = GetItemInSlot(INVENTORY_SLOT_CLOAK,oPC);
    if(GetIsObjectValid(oCapa))
    {
        SetHiddenWhenEquipped(oCapa, TRUE);
        DelayCommand(1.0, SetHiddenWhenEquipped(oCapa, FALSE));
    }
}

void MensajeEntradaoSalida (object oPC, int iModo)
{
    int iActivado = ObtenerIntPersistente(oPC, "EntradaySalidaAviso");

    //Si es el DM el que entra o sale, cancelamos.
    if(GetIsDM(oPC)) return;

    if(iActivado == 0)
    {
        string sNombre = PB_Disguise_GetNameOverride(oPC);
        string sTexto;
        //Entradas
        if(iModo == 1) sTexto = sNombre+" se ha unido como jugador.";
        //Salidas
        if(iModo == 2) sTexto = sNombre+" ha abandonado la partida como jugador.";

        //Mensaje
        object oPJ = GetFirstPC();
        while (GetIsObjectValid(oPJ))
        {
            //Si el jugador no es quien entra o sale.
            //if(oPJ != oPC)
            //{
                //A los DMs ya les sale los mensajes originales del servidor, no solapar más.
                if(!GetIsDM(oPJ) && !GetIsDMPossessed(oPJ))
                {
                    SendMessageToPC(oPJ,ColorTexto(sTexto,TXT_COLOR_GRIS));
                }
            //}
            oPJ = GetNextPC();
        }
    }

}

//void main(){}
