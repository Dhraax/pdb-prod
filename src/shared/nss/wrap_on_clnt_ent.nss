/// ----------------------------------------------------------------------------
/// @system PB_EE_PROD
/// @file wrap_on_clnt_ent.nss
/// @author Dhraax
/// @brief  OnClientEnter event script. Handles player login logic and persistent effect cleanup.
/// ----------------------------------------------------------------------------

#include "x0_i0_petrify"
#include "mti_libreria"
#include "f_vampire_clentr"
#include "HC_Inc_HTF"
#include "tj_inc"
#include "nwnx_chat"
#include "nwnx_admin"
#include "nwnx_creature"
#include "x0_i0_spells"
#include "pb_constantes"
#include "lib_disguise"
#include "lib_dm_vfx"
#include "inc_spells"
#include "x3_inc_string"

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

/// @brief Removes stuck darkness effects from a player if not inside a darkness AoE.
/// @param oPC The player character to check and clean.
/// @returns void
void RemoveStuckDarknessEffects(object oPC);


// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

/// @brief Removes stuck darkness effects from a player if not inside a darkness AoE.
/// @param oPC The player character to check and clean.
/// @returns void
void RemoveStuckDarknessEffects(object oPC)
{
    int iSpellDarkness = SPELL_DARKNESS;
    int iHasDarkness = GetHasSpellEffect(iSpellDarkness, oPC);
    int iIsInDarkness = FALSE;
    object oAreaEffect = GetFirstObjectInShape(SHAPE_SPHERE, 6.0, GetLocation(oPC), FALSE, OBJECT_TYPE_AREA_OF_EFFECT);

    while (GetIsObjectValid(oAreaEffect))
    {
        if (GetAoEId(oAreaEffect) == iSpellDarkness)
        {
            if (GetDistanceBetweenLocations(GetLocation(oPC), GetLocation(oAreaEffect)) <= GetAoERadius(AOE_PER_DARKNESS))
            {
                iIsInDarkness = TRUE;
                break;
            }
        }
        oAreaEffect = GetNextObjectInShape(SHAPE_SPHERE, 6.0, GetLocation(oPC));
    }

    if (iHasDarkness && !iIsInDarkness)
    {
        gsSPRemoveEffect(oPC, iSpellDarkness, OBJECT_INVALID, "", TRUE);
        SendMessageToPC(oPC, "<c´$$>Stuck darkness effects have been removed.</c>");
    }
}

// -----------------------------------------------------------------------------
//                             Main Function
// -----------------------------------------------------------------------------

