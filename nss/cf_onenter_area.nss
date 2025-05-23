#include "slb_inc"
#include "sgea_inc"
#include "sistemas_ro_cfg"
#include "nbde_inc"
#include "x2_inc_toollib"

void CrearObjeto(string sResRef, location lLugar, string sTag)
{
object oObjeto = CreateObject(OBJECT_TYPE_CREATURE, sResRef, lLugar, FALSE, sTag);
SetLocalInt(oObjeto, "SEGC_CriaturaSistema", 1);
}

void TS_VerifTS(object oPlayer, object oArea)
{
if(GetLocalInt(oArea, "TS_TiempoParado") == 1)
    {
    AssignCommand(GetModule(),ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectCutsceneParalyze(),oPlayer,1.0));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION),oPlayer,1.0);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectVisualEffect(VFX_DUR_GLOW_WHITE),oPlayer,1.0);
    DelayCommand(1.0, TS_VerifTS(oPlayer, oArea));
    }
else return;
}

void main()
{
object oPlayer = GetEnteringObject();
object oArea = GetArea(oPlayer);
object oManoIzquierda = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPlayer);
object oManoDerecha = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPlayer);
int iHabilitarLog = 0;

//if(!GetIsPC(oPlayer)) return; //evitamos ejecuciones inecesarias del script

if(iHabilitarLog == 1) //Mensajes especiales
    {
    SendMessageToAllDMs("Nombre objeto entrante en area: " + GetName(oPlayer));
    if(GetObjectType(oPlayer) == OBJECT_TYPE_CREATURE) SendMessageToAllDMs("Entrando una criatura en el area");
    if(GetObjectType(oPlayer) == OBJECT_TYPE_PLACEABLE) SendMessageToAllDMs("Entrando un ubicado en el area");
    }

//Sistema de limpieza de basura
if(GetLocalInt(oArea, "SLB_HAB") == 1) SLB_LimpiarSuelo(oArea);

//Sistema generador de encuentros aleatorios
if(GetLocalInt(oArea, "SGEA_HAB") == 1) SGEA_GenerarEncuentro(oPlayer);

//Zona de Arena
if(GetLocalInt(oArea, "ARENA_HAB") == 1)
    {
    SetLocalInt(oPlayer,"arena", TRUE);
    SendMessageToPC(oPlayer,"Estas ahora en el modo Arena. Se aplican reglas especiales en el caso de muerte.");
    }

//Sistema automatico de Acceso al Mundo
//Guarda dato cuando el Pj accede por primera vez a un area
if(GetLocalInt(oArea, "SAM_HAB") == 1)
    {
    if(GetCampaignInt(BD_SPER, GetTag(oArea), oPlayer) == 1)
        {
        //No hacer nada
        }
    else SetCampaignInt(BD_SPER, GetTag(oArea), 1, oPlayer);
    }

//Sistema de muerte del Plano de la Fuga
if(GetLocalInt(oArea, "PF_AREADEENTRADA") == 1)
    {
    if(GetIsPC(oPlayer) && !GetIsDM(oPlayer))
    {
        //if(GetCampaignInt(BD_SPER, "PF_APP_ORG_GUARDADA", oPlayer) == 0)
            //{
            //SetCampaignInt(BD_SPER, "PF_APP_ORIGINAL", GetAppearanceType(oPlayer), oPlayer);
            //SetCampaignInt(BD_SPER, "PF_APP_ORG_GUARDADA", 1, oPlayer);
            //}
        //ADDED: Para el sistema de conflictos no cambia apariencia del pj
        string sBando = GetCampaignString("CCD_DB", "CCD_BANDO", oPlayer);
        if(GetCampaignInt(BD_SPER, "PF_APP_CAMBIADA", oPlayer) == 1 || sBando != "")
            {
            }
        else
            {
            DelayCommand(2.0, SetCreatureAppearanceType(oPlayer, 186));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_CELESTIAL), oPlayer);
            SetCampaignInt(BD_SPER, "PF_APP_CAMBIADA", 1, oPlayer);
            DelayCommand(3.0, AssignCommand(oPlayer, ActionUnequipItem (oManoIzquierda)));
            DelayCommand(3.5, AssignCommand(oPlayer, ActionUnequipItem (oManoDerecha)));
            }
        }
    }

//Sistema automatico de guardado de localizacion
if(GetLocalInt(oArea, "SAGL_DESHAB") == 0)
    {
    NBDE_SetCampaignLocation(NBDE_SGPER, "SAGL_PUNTOSEGURO", GetLocation(oPlayer), oPlayer);
    //DelayCommand(1.0, NBDE_FlushCampaignDatabase(NBDE_SGPER));
    }

//Revelar todo el mapa
if(GetLocalString(oArea, "CF_OBJTAG_REVMAP") != "")
    {
    string sTagObjRevMap = GetLocalString(oArea, "CF_OBJTAG_REVMAP");
    if (GetIsObjectValid(oPlayer) && GetIsPC(oPlayer) && GetHasInventory(oPlayer))
        {
        if(GetItemPossessedBy(oPlayer, sTagObjRevMap) != OBJECT_INVALID)
            ExploreAreaForPlayer(GetArea(oArea), oPlayer);
        }
    }

//Activar efecto de teleportacion al entrar un pj en el area teleportandose
if(GetLocalInt(oPlayer, "CF_TELEPORT") == 1)
    {
    DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_2), oPlayer));
    SetLocalInt(oPlayer, "CF_TELEPORT", 0);
    }

//Modificacion de tiles
if(GetLocalInt(oArea, "SMT_HAB") == 1 && !GetLocalInt(oArea, "SMT_HECHO"))
    {
    int iTile = GetLocalInt(oArea, "SMT_TILE");
    float sOffset = GetLocalFloat(oArea, "SMT_OFFSET");
    TLChangeAreaGroundTilesEx(oArea, iTile, sOffset);
    SetLocalInt(oArea,"SMT_HECHO",1);
    }

//sistema estatico de generacion de criaturas, los pnjs no aparecen hasta que no entra un jugador en el area
if(GetLocalInt(oArea, "SEGC_HAB") == 1 && !GetLocalInt(oArea, "SEGC_HECHO") && GetIsPC(oPlayer))
    {
    object oWP = GetFirstObjectInArea(oArea);
    string sTagWP;
    string sTagPNJ;
    while(GetIsObjectValid(oWP))
        {
        sTagWP = GetTag(oWP);
        sTagPNJ = GetStringRight(sTagWP, GetStringLength(sTagWP)-5);
        if(GetObjectType(oWP) == OBJECT_TYPE_WAYPOINT && GetStringLeft(sTagWP, 4) == "SEGC")
            {
            //SendMessageToAllDMs(sTagWP + " " + sTagPNJ);
            DelayCommand(3.0, CrearObjeto(GetName(oWP), GetLocation(oWP), sTagPNJ));
            //DestroyObject(oWP);
            }
        oWP = GetNextObjectInArea(oArea);
        }
    SetLocalInt(oArea,"SEGC_HECHO",1);
    }

//Parar el tiempo activo en el area
if(GetLocalInt(oArea, "TS_TiempoParado") == 1)
    {
    AssignCommand(GetModule(),ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectCutsceneParalyze(),oPlayer,1.0));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION),oPlayer,1.0);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectVisualEffect(VFX_DUR_GLOW_WHITE),oPlayer,1.0);
    DelayCommand(1.0, TS_VerifTS(oPlayer, oArea));
    }
}
