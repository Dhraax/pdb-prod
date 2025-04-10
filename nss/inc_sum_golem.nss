#include "x0_i0_position"
#include "mti_libreria"
#include "nwnx_creature"
#include "pb_nivellanzador"

/////////////////////////////////////////////
/////////                        ////////////
/////////      CONSTANTES        ////////////
/////////                        ////////////
/////////////////////////////////////////////


///////////////////////////////////////////////////////////////
////////       INICIO OPCIONES DINAMICAS       ////////////////
////////   --------------------------------    ////////////////
////////   Modificar los siguientes valores    ////////////////
////////        al gusto del usuario.          ////////////////
///////////////////////////////////////////////////////////////


//Golem blueprint para usar en la función CreateObject
const string GOLEM_RESREF_FLESH = "golem_inv_shi003";
const string GOLEM_RESREF_CLAY = "golem_inv_shi002";
const string GOLEM_RESREF_STONE = "golem_inv_shi001";
const string GOLEM_RESREF_IRON = "golem_inv_mit001";
const string GOLEM_RESREF_MITHRIL = "golem_inv_mithri";
const string GOLEM_RESREF_SHIELD = "golem_inv_shield";
const string GOLEM_RESREF_HOMUNCULUS = "golem_inv_shi004";

//Mensajes al jugador cuando intentar activar un golem cuando ya se tiene uno activo o este ha sido destruido.
const string GOLEM_MSG_ALREADY_ACTIVE = "Ya tienes un constructo activo ahora mismo. No puedes utilizar otro.";
const string GOLEM_MSG_PREVIOUS_ACTIVE = "Tenías otro constructo activo. No puedes utilizar otro.";
const string GOLEM_MSG_DESTROYED = "Este constructo ha sido destruido, necesitas encontrar un lugar donde repararlo.";
const string GOLEM_MSG_IN_COMBAT = "No puedes usar esto en combate.";

//Multiplicador de precio según tipo. Usado en la reparación de golems.
const int GOLEM_PRICE_REPAIR_HOMUNCULUS = 2;
const int GOLEM_PRICE_REPAIR_FLESH = 4;
const int GOLEM_PRICE_REPAIR_CLAY = 8;
const int GOLEM_PRICE_REPAIR_STONE = 16;
const int GOLEM_PRICE_REPAIR_IRON = 32;
const int GOLEM_PRICE_REPAIR_SHIELD = 64;
const int GOLEM_PRICE_REPAIR_MITHRIL = 128;

//Valor de la reparación del golem cuando este ha muerto.
const int GOLEM_PRICE_REVIVE_HOMUNCULUS = 1000;
const int GOLEM_PRICE_REVIVE_FLESH = 2000;
const int GOLEM_PRICE_REVIVE_CLAY = 3000;
const int GOLEM_PRICE_REVIVE_STONE = 4000;
const int GOLEM_PRICE_REVIVE_IRON = 5000;
const int GOLEM_PRICE_REVIVE_SHIELD = 6000;
const int GOLEM_PRICE_REVIVE_MITHRIL = 7000;

//Constantes reflejando el nombre de los eventos de criatura. Se usan al activar el golem ya que usa criaturas hostiles.
const string GOLEM_EVENT_ON_HEARBEAT = "on_hb_golem";
const string GOLEM_EVENT_ON_HEARBEAT_ASSOCIATE = "nw_ch_ac1";
const string GOLEM_EVENT_ON_PERCEPTION = "nw_ch_ac2";
const string GOLEM_EVENT_ON_SPELLCASTAT = "nw_ch_acb";
const string GOLEM_EVENT_ON_DAMAGED = "nw_ch_ac5";
//Este script posee scripts especificos para el golem, si se quiere modificar este directamente
//o ejecutarlo desde el script personalizado.
const string GOLEM_EVENT_ON_DEATH = "on_death_golem";
const string GOLEM_EVENT_ON_DISTURBED = "nw_ch_ac8";
const string GOLEM_EVENT_ON_BLOCKED = "nw_ch_ace";
const string GOLEM_EVENT_ON_USERDEFINED = "nw_ch_acd";
const string GOLEM_EVENT_ON_END_COMBATROUND = "nw_ch_ac3";
const string GOLEM_EVENT_ON_SPAWN = "nw_ch_ac9";
const string GOLEM_EVENT_ON_CONVERSATION = "nw_ch_ac4";

