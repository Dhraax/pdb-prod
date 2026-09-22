//::////////////////////////////////////////////////////////////////////////:://
//::/  WRAPPER ONMODULELOAD  ///////////////////////////////////////////////:://
//::////////////////////////////////////////////////////////////////////////:://
#include "x2_inc_switches"
#include "hc_inc_htf"
#include "nwnx_chat"
#include "mti_libreria"
#include "meteo_library"
#include "inc_sqlite_time"
#include "pb_fecha_inc"
#include "nwnx_events"
#include "nwnx_damage"
#include "setup_feats"
#include "lib_race"
#include "nwnx_admin"


void main()
{

    // PLUGIN CHAT
    //dmb_ChatInit();
    NWNX_Chat_SendMessage(NWNX_CHAT_CHANNEL_SERVER_MSG, "Servidor Operativo. Bienvenidos a Puerta de Baldur Enchanted Edition.", OBJECT_SELF, GetModule());
    NWNX_Chat_RegisterChatScript("pb_chat");

    // AYUDANTES MAXIMOS
    SetMaxHenchmen(4);

    //Creamos una BDD para guardar Henchman
    SetLocalString(GetModule(), "X0_CAMPAIGN_DB", "Henchmen");


    // Execute the default script and set the HTF area variables.
    ExecuteScript("hc_defaults", oMod);

    // Ejecuta el sistema de guardado persistente en ubicados
    ExecuteScript("enc_mcs_load", OBJECT_SELF);

    // VARIABLES DE AREAS
    TurnOffAreaConsumeRates(GetObjectByTag("plano_fuga"));

    SetModuleSwitch(MODULE_SWITCH_AOE_HURT_NEUTRAL_NPCS, TRUE);
    SetModuleSwitch (MODULE_SWITCH_ENABLE_UMD_SCROLLS, TRUE);
    SetModuleSwitch(MODULE_SWITCH_ENABLE_CROSSAREA_WALKWAYPOINTS, TRUE);

    /*/Inicializar la estación del año del servidor
    int iUnixTime = NWNX_Time_GetTimeStamp(); //StringToInt(NWNX_Time_GetSystemDate()) + StringToInt(NWNX_Time_GetSystemTime());
    int iAjusteHorario = 7200;
    if(GetCampaignInt("AJUSTEHORARIO", "AJUSTEHORARIO", GetModule()) == TRUE) iAjusteHorario = 3600;
    string sFecha;
    sFecha = GetFechaCreacion(iUnixTime,iAjusteHorario);
    string sMes = GetSubString(sFecha, 3, 2);
    SendMessageToAllDMs ("Sistema Meteologico, Mes: " + sMes);
    switch (StringToInt(sMes))
    {
        case 1:
        case 5:
        case 9: SetLocalString(oMod, "ESTACION", "INVIERNO"); break;
        case 2:
        case 6:
        case 10: SetLocalString(oMod, "ESTACION", "PRIMAVERA"); break;
        case 3:
        case 7:
        case 11: SetLocalString(oMod, "ESTACION", "VERANO"); break;
        case 4:
        case 8:
        case 12: SetLocalString(oMod, "ESTACION", "OTOÑO"); break;
        default:  SetLocalString(oMod, "ESTACION", "VERANO"); break;
    }  */

    //Determinar el Clima de las Areas según Zona geográfica.
    Indicar_ClimaAreas();

    //Inicializar la limpieza de las tiendas.
    SetLocalInt(GetModule(), "Limpieza", 0);

    // Vincular eventos de NWNX a sus correspondientes scripts
    NWNX_Events_SubscribeEvent("NWNX_ON_STORE_REQUEST_SELL_BEFORE", "cnr_ev_sell");
    NWNX_Events_SubscribeEvent("NWNX_ON_STEALTH_ENTER_BEFORE", "event_stealth");
    NWNX_Events_SubscribeEvent("NWNX_ON_STEALTH_EXIT_AFTER", "event_stealth");
    NWNX_Events_SubscribeEvent("NWNX_ON_POLYMORPH_BEFORE", "event_polymorph");
    NWNX_Events_SubscribeEvent("NWNX_ON_UNPOLYMORPH_BEFORE", "event_polymorph");
    NWNX_Events_SubscribeEvent("NWNX_ON_UNPOLYMORPH_AFTER", "event_polymorph");
    NWNX_Events_SubscribeEvent("NWNX_ON_USE_SKILL_BEFORE", "event_skills");
    NWNX_Events_SubscribeEvent("NWNX_ON_INPUT_CAST_SPELL_BEFORE", "event_castspell");
    NWNX_Events_SubscribeEvent("NWNX_ON_SPELL_INTERRUPTED_AFTER", "event_interrspell");
    NWNX_Events_SubscribeEvent("NWNX_ON_SPELL_FAILED_AFTER", "event_failspell");
    NWNX_Events_SubscribeEvent("NWNX_ON_EFFECT_REMOVED_AFTER", "event_effects");
    NWNX_Events_SubscribeEvent("NWNX_ON_USE_FEAT_BEFORE", "event_feat");
    NWNX_Events_SubscribeEvent("NWNX_ON_USE_FEAT_AFTER", "event_feat");
    NWNX_Events_SubscribeEvent("NWNX_ON_DM_POSSESS_AFTER", "event_dmposs");
    NWNX_Events_SubscribeEvent("NWNX_ON_DM_POSSESS_FULL_POWER_AFTER", "event_dmposs");
    NWNX_Events_SubscribeEvent("NWNX_ON_DM_SPAWN_OBJECT_AFTER", "event_spawnitem");
    NWNX_Events_SubscribeEvent("NWNX_ON_DM_GIVE_ITEM_AFTER", "event_dmgive");
    NWNX_Events_SubscribeEvent("NWNX_ON_LEVEL_DOWN_AFTER", "event_leveldown");
    NWNX_Events_SubscribeEvent("NWNX_ON_CAST_SPELL_BEFORE", "event_castbefore");
    NWNX_Events_SubscribeEvent("NWNX_ON_CAST_SPELL_AFTER", "event_castafter");
    //NWNX_Events_SubscribeEvent("NWNX_ON_HAS_FEAT_BEFORE", "event_has_feat");
    //NWNX_Events_AddIDToWhitelist("NWNX_ON_HAS_FEAT", FEAT_MOMF_PREREQ);

    //Maestro Multiples formas
    NWNX_Events_SubscribeEvent("NWNX_ON_CLIENT_DISCONNECT_BEFORE","pb_mmf_eb_ex_cs");
    NWNX_Events_SubscribeEvent("NWNX_ON_SERVER_CHARACTER_SAVE_BEFORE","pb_mmf_eb_ex_cs");
    NWNX_Events_SubscribeEvent("NWNX_ON_CLIENT_LEVEL_UP_BEGIN_BEFORE","pb_mmf_eb_lvl_bl");
    NWNX_Events_SubscribeEvent("NWNX_ON_ITEM_EQUIP_BEFORE","pb_mmf_eb_eq_it");
    NWNX_Events_SubscribeEvent("NWNX_ON_ITEM_UNEQUIP_BEFORE","pb_mmf_eb_eq_it");

    NWNX_Damage_SetAttackEventScript("event_attack");

    // Iniciar la configuración de dotes con bonos pasivos vía NWNX
    SetupFeats();
    SetupSkillFeats();

    // Iniciar la configuración de razas vía NWNX
    PB_Race_SetupRaces();

    //Los jugadores no dejan mensaje de conexión.
    NWNX_Administration_SetPlayOption(NWNX_ADMINISTRATION_OPTION_SHOW_PLAYER_JOIN_MESSAGES, FALSE);
    NWNX_Administration_SetPlayOption(NWNX_ADMINISTRATION_OPTION_SHOW_DM_JOIN_MESSAGE, FALSE);

    //Script de gestión de eventos "GUI", usado por ejemplo para las burbujas del chat.
    SetEventScript( GetModule(), EVENT_SCRIPT_MODULE_ON_PLAYER_GUIEVENT,"event_guimod" );

    // CNR: initialize the legacy resource registries used by the retained
    // harvesting and recipe compatibility layer.
    ExecuteScript("cnr_module_oml", OBJECT_SELF);
}