void main()
{
    object oPC = GetEnteringObject();

    // PJS NUEVOS
    if(GetXP(oPC) == 0 && !GetIsDM(oPC) && !GetIsDMPossessed(oPC)) ExecuteScript("persist_pjs_nuev", OBJECT_SELF);

     //SISTEMA DE DISFRACES.
    Disfrazarse_ModEnter(oPC);

    // AJUSTES ESPECÍFICOS PARA DUNGEON MASTERS
    if(GetIsDM(oPC))
    {
        // Dar la herramienta explotadora dmfi al dm
        if (GetIsObjectValid(GetItemPossessedBy(oPC, "dmfi_exploder")) == FALSE) CreateItemOnObject("dmfi_exploder", oPC);
        // Revelar disfraces de los jugadores conectados
        PB_Disguise_HandleOnEnter(oPC);
        return;
    }

    // INICIAR EL SISTEMA DE HAMBRE/SED/FATIGA
    InitPCHTFLevels(oPC);

    // REGISTRO EN EL LOG
    WriteTimestampedLogEntry("[SISTEMA DE SEGURIDAD] Informe: El PJ: " + GetName(oPC) + " de la cuenta: "
    + GetPCPlayerName(oPC)+" ha entrado en el servidor."
    + " Su CdKey es: " + GetPCPublicCDKey(oPC) + ";"
    + " y su dirección ip es: "  + GetPCIPAddress(oPC));

    // MANUAL DEL SERVIDOR
    object oManual = GetItemPossessedBy(oPC, "i420_i_ac_pstat");
    if(GetIsObjectValid(oManual) == TRUE) DestroyObject(oManual);
    //CreateItemOnObject("i420_i_ac_pstat", oPC);

    // Dote PB Convocados
    if(!GetHasFeat(FEAT_PLAYER_TOOL_06, oPC)) ExecuteScript("dote_pbconv", oPC);

    // COMPROBAR QUE EL JUGADOR TIENE LA DOTE DE CONVOCAR ALIADOS Y SU ELIMINAODR EN CASO DE BUGEOS.
    if(GetClassByPosition(1,oPC)==44 || GetClassByPosition(2,oPC)==44 || GetClassByPosition(3,oPC)==44 || //Ladrón de las Sombras
       GetClassByPosition(1,oPC)==49 || GetClassByPosition(2,oPC)==49 || GetClassByPosition(3,oPC)==49 || //Señor de la guerra muraní
       GetHasFeat(1550, oPC) || GetHasFeat(1555, oPC))  //Liderazgo Guerrero, Allegado MDL
    {
        if(!GetIsObjectValid(GetItemPossessedBy(oPC, "pb_elimconvocado")))
        {
            CreateItemOnObject("pb_elimconvocado", oPC);
        }

    }

    // RESTAURAR ALTURA DEL PJ.
    // APLICARÁ SIEMPRE QUE EL PJ ENTRE Y NO LO HAGA ESTANDO POLIFORMADO USANDO LA DOTE DE POLIFORMAR DE LAS RAZAS COMO EL FEY'RI Y EL OGRO HECHICERO.
    if (ObtenerIntPersistente(oPC, "CAB_ALTURA")==TRUE &&
        (ObtenerIntPersistente(oPC, "APTITUD_POLY_RAZA") == FALSE))
    {
        float fAltura = ObtenerFloatPersistente(oPC, "IND_ALTURA");
        if(fAltura > PB_Race_TamanoMaximo (oPC))
        {
            fAltura = PB_Race_TamanoMaximo (oPC);
            GuardarFloatPersistente(oPC, "IND_ALTURA", fAltura);
            SendMessageToPC(oPC, "<c´$$>Se ha ajustado tu altura al máximo de tu raza.</c>");
        }
        if(fAltura < PB_Race_TamanoMinimo (oPC))
        {
            fAltura = PB_Race_TamanoMinimo (oPC);
            GuardarFloatPersistente(oPC, "IND_ALTURA", fAltura);
            SendMessageToPC(oPC, "<c´$$>Se ha ajustado tu altura al mínimo de tu raza.</c>");
        }
        SetObjectVisualTransform(oPC, OBJECT_VISUAL_TRANSFORM_SCALE, fAltura);
    }
    // Con el cambio de altura del ingeniero, por si caso, aquellos PJs que no tienen seteada ninguna altura, los ponemos a 1.0.
    if (ObtenerIntPersistente(oPC, "CAB_ALTURA")==FALSE)
    {
        SetObjectVisualTransform(oPC, OBJECT_VISUAL_TRANSFORM_SCALE, 1.0);
    }

    // REAJUSTE FACCIONES IMPORTANTES
    ExecuteScript("facciones",OBJECT_SELF);

    // ELIMINAR VARIABLES DEL PUESTO DE VENTA
    DelayCommand(1.0f, EliminarVariablesTJ(oPC));

    // RESTAURAR VIDA PERSISTENTE
    string sNombrePJ=GetName(oPC)+ GetPCPlayerName(oPC);
    int iVidaActual = GetCampaignInt(ObjectToString(GetModule()), sNombrePJ);
    if(iVidaActual != 0)
    {
        RemoveEffectOfType(oPC, EFFECT_TYPE_POLYMORPH);
        int iVidaMaxima = GetMaxHitPoints(oPC);
        int iDanyo;
        if(iVidaActual >= iVidaMaxima) { SetCurrentHitPoints(oPC, iVidaMaxima);}
        else { iDanyo = iVidaMaxima-iVidaActual;}
        if (iDanyo !=0){ ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDanyo), oPC);}
    }


    // SISTEMA DE MUERTE: Destruir todos los cadaveres del inventario (si tuviera)
    object oCadaver = GetFirstItemInInventory(oPC);
    while(GetIsObjectValid(oCadaver) == TRUE)
    {
        if(GetStringLeft(GetTag(oCadaver), 10) == "pg_cadaver") DestroyObject(oCadaver);

        oCadaver = GetNextItemInInventory(oPC);
    }

    // ARQUERO ARCANO: ELIMINAR FLECHAS IMBUIDAS
    if(GetHasFeat(FEAT_PRESTIGE_IMBUE_ARROW, oPC) == TRUE) ExecuteScript("aa_m_cliententer", OBJECT_SELF);

    // Variables que se resetean al reentrar
    if(GetLocalInt(oPC, "FASCINADO")) DeleteLocalInt(oPC, "FASCINADO");
    if(GetLocalInt(oPC, "NOFASCINADO")) DeleteLocalInt(oPC, "NOFASCINADO");

    // Garras y mordiscos Discipulo del dragon
    object oDDGarras1  = GetItemPossessedBy(oPC, "dradis_garras1");
    object oDDGarras2  = GetItemPossessedBy(oPC, "dradis_garras2");
    object oDDMordisco = GetItemPossessedBy(oPC, "dradis_mordisco");

    if(GetHasFeat(1341, oPC))
    {
        // Si se tiene la dote y NO se tienen las garras, se crean y se equipan
        if(!GetIsObjectValid(oDDGarras1))
        {
            object oDDGarras1  = CreateItemOnObject("nw_it_crewpsp005", oPC, 1, "dradis_garras1");
            object oDDGarras2  = CreateItemOnObject("nw_it_crewpsp005", oPC, 1, "dradis_garras2");
            object oDDMordisco = CreateItemOnObject("nw_it_crewps002", oPC, 1, "dradis_mordisco");
            SetIdentified(oDDGarras1, TRUE);
            SetIdentified(oDDGarras2, TRUE);
            SetIdentified(oDDMordisco, TRUE);
            SetItemCursedFlag(oDDGarras1, TRUE);
            SetItemCursedFlag(oDDGarras2, TRUE);
            SetItemCursedFlag(oDDMordisco, TRUE);
            SetPlotFlag(oDDGarras1, TRUE);
            SetPlotFlag(oDDGarras2, TRUE);
            SetPlotFlag(oDDMordisco, TRUE);
            SetName(oDDGarras1, "<cÈª`>Garras dracónicas</c>");
            SetName(oDDGarras2, "<cÈª`>Garras dracónicas</c>");
            SetName(oDDMordisco, "<cÈª`>Mordisco dracónico</c>");
            SetDescription(oDDGarras1, "<cÈª`>Este objeto son tus 'garras' de discípulo de dragón, si se te desequipara por error puedes equipártelo fácilmente moviéndolo a un acceso directo y haciendo Click izquierdo sobre él.</c>");
            SetDescription(oDDGarras2, "<cÈª`>Este objeto son tus 'garras' de discípulo de dragón, si se te desequipara por error puedes equipártelo fácilmente moviéndolo a un acceso directo y haciendo Click izquierdo sobre él.</c>");
            SetDescription(oDDMordisco, "<cÈª`>Este objeto es tu 'mordisco' de discípulo de dragón, si se te desequipara por error puedes equipártelo fácilmente moviéndolo a un acceso directo y haciendo Click izquierdo sobre él.</c>");
            AssignCommand(oPC, ClearAllActions());
            AssignCommand(oPC, ActionEquipItem(oDDGarras1, INVENTORY_SLOT_CWEAPON_L));
            AssignCommand(oPC, ActionEquipItem(oDDGarras2, INVENTORY_SLOT_CWEAPON_R));
            AssignCommand(oPC, ActionEquipItem(oDDMordisco, INVENTORY_SLOT_CWEAPON_B));
            SendMessageToPC(oPC, "Se te han creado y equipado las garras de DDR");
        }
        // Si se tiene la dote y garras pero no estan equipadas, se equipan
        else if(GetIsObjectValid(oDDGarras1) && (GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC) == OBJECT_INVALID ||
            GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC) == OBJECT_INVALID ||
            GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC) == OBJECT_INVALID))
        {
            AssignCommand(oPC, ClearAllActions());
            AssignCommand(oPC, ActionEquipItem(oDDGarras1, INVENTORY_SLOT_CWEAPON_L));
            AssignCommand(oPC, ActionEquipItem(oDDGarras2, INVENTORY_SLOT_CWEAPON_R));
            AssignCommand(oPC, ActionEquipItem(oDDMordisco, INVENTORY_SLOT_CWEAPON_B));
            SendMessageToPC(oPC, "Se te han equipado las garras de DDR.");
        }

    }
    // Si no se tiene la dote y SI se tiene las garras, se eliminan (p.e. bajar de nivel y subir en otra cosa)
    else if(GetIsObjectValid(oDDGarras1) || GetIsObjectValid(oDDGarras2) || GetIsObjectValid(oDDMordisco))
    {
        SetPlotFlag(oDDGarras1, FALSE);
        SetPlotFlag(oDDGarras2, FALSE);
        SetPlotFlag(oDDMordisco, FALSE);
        DestroyObject(oDDGarras1, 0.5);
        DestroyObject(oDDGarras2, 0.5);
        DestroyObject(oDDMordisco, 0.5);
        SendMessageToPC(oPC, "Se te han eliminado las garras de DDR.");
    }

    //Correccion de efectos visual transform
    SetObjectVisualTransform(oPC, OBJECT_VISUAL_TRANSFORM_ROTATE_X, 0.0);
    SetObjectVisualTransform(oPC, OBJECT_VISUAL_TRANSFORM_ROTATE_Y, 0.0);
    SetObjectVisualTransform(oPC, OBJECT_VISUAL_TRANSFORM_ROTATE_Z, 0.0);
    SetObjectVisualTransform(oPC, OBJECT_VISUAL_TRANSFORM_TRANSLATE_Z, 0.0);
    SetObjectVisualTransform(oPC, OBJECT_VISUAL_TRANSFORM_TRANSLATE_Y, 0.0);
    SetObjectVisualTransform(oPC, OBJECT_VISUAL_TRANSFORM_TRANSLATE_X, 0.0);

    // PERSISTENCIA EN CIERTOS LUGARES DEL SERVIDOR
    int iTorre = GetLocalInt(oPC, "NIVELTORRE");
    int iThor1 = GetLocalInt(oPC, "ESTOYENTHORMALLEM");
    int iThor2 = GetLocalInt(oPC, "ESTOYENTHORMALLEM2");
    int iZapSune = GetLocalInt(oPC, "ESTOYENZAPSUNE");

    if(iTorre > 0 || iThor1 > 0 || iThor2 > 0 || iZapSune > 0) ExecuteScript("persist_lug_serv", OBJECT_SELF);

    string sSubRace = GetStringLowerCase(GetSubRace(oPC));
    // REAPLICAR EFECTOS PB
    if (sSubRace != "")
    {
        // SUBRAZAS VAMPIRO Y ENGENDRO VAMPÍRICO: utiliza un sistema de entrada especial (Tiene que ver con las propiedades del sarcófago y la asignación del jugador como un vampiro.)
        if(GetIsPC(oPC) == TRUE && UseSubRaceField && (sSubRace == "vampiro" || sSubRace == "engendro"))
        {
            Vampire_Client_Enter(oPC);
        }
    }

    // Tamaño gigante
    if(GetIsPC(oPC) == TRUE && GetRacialType(oPC) == RACIAL_TYPE_GIANT) NWNX_Creature_SetSize(oPC, 4);

    // Fuego Arcano
    if (GetHasFeat(1431, oPC)) SetLocalInt(oPC, "arcane_fire_active", 0);

    //Reajustamos los efectos sobrenaturales
    SetLocalInt(oPC, "PJ_SALIO",0);
    ReaplicarEfectosPB(oPC, TRUE);

    //Añadimos a todos los jugadores el item de disfraz
    object oDisfraz = GetItemPossessedBy(oPC, "item_disfraz");
    if(GetIsObjectValid(oDisfraz) != TRUE) CreateItemOnObject("item_disfraz", oPC);

    //Borramos variable de nomuertos
    if(GetLocalInt(oPC, "UNDEADDG") > 0 ) SetLocalInt(oPC, "UNDEADDG", 0);

    // SISTEMA DE EFECTOS PERSISTENTES
    LoadAllDMVFX(oPC);

    //SISTEMA DE MENSAJES DE ENTRADA Y SALIDA PARA QUE LA GENTE VEA SI ENTRAS O SALES.
    MensajeEntradaoSalida (oPC, 1);

    //SISTEMAS QUE HACE RETURN Y CANCELAN EL SCRIPT.

    // SEGURIDAD PJ: VERIFICACION TRANSPARENTE DE CDKEY
    string sCDKeyActual = GetPCPublicCDKey(oPC);
    string sCDKeyMemorizada = ObtenerStringPersistente(oPC, "CDKEY");

    // Si no tiene CDKey guardada, guardar la actual (primer acceso)
    if(sCDKeyMemorizada == "")
    {
        GuardarStringPersistente(oPC, "CDKEY", sCDKeyActual);
        WriteTimestampedLogEntry("[SEGURIDAD] CDKey registrada para PJ: " + GetName(oPC, TRUE) + " (Jugador: " + GetPCPlayerName(oPC) + ")");
    }
    // Si CDKey no coincide -> BLOQUEAR PERSONAJE
    else if(sCDKeyMemorizada != sCDKeyActual)
    {
        WriteTimestampedLogEntry("[SEGURIDAD ALERTA] Intento de acceso con CDKey incorrecta! PJ: " + GetName(oPC, TRUE) + " | Jugador: " + GetPCPlayerName(oPC) + " | CDKey esperada: " + sCDKeyMemorizada + " | CDKey recibida: " + sCDKeyActual);

        // Marcar como bloqueado
        SetLocalInt(oPC, "SEG_BLOQUEADO", TRUE);

        // Bloqueo TOTAL sin ocultar UI
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectCutsceneParalyze(), oPC);
        SetCommandable(FALSE, oPC);
        AssignCommand(oPC, ClearAllActions(TRUE));

        // Opcional: bloquear inventario y hoja de personaje (NWN:EE)
        SetGuiPanelDisabled(oPC, GUI_PANEL_INVENTORY, TRUE);

        // Mensajes al jugador (en rojo)
        SendMessageToPC(oPC, StringToRGBString("-------------------------------------", "700"));
        SendMessageToPC(oPC, StringToRGBString("ACCESO DENEGADO - PERSONAJE BLOQUEADO", "700"));
        SendMessageToPC(oPC, StringToRGBString("-------------------------------------", "700"));
        SendMessageToPC(oPC, StringToRGBString("Este personaje ha sido bloqueado por el sistema de seguridad.", "770"));
        SendMessageToPC(oPC, StringToRGBString("Puedes usar el chat para contactar con los DMs.", "770"));
        SendMessageToPC(oPC, StringToRGBString("-------------------------------------", "700"));

        // Alertar a todos los DMs conectados
        SendMessageToAllDMs(StringToRGBString("[SEGURIDAD] Intento de acceso no autorizado detectado!", "700"));
        SendMessageToAllDMs(StringToRGBString("[SEGURIDAD] Personaje: " + GetName(oPC, TRUE) + " | Jugador: " + GetPCPlayerName(oPC), "770"));
        SendMessageToAllDMs(StringToRGBString("[SEGURIDAD] El personaje ha sido BLOQUEADO automaticamente.", "770"));

        return;
    }
    /*
    // SEGURIDAD PJ: CONTRASENYAS
    string sCDKeyMemorizada = ObtenerStringPersistente(oPC, "CDKEY");
    if(sCDKeyMemorizada != GetPCPublicCDKey(oPC))
    {
        if(GetCurrentHitPoints(oPC) < 1)
        {
            SetLocalInt(oPC, "SEG_RESUCITADO", TRUE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPC);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(oPC)), oPC);
        }

        SetLocalInt(oPC, "SEG_OCUPADO", TRUE);
        FadeToBlack(oPC);
        SetCutsceneMode(oPC, TRUE);
        DelayCommand(15.0, AssignCommand(oPC, ActionStartConversation(oPC, "seg", TRUE)));
        DelayCommand(15.0, FadeFromBlack(oPC));
        return;
    } */

    // SEGURIDAD PJ: BANEADO HASTA EL PROXIMO REINICIO
    if(GetLocalInt(oMod, "SEG_BANCDKEY_" + GetPCPublicCDKey(oPC)) || GetLocalInt(oMod, "SEG_BANIP_" + GetPCIPAddress(oPC)))
    {
        FadeToBlack(oPC);
        SetCutsceneMode(oPC, TRUE);
        DelayCommand(15.0f, BootPC(oPC));
        return;
    }

    // SUBRAZAS: APLICAR AJUSTES INICIALES
    int nRacialType = GetRacialType(oPC);
    int bAppearanceSelector = StringToInt(Get2DAString("racialtypes", "AppearanceSelector", nRacialType));

    if(ObtenerIntPersistente(oPC, "LETO_APLICADO") == FALSE && (sSubRace != "" || bAppearanceSelector))
    {
        FadeToBlack(oPC);
        SetCutsceneMode(oPC, TRUE);
        DelayCommand(5.0, AssignCommand(oPC, ActionStartConversation(oPC, "ms_convgeneral", TRUE)));
        DelayCommand(5.0, FadeFromBlack(oPC));
        // ReaplicarEfectosPB(oPC, TRUE);
        return;
    }

    // FEY'RI: SELECCIÓN APTITUDES DEMONÍACAS
    if(nRacialType == RACIAL_TYPE_FEYRI && ObtenerIntPersistente(oPC, "FEYRI_APTDEM") == FALSE)
    {
        FadeToBlack(oPC);
        SetCutsceneMode(oPC, TRUE);
        DelayCommand(5.0, AssignCommand(oPC, ActionStartConversation(oPC, "ms_conv_feyri", TRUE)));
        DelayCommand(5.0, FadeFromBlack(oPC));
        return;
    }

    //Añadimos dotes nuevas semielfo si el jugador no las tiene
    if(nRacialType == RACIAL_TYPE_HALFELF) {
        int bHasHalfElfFeats = NWNX_Creature_GetKnowsFeat(oPC, FEAT_SKILL_AFFINITY_GATHER_INFORMATION);

        if (!bHasHalfElfFeats) {
            NWNX_Creature_AddFeat(oPC, FEAT_SKILL_AFFINITY_GATHER_INFORMATION);
            NWNX_Creature_AddFeat(oPC, FEAT_SKILL_AFFINITY_PERSUADE);
            SendMessageToPC(oPC, "Tus dotes raciales han sido ajustadas.");
        }
    }

    // DRACÓNIDO: SELECCIÓN DE LINAJE.
    if(nRacialType == RACIAL_TYPE_DRACONIDO && ObtenerIntPersistente(oPC, "DRACONIDO_LINAJE") == FALSE)
    {
        FadeToBlack(oPC);
        SetCutsceneMode(oPC, TRUE);
        DelayCommand(5.0, AssignCommand(oPC, ActionStartConversation(oPC, "ms_conv_draco", TRUE)));
        DelayCommand(5.0, FadeFromBlack(oPC));
        return;
    }

    // Remove stuck darkness effects if not inside a darkness AoE
    RemoveStuckDarknessEffects(oPC);
}