////////////////////////////////////////////////////////////
///////////////// FIN OPCIONES DINAMICAS ///////////////////
////////////////////////////////////////////////////////////


//Tags de los objetos que se usan para activar el golem.
const string GOLEM_ITEM_TAG_FLESH = "pb_gs_flesh";
const string GOLEM_ITEM_TAG_CLAY = "pb_gs_clay";
const string GOLEM_ITEM_TAG_STONE = "pb_gs_stone";
const string GOLEM_ITEM_TAG_IRON = "pb_gs_iron";
const string GOLEM_ITEM_TAG_MITHRIL = "pb_gs_mithril";
const string GOLEM_ITEM_TAG_SHIELD = "pb_gs_shield";
const string GOLEM_ITEM_TAG_HOMUNCULUS = "pb_gs_homunculus";

//Golem tags
const string GOLEM_TAG_FLESH = "golem_flesh";
const string GOLEM_TAG_CLAY = "golem_clay";
const string GOLEM_TAG_STONE = "golem_stone";
const string GOLEM_TAG_IRON = "golem_iron";
const string GOLEM_TAG_MITHRIL = "golem_mithril";
const string GOLEM_TAG_SHIELD = "golem_shield";
const string GOLEM_TAG_HOMUNCULUS = "golem_homunculus";

//Variables permanentes hechas como constantes para facil modificación.
const string GOLEM_VAR_NAME_HP = "PLAYER_GOLEM_HP";
const string GOLEM_VAR_NAME_TAG = "PLAYER_GOLEM_ACTIVE_TAG";
const string GOLEM_VAR_NAME_REPAIR_PRICE = "GOLEM_REPAIR_PRICE";
const string GOLEM_VAR_NAME_DEAD_FLESH = "DEAD_FLESH";
const string GOLEM_VAR_NAME_DEAD_CLAY = "DEAD_CLAY";
const string GOLEM_VAR_NAME_DEAD_STONE = "DEAD_STONE";
const string GOLEM_VAR_NAME_DEAD_IRON = "DEAD_IRON";
const string GOLEM_VAR_NAME_DEAD_MITHRIL = "DEAD_MITHRIL";
const string GOLEM_VAR_NAME_DEAD_SHIELD = "DEAD_SHIELD";
const string GOLEM_VAR_NAME_DEAD_HOMUNCULUS = "DEAD_HOMUNCULUS";

///////////////////////////////////////////////////////
/////////                                  ////////////
/////////      DEFINICION FUNCIONES        ////////////
/////////                                  ////////////
///////////////////////////////////////////////////////

//Devuelve TRUE si el objeto activado es de control de golems.
int CheckGolemItemActivatedByTag(string sItem);

//Devuelve TRUE si el personaje tiene un golem activo.
int CheckGolemActive(object oPC);

//Devuelve TRUE si el golem que se intenta invocar ha sido destruidor anteriormente.
int CheckIfGolemWasDestroyed(string sTag, object oPC);

//Devuelve el golem actualmente activo del jugador oPC. OBJECT_INVALID si no tiene ninguno activo.
object GetActiveGolemFromPlayer(object oPC);

//Elimina todos los objetos y el oro del golem.
void CleanGolemIventary(object oGolem);

//Invoca un golem en el flanco posterior izquierdo del jugador. Si el jugador ya tiene uno activo
//se le enviará un mensaje recordándoselo.
void CreateGolem(string sTag,object oPC);

//Devuelve el preció que tendrá la reparación del constructo según su tipo y vida faltante.
// 0 si ha habido algún error.
int GetRepairPriceByGolemType(object oGolem);

//Borra las variables permanentes relacionadas con el golem.
void DeleteAllGolemVariablesOnPlayer(object oPC);

//Guarda TRUE como variable permanente si un golem ha sido destruido y necesita reparación.
//Cada tipo de golem tiene su propia variable.
void SetGolemDeathOnPlayer(object oGolem,object oMaster);

//Aplica un efecto visual y cura en su totalidad al golem seleccionado.
void RepairDamagedGolem(object oGolem);

//Elimina la variable de muerte permanente del golem correspondiente del jugador.
void DeleteGolemDeathOnPlayer(object oGolem,object oMaster);

//Mata al golem activo del jugador y aplica la variable de golem destruido TRUE de forma permanente.
void KillActiveGolem(object oPC);

//Guarda la vida restante del golem y destruye el objeto.
void SaveAndDestroyActiveGolem(object oPC);

//Funcion que maneja la acción a tomar cuando se activa el objeto de golem.
//Si no hay golem activo,invocará al golem correspondiente según el objeto usado.
//Si se usa el objeto cuando un golem esta activo, si el objeto activado es el mismo que el golem activo,
//este guardará su vida y destruira el golem.
void CreateOrDestroyGolemOnItemActive(object oPC,object oItem);

///////////////////////////////////////////////////////
/////////                                  ////////////
/////////            FUNCIONES             ////////////
/////////                                  ////////////
///////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
int CheckGolemItemActivatedByTag(string sItem)
{
    if(GetStringLeft(sItem,6) == "pb_gs_") return TRUE;
    return FALSE;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
int CheckGolemActive(object oPC)
{
    object oGolem = GetHenchman(oPC);
    int iCounter = 1;
    string sTag;

    while (oGolem != OBJECT_INVALID) {
        if (GetStringLeft(GetTag(oGolem),6) == "golem_") return TRUE;
        iCounter++;
        oGolem = GetHenchman(oPC,iCounter);
    }
    return FALSE;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
int CheckIfGolemWasDestroyed(string sItemTag, object oPC)
{
    switch(HashString(sItemTag)) {
        case GOLEM_ITEM_TAG_FLESH:       return ObtenerIntPersistente(oPC,GOLEM_VAR_NAME_DEAD_FLESH);
        case GOLEM_ITEM_TAG_CLAY:        return ObtenerIntPersistente(oPC,GOLEM_VAR_NAME_DEAD_CLAY);
        case GOLEM_ITEM_TAG_STONE:       return ObtenerIntPersistente(oPC,GOLEM_VAR_NAME_DEAD_STONE);
        case GOLEM_ITEM_TAG_IRON:        return ObtenerIntPersistente(oPC,GOLEM_VAR_NAME_DEAD_IRON);
        case GOLEM_ITEM_TAG_MITHRIL:     return ObtenerIntPersistente(oPC,GOLEM_VAR_NAME_DEAD_MITHRIL);
        case GOLEM_ITEM_TAG_SHIELD:      return ObtenerIntPersistente(oPC,GOLEM_VAR_NAME_DEAD_SHIELD);
        case GOLEM_ITEM_TAG_HOMUNCULUS:  return ObtenerIntPersistente(oPC,GOLEM_VAR_NAME_DEAD_HOMUNCULUS);
    }
    return 0;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
object GetActiveGolemFromPlayer(object oPC)
{
    object oGolem = GetHenchman(oPC);
    int iCounter = 1;
    string sTag;

    while (oGolem != OBJECT_INVALID) {
        if (GetStringLeft(GetTag(oGolem),6) == "golem_") return oGolem;
        iCounter++;
        oGolem = GetHenchman(oPC,iCounter);
    }
    return OBJECT_INVALID;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void CleanGolemIventary(object oGolem)
{
    TakeGoldFromCreature(GetGold(oGolem),oGolem,TRUE);

    object oItem = GetFirstItemInInventory(oGolem);

    while (GetIsObjectValid(oItem))
    {
        DestroyObject(oItem);
        oItem = GetNextItemInInventory(oGolem);

    }


}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void CreateGolem(string sTag,object oPC)
{
    if (GetIsInCombat(oPC)) { SendMessageToPC(oPC,GOLEM_MSG_IN_COMBAT);return;}
    if (CheckIfGolemWasDestroyed(sTag, oPC)) {SendMessageToPC(oPC,GOLEM_MSG_DESTROYED);return;}

    string sActiveGolem = ObtenerStringPersistente(oPC,GOLEM_VAR_NAME_TAG);
    int iPermanentHP = ObtenerIntPersistente(oPC,GOLEM_VAR_NAME_HP);
    float fFacing = GetFacing(oPC);
    float fAngle = fFacing + 120.0;
    if (fAngle > 360.0) fAngle = fAngle-360.0;
    location lSpawn = GenerateNewLocationFromLocation(GetLocation(oPC),2.5,fAngle,fFacing);
    effect eVisual = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
    object oGolem;

    if (sTag == GOLEM_ITEM_TAG_FLESH && (sActiveGolem == GOLEM_TAG_FLESH || sActiveGolem == "")) {
        oGolem = CreateObject(OBJECT_TYPE_CREATURE,GOLEM_RESREF_FLESH,lSpawn,FALSE,GOLEM_TAG_FLESH);
    }
    else if (sTag == GOLEM_ITEM_TAG_CLAY && (sActiveGolem == GOLEM_TAG_CLAY || sActiveGolem == "")) {
        oGolem = CreateObject(OBJECT_TYPE_CREATURE,GOLEM_RESREF_CLAY,lSpawn,FALSE,GOLEM_TAG_CLAY);
    }
    else if (sTag == GOLEM_ITEM_TAG_STONE && (sActiveGolem == GOLEM_TAG_STONE || sActiveGolem == "")) {
        oGolem = CreateObject(OBJECT_TYPE_CREATURE,GOLEM_RESREF_STONE,lSpawn,FALSE,GOLEM_TAG_STONE);
    }
    else if (sTag == GOLEM_ITEM_TAG_IRON && (sActiveGolem == GOLEM_TAG_IRON || sActiveGolem == "")) {
        oGolem = CreateObject(OBJECT_TYPE_CREATURE,GOLEM_RESREF_IRON,lSpawn,FALSE,GOLEM_TAG_IRON);
    }
    else if (sTag == GOLEM_ITEM_TAG_MITHRIL && (sActiveGolem == GOLEM_TAG_MITHRIL || sActiveGolem == "")) {
        oGolem = CreateObject(OBJECT_TYPE_CREATURE,GOLEM_RESREF_MITHRIL,lSpawn,FALSE,GOLEM_TAG_MITHRIL);
    }
    else if (sTag == GOLEM_ITEM_TAG_SHIELD && (sActiveGolem == GOLEM_TAG_SHIELD || sActiveGolem == "")) {
        oGolem = CreateObject(OBJECT_TYPE_CREATURE,GOLEM_RESREF_SHIELD,lSpawn,FALSE,GOLEM_TAG_SHIELD);
    }
    else if (sTag == GOLEM_ITEM_TAG_HOMUNCULUS && (sActiveGolem == GOLEM_TAG_HOMUNCULUS || sActiveGolem == "")) {
        oGolem = CreateObject(OBJECT_TYPE_CREATURE,GOLEM_RESREF_HOMUNCULUS,lSpawn,FALSE,GOLEM_TAG_HOMUNCULUS);
    }
    else SendMessageToPC(oPC,GOLEM_MSG_PREVIOUS_ACTIVE);

    //FIJAR AL AYUDANTE COMO SAQUEABLE
    SetLootable(OBJECT_SELF, FALSE);
    SetObjectVisualTransform(oGolem,OBJECT_VISUAL_TRANSFORM_TRANSLATE_Z,-4.0);
    SetObjectVisualTransform(oGolem,OBJECT_VISUAL_TRANSFORM_TRANSLATE_Z,0.0,OBJECT_VISUAL_TRANSFORM_LERP_EASE_OUT,1.5);
    SetEventScript(oGolem,EVENT_SCRIPT_CREATURE_ON_HEARTBEAT,GOLEM_EVENT_ON_HEARBEAT);
    SetEventScript(oGolem,EVENT_SCRIPT_CREATURE_ON_NOTICE,GOLEM_EVENT_ON_PERCEPTION);
    SetEventScript(oGolem,EVENT_SCRIPT_CREATURE_ON_SPELLCASTAT,GOLEM_EVENT_ON_SPELLCASTAT);
    SetEventScript(oGolem,EVENT_SCRIPT_CREATURE_ON_MELEE_ATTACKED,GOLEM_EVENT_ON_DAMAGED);
    SetEventScript(oGolem,EVENT_SCRIPT_CREATURE_ON_DAMAGED,GOLEM_EVENT_ON_DAMAGED);
    SetEventScript(oGolem,EVENT_SCRIPT_CREATURE_ON_DISTURBED,GOLEM_EVENT_ON_DISTURBED);
    SetEventScript(oGolem,EVENT_SCRIPT_CREATURE_ON_END_COMBATROUND,GOLEM_EVENT_ON_END_COMBATROUND);
    SetEventScript(oGolem,EVENT_SCRIPT_CREATURE_ON_DEATH,GOLEM_EVENT_ON_DEATH);
    SetEventScript(oGolem,EVENT_SCRIPT_CREATURE_ON_USER_DEFINED_EVENT,GOLEM_EVENT_ON_USERDEFINED);
    SetEventScript(oGolem,EVENT_SCRIPT_CREATURE_ON_BLOCKED_BY_DOOR,GOLEM_EVENT_ON_BLOCKED);
    SetEventScript(oGolem,EVENT_SCRIPT_CREATURE_ON_DIALOGUE,GOLEM_EVENT_ON_CONVERSATION);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eVisual,GetLocation(oGolem));
    GuardarStringPersistente(oPC,GOLEM_VAR_NAME_TAG,GetTag(oGolem));
    AddHenchman(oPC,oGolem);
    SetLocalInt(oGolem, "X2_JUST_A_DISABLEEQUIP", TRUE);
    DelayCommand(0.5, NWNX_Creature_RemoveFeat(oGolem, 1109)); //Le quitamos la dote Ausente
    DelayCommand(0.5, NWNX_Creature_RemoveFeat(oGolem, 1110)); //Guardar PJ
    DelayCommand(0.5, NWNX_Creature_RemoveFeat(oGolem, 1111)); //Controlar Convocados
    CleanGolemIventary(oGolem);
    DelayCommand(0.5,ExecuteScript(GOLEM_EVENT_ON_SPAWN ,oGolem));
    if (iPermanentHP != 0) SetCurrentHitPoints(oGolem,iPermanentHP);

}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
int GetRepairPriceByGolemType(object oGolem)
{
    int iMaxHP = GetMaxHitPoints(oGolem);
    int iCurrentHP = GetCurrentHitPoints(oGolem);

    switch(HashString(GetTag(oGolem))) {
        case GOLEM_TAG_FLESH:           return (iMaxHP-iCurrentHP)*GOLEM_PRICE_REPAIR_FLESH;
        case GOLEM_TAG_CLAY:            return (iMaxHP-iCurrentHP)*GOLEM_PRICE_REPAIR_CLAY;
        case GOLEM_TAG_STONE:           return (iMaxHP-iCurrentHP)*GOLEM_PRICE_REPAIR_STONE;
        case GOLEM_TAG_IRON:            return (iMaxHP-iCurrentHP)*GOLEM_PRICE_REPAIR_IRON;
        case GOLEM_TAG_MITHRIL:         return (iMaxHP-iCurrentHP)*GOLEM_PRICE_REPAIR_MITHRIL;
        case GOLEM_TAG_SHIELD:          return (iMaxHP-iCurrentHP)*GOLEM_PRICE_REPAIR_SHIELD;
        case GOLEM_TAG_HOMUNCULUS:      return (iMaxHP-iCurrentHP)*GOLEM_PRICE_REPAIR_HOMUNCULUS;
    }
    return 0;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void DeleteActiveAndPermanentHPGolemVariablesOnPlayer(object oPC)
{
    BorrarIntPersistente(oPC,GOLEM_VAR_NAME_HP);
    BorrarStringPersistente(oPC,GOLEM_VAR_NAME_TAG);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void SetGolemDeathOnPlayer(object oGolem,object oMaster)
{
    switch(HashString(GetTag(oGolem))) {
        case GOLEM_TAG_FLESH:       GuardarIntPersistente(oMaster,GOLEM_VAR_NAME_DEAD_FLESH,TRUE);         break;
        case GOLEM_TAG_CLAY:        GuardarIntPersistente(oMaster,GOLEM_VAR_NAME_DEAD_CLAY,TRUE);          break;
        case GOLEM_TAG_STONE:       GuardarIntPersistente(oMaster,GOLEM_VAR_NAME_DEAD_STONE,TRUE);         break;
        case GOLEM_TAG_IRON:        GuardarIntPersistente(oMaster,GOLEM_VAR_NAME_DEAD_IRON,TRUE);          break;
        case GOLEM_TAG_MITHRIL:     GuardarIntPersistente(oMaster,GOLEM_VAR_NAME_DEAD_MITHRIL,TRUE);       break;
        case GOLEM_TAG_SHIELD:      GuardarIntPersistente(oMaster,GOLEM_VAR_NAME_DEAD_SHIELD,TRUE);        break;
        case GOLEM_TAG_HOMUNCULUS:  GuardarIntPersistente(oMaster,GOLEM_VAR_NAME_DEAD_HOMUNCULUS,TRUE);    break;
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void RepairDamagedGolem(object oGolem)
{
    effect eVisual = EffectVisualEffect(VFX_FNF_HOWL_ODD);
    effect eHeal = EffectHeal(GetMaxHitPoints(oGolem));
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eVisual,oGolem);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eHeal,oGolem);

}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void DeleteGolemDeathOnPlayer(object oGolem,object oMaster)
{
    switch(HashString(GetTag(oGolem))) {
        case GOLEM_TAG_FLESH:       BorrarIntPersistente(oMaster,GOLEM_VAR_NAME_DEAD_FLESH);       break;
        case GOLEM_TAG_CLAY:        BorrarIntPersistente(oMaster,GOLEM_VAR_NAME_DEAD_CLAY);        break;
        case GOLEM_TAG_STONE:       BorrarIntPersistente(oMaster,GOLEM_VAR_NAME_DEAD_STONE);       break;
        case GOLEM_TAG_IRON:        BorrarIntPersistente(oMaster,GOLEM_VAR_NAME_DEAD_IRON);        break;
        case GOLEM_TAG_MITHRIL:     BorrarIntPersistente(oMaster,GOLEM_VAR_NAME_DEAD_MITHRIL);     break;
        case GOLEM_TAG_SHIELD:      BorrarIntPersistente(oMaster,GOLEM_VAR_NAME_DEAD_SHIELD);      break;
        case GOLEM_TAG_HOMUNCULUS:  BorrarIntPersistente(oMaster,GOLEM_VAR_NAME_DEAD_HOMUNCULUS);  break;
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void KillActiveGolem(object oPC)
{
    if (CheckGolemActive(oPC)) {
        object oGolem =GetActiveGolemFromPlayer(oPC);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDeath(),oGolem);
        SetGolemDeathOnPlayer(oGolem,oPC);
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void SaveAndDestroyActiveGolem(object oPC)
{
    object oGolem = GetActiveGolemFromPlayer(oPC);

    if(oGolem != OBJECT_INVALID)
    {
        GuardarIntPersistente(oPC,GOLEM_VAR_NAME_HP,GetCurrentHitPoints());
        DestroyObject(oGolem);
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void CreateOrDestroyGolemOnItemActive(object oPC,object oItem)
{
    if(!GetHasFeat(407, oPC) && GetCL(oPC) < 10)
    {
        // Sin Soltura en Artesania o nivel de lanzador menor a 10, no deja activar el golem.
        SendMessageToPC(oPC,"No posees conocimientos suficientes para activar un constructo.");
        return;
    }

    string sItemTag = GetTag(oItem);
    if(CheckGolemItemActivatedByTag(sItemTag))
    {
        if (CheckGolemActive(oPC) && GetActiveGolemFromPlayer(oPC) != OBJECT_INVALID )
        {
            string sActiveGolem = ObtenerStringPersistente(oPC,GOLEM_VAR_NAME_TAG);
            if ((sItemTag == GOLEM_ITEM_TAG_FLESH && sActiveGolem == GOLEM_TAG_FLESH)         ||
            (sItemTag == GOLEM_ITEM_TAG_CLAY && sActiveGolem == GOLEM_TAG_CLAY)               ||
            (sItemTag == GOLEM_ITEM_TAG_STONE && sActiveGolem == GOLEM_TAG_STONE)             ||
            (sItemTag == GOLEM_ITEM_TAG_IRON && sActiveGolem == GOLEM_TAG_IRON)               ||
            (sItemTag == GOLEM_ITEM_TAG_MITHRIL && sActiveGolem == GOLEM_TAG_MITHRIL)         ||
            (sItemTag == GOLEM_ITEM_TAG_SHIELD && sActiveGolem == GOLEM_TAG_SHIELD)           ||
            (sItemTag == GOLEM_ITEM_TAG_HOMUNCULUS && sActiveGolem == GOLEM_TAG_HOMUNCULUS)){
                SaveAndDestroyActiveGolem(oPC);
            }
            else{
                SendMessageToPC(oPC,GOLEM_MSG_ALREADY_ACTIVE);
            }
        }
        else {
            CreateGolem(sItemTag,oPC);
        }
    }
}

