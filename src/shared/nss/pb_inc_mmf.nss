///
///Test ustom polymorph
///
#include "nwnx_creature"
#include "nwnx_item"
#include "nwnx_race"
#include "x2_inc_itemprop"
#include "mti_libreria"
#include "lib_disguise"

/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////                                                                           /////////////
/////////////                              Constantes                                   /////////////
/////////////                                                                           /////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
const string sPoly2DA =     "polymorph";
const string MMF_TAG_EW =   "MMF_CREATURE_EW";
const string MMF_TAG_HIDE = "MMF_CREATURE_HIDE";
const string MMF_TAG_CW1 =  "MMF_CREATURE_WEP1";
const string MMF_TAG_CW2 =  "MMF_CREATURE_WEP2";
const string MMF_TAG_CW3 =  "MMF_CREATURE_WEP3";

//const string EQUIPABLE_SLOT_HEAD =          "0x00001";
//const string EQUIPABLE_SLOT_CHEST =         "0x00002";
//const string EQUIPABLE_SLOT_BOOTS =         "0x00004";
//const string EQUIPABLE_SLOT_GLOVES =        "0x00008";
const string EQUIPABLE_SLOT_1H_MAIN_HAND =  "0x00010";
const string EQUIPABLE_SLOT_1H_OFF_HAND =   "0x00020";
const string EQUIPABLE_SLOT_2H_RANGED =     "0x00030";
//const string EQUIPABLE_SLOT_CLOAK =         "0x00040";
//const string EQUIPABLE_SLOT_RING =          "0x00180";
//const string EQUIPABLE_SLOT_AMULET =        "0x00200";
//const string EQUIPABLE_SLOT_BELT =          "0x00400";
const string EQUIPABLE_SLOT_ARROW =         "0x00800";
const string EQUIPABLE_SLOT_BULLET =        "0x01000";
const string EQUIPABLE_SLOT_BOLT =          "0x02000";
const string EQUIPABLE_SLOT_2H_MELE =       "0x1C010";
const string EQUIPABLE_SLOT_1H_LR =         "0x1C030";
const string EQUIPABLE_SLOT_CREATURE_W =    "0x1C000";
const string EQUIPABLE_SLOT_CREATURE_H =    "0x20000";

const int MDF_RACIALTYPE_ORC = 168;
const int MDF_RACIALTYPE_TROGLODYTE = 169;
const int MDF_RACIALTYPE_LIZARMAN = 170;
const int MDF_RACIALTYPE_GOBLIN = 171;
const int MDF_RACIALTYPE_KOBOLD = 172;
const int MDF_RACIALTYPE_DROW = 173;
const int MDF_RACIALTYPE_DUERGAR = 174;
const int MDF_RACIALTYPE_OGRE = 175;
const int MDF_RACIALTYPE_ETTIN = 176;
const int MDF_RACIALTYPE_TROLL = 177;
const int MDF_RACIALTYPE_OGRE_MAGE = 178;
const int MDF_RACIALTYPE_GIANT_HILL = 179;
const int MDF_RACIALTYPE_GIANT_FIRE = 180;
const int MDF_RACIALTYPE_GIANT_FROST = 181;
const int MDF_RACIALTYPE_MINOTAUR = 182;
const int MDF_RACIALTYPE_YETI = 183;
const int MDF_RACIALTYPE_CENTAUR = 184;
const int MDF_RACIALTYPE_STINGER = 185;
const int MDF_RACIALTYPE_GARGOYLE = 186;
const int MDF_RACIALTYPE_HARPY = 187;
const int MDF_RACIALTYPE_MEDUSA = 188;
const int MDF_RACIALTYPE_DRYAD = 189;
const int MDF_RACIALTYPE_NYMPH = 190;
const int MDF_RACIALTYPE_PIXIE = 191;
const int MDF_RACIALTYPE_SATYR = 192;
const int MDF_RACIALTYPE_SPIDER_GIANT = 193;
const int MDF_RACIALTYPE_SCARAB = 194;
const int MDF_RACIALTYPE_SPIDER_GARGAN = 195;
const int MDF_RACIALTYPE_MINDFLAYER = 196;
const int MDF_RACIALTYPE_DRIDER = 197;
const int MDF_RACIALTYPE_HOOKHORROR = 198;
const int MDF_RACIALTYPE_MYCONID = 199;
const int MDF_RACIALTYPE_ENT = 200;
const int MDF_RACIALTYPE_OOZE_B_W = 201;
const int MDF_RACIALTYPE_OOZE_CUBE = 202;
const int MDF_RACIALTYPE_ELEMENTAL_FIRE_E = 203;
const int MDF_RACIALTYPE_ELEMENTAL_WIND_E = 204;
const int MDF_RACIALTYPE_ELEMENTAL_EARTH_E = 205;
const int MDF_RACIALTYPE_ELEMENTAL_WATER_E = 206;
const int MDF_RACIALTYPE_DRAGON_RED = 207;
const int MDF_RACIALTYPE_DRAGON_BLUE = 208;
const int MDF_RACIALTYPE_DRAGON_BLACK = 209;
const int MDF_RACIALTYPE_DRAGON_GREEN = 210;
const int MDF_RACIALTYPE_DRAGON_WHITE = 211;
const int MDF_RACIALTYPE_DRAGON_GOLD = 212;
const int MDF_RACIALTYPE_DRAGON_BRASS = 213;
const int MDF_RACIALTYPE_DRAGON_BRONZE = 214;
const int MDF_RACIALTYPE_DRAGON_COPPER = 215;
const int MDF_RACIALTYPE_DRAGON_SILVER = 216;

const int MMF_ITEM_PROPERTY_USE = 15;
const int MMF_ITEM_PROPERTY_ON_HIT = 48;
const int MMF_ITEM_PROPERTY_KEEN = 43;
const int MMF_ITEM_PROPERTY_UNIVERSAL_ST = 40;
const int MMF_LEVEL_5 = 5;
const int MMF_LEVEL_10 = 10;

struct LevelBuffs
{
    int iSTR;
    int iDEX;
    int iCON;
    int iCA;
};

struct ChNameDesc
{
    string sName;
    string sDescription;

};
/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////                                                                           /////////////
/////////////                        Definiciones de funciones                          /////////////
/////////////                                                                           /////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////

//Calcula la XP necesaria de un jugador necesaria para alcanzar nivel iLVL.
int ReturnXPTarget(int iLVL,object oPC);

//Gestiona y controla la subida de nivel del MMF para que se cumpla los requisitos y da el objeto de clase para modificar las
//apariencias de las formas.
void MMFLevelUpManagement(object oPC);

//Comprueba si la criatura que entra se ha desconectado transformado.
//Si ha sido el caso recupera el equipo y gestiona variables.
void OnEnterLoadPolymorphed(object oPC);

//Wrap simple para el NWNX_Creature_RunEquip que no devuelva valor.
void WrapNWNX_Creature_RunEquip(object oCreature,object oItem,int iInventorySlot);

//Wrap simple para el NWNX_Creature_RunUnequip que no devuelva valor.
void WrapNWNX_Creature_RunUnequip(object oCreature,object oItem);

//Check que va en el evento de OnPlayerEquipItem del modulo para revisar gestionar las propiedades extra de las formas
void MMF_EquipCheck(object oPC, object oItem);

//Check que va en el evento de OnPlayerUnEquipItem del modulo para revisar gestionar las propiedades extra de las formas
void MMF_RemoveIP(object oItem);

//Devuelve una structura LevelBuffs con los bonus a estadisticas y CA segun la forma y el nivel de clase de Maestro de múltiples formas.
//Parametros:
//int iRacialType: Indice de la forma a transformarse en el polymorph.2da
//int iLevel: Nivel de clase del Maestro de múltiples formas
//Valores que devuelve: int iSTR, int iDEX, int iCON, int iCA
struct LevelBuffs MMF_GetRaceBuffLevel(int iRacialType, int iLevel);

//Devuelve una structura ChNameDesc con el nombre y la descripcion de la forma a transformarse.
//Parametros:
//int iRacialType: Indice de la forma a transformarse en el polymorph.2da
//Valores que devuelve: string sName,string sDescription;
struct ChNameDesc MMF_GetNameAndDescription(int iRacialType);

//Devuelve el numero de usos de una habilidad especifica de una forma. Las habilidades de cada forma
//estan definidos en el polymorph.2da
//Parametros:
//int iPOLYMORPH_TYPE: Indice de la forma a transformarse en el polymorph.2da
//int iSpellID: Indice en la tabla de spells.2da
int MDF_GetSpecialAbilityUses(int iPOLYMORPH_TYPE,int iSpellID);

//Añade al jugador la habilidad especifica según la forma a transformarse.
//Parametros:
//object oPC: Jugador a aplicar la función
//int iPOLYMORPH_TYPE: Indice de la forma a transformarse en el polymorph.2da
//int iSpellID: Indice en la tabla de spells.2da
//int iLOGGED_OUT: Determinal si se esta llamando la función en el onenter despues de desloguear transformado, para
//restaurar asi las habildiades.
void AddMDFSpecialAbility(object oPC,int iSpellID,int iPOLYMORPH_TYPE,int iLOGGED_OUT = FALSE);

//Borra todas las habilidades ganadas con el sistema de Maestro de las múltiples formas del jugador
void RemoveAllMDFSpecialAbility(object oPC);

//Guarda los usos restantes de las habilidades especiales del Maestro de Multiples Formas de forma permanente.
void SaveRemainingMMFSpecialAbilityUses(object oPC);

//Un wrap especifico de este sistema para combinar las propiedades del arma del jugador con las armas de criatura.
//Parametros:
//Json jItemTemplate: Template en json del arma de criatura que se va a equipar en la forma.
//json jPropertiesListToAdd: Lista de propiedades extraida del arma equipada del jugador antes de transformarse.
//object oPC: Jugador que se va a transformar.
//string sNewTag: Nuevo tag que tendrá el objeto creado.
object CreateItemMergingPropertiesFromTemplate(json jItemTemplate,json jPropertiesListToAdd,object oPC, string sNewTag = "");

//Esta función actualiza las propiedades del objeto de piel de criatura según el nivel del Maestro de múltiples formas.
//Parametros:
//object oCreatureHide: Piel de criatura a actualizar las propiedades.
//int iMMFLevel: Nivel de clase de Maestro de múltiples formas.
//int iPOLYMORPH_CONSTANT: indice de la forma a transformarse en el polymorph.2da
object MMF_UpdateObjectCreatureHide(object oCreatureHide,int iMMFLevel,int iPOLYMORPH_CONSTANT);

//Función principal donde se gestionan los cambios de estadisticas, CA, habilidades añadidas y creación de objetos de criatura.
void EffectMDFPolymorph(object oPC,int iPOLYMORPH_CONSTANT);

//Se guardan los valores originales del jugador antes de transformarse en el contenedor de variables.
//Se guarda: Retrato, Raza, Apariencia, Fuerza, Destreza, Constitución, CA, SoundSet
void StoreOriginalData(object oPC, int iConstant);

//Guarda todos los objetos equipados del jugador en el contenedor de variables y los destruye.
//Parametros:
//object oPC: Jugador a guardar los objetos en su contenedor de variables.
//object oContainer: Contenedor de variables.
//int iMergeW: Valor boleano, si es TRUE guardara las propiedades del arma como un json para su uso posterior.
//int SkipPlayerEquipableItems: Valor boleano, si es TRUE sólo guardara los objetos de criatura. (Garras, mordisco y piel)
void SaveEquippedItems(object oPC, object oContainer, int iMergeW,/*int SkipPlayerEquipableItems = FALSE,*/ int SkipCreatureItems = FALSE);

//Gestiona según la forma si se tiene que guardar el equipo y/o guardar las propiedades del arma.
//Parametros:
//object oPC: Jugador que se va a transformar.
//int iPOLYMORPH_CONSTANT: Indice de la forma a transformarse en el polymorph.2da
void StoreOriginalEquipment(object oPC, int iPOLYMORPH_CONSTANT);

//Carga los datos originales del personaje y los aplica.
//Se carga: Retrato, Raza, Apariencia, Fuerza, Destreza, Constitución, CA, SoundSet
void LoadOriginalData(object oPC);

//Carga el equipo guardado antes de transformarse y lo equipa al jugador.
void LoadOriginalEquipment(object oPC);
/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////                                                                           /////////////
/////////////                        Desarrollo de funciones                            /////////////
/////////////                                                                           /////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////

int ReturnXPTarget(int iLVL,object oPC)
{
    int i;
    int iXP = 0;

    for(i=1; i <= iLVL; i++){
        iXP += i* 1000;
    }
    return iXP;
}

void MMFLevelUpManagement(object oPC)
{
    int iDruid = GetLevelByClass(CLASS_TYPE_DRUID,oPC);
    int iWizard = GetLevelByClass(CLASS_TYPE_WIZARD,oPC);
    int iSorcerer = GetLevelByClass(CLASS_TYPE_SORCERER,oPC);
    int iMMF = GetLevelByClass(63,oPC);


    if(iMMF == 1 && !(iWizard >= 5) && !(iSorcerer >= 6) && !(iDruid >= 5))
    {

        int iXP = GetXP(oPC);
        int newXP = ReturnXPTarget(GetHitDice(oPC)-1,oPC)-1;

        SetXP(oPC,newXP);
        DelayCommand(0.3,SetXP(oPC,iXP));
        DelayCommand(1.5,DestroyObject(GetItemPossessedBy(oPC,"MMF_SKINS")));
        SendMessageToPC(oPC,"No cumples los requisitos para esta clase, por favor revísalos bien.");

    }
    else if(iMMF ==1 && !GetIsObjectValid(GetItemPossessedBy(oPC,"MMF_SKINS"))) {CreateItemOnObject("mmf_skins",oPC); GuardarIntPersistente(oPC,"MMF_ORIGINAL_RACE",GetRacialType(oPC));}

    if (iMMF == 10) NWNX_Creature_SetRacialType(oPC,RACIAL_TYPE_SHAPECHANGER);//Cambiaformas

}


void WrapNWNX_Creature_RunEquip(object oCreature,object oItem,int iInventorySlot)
{
    NWNX_Creature_RunEquip(oCreature,oItem,iInventorySlot);
}

void WrapNWNX_Creature_RunUnequip(object oCreature,object oItem)
{
    NWNX_Creature_RunUnequip(oCreature,oItem);
}
void MMF_EquipCheck(object oPC, object oItem)
{
    if(ObtenerIntPersistente(oPC,"POLYMORPHED"))
    {
        int iConstant = ObtenerIntPersistente(oPC,"POLYMORPHED_FORM");
        itemproperty ipToAdd;
        switch(iConstant)
        {
            case MDF_RACIALTYPE_GIANT_FIRE: ipToAdd = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGEBONUS_1d6); break;
            case MDF_RACIALTYPE_GIANT_FROST: ipToAdd = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGEBONUS_1d6); break;
            case MDF_RACIALTYPE_DRIDER: ipToAdd = ItemPropertyOnHitProps(IP_CONST_ONHIT_ITEMPOISON,IP_CONST_ONHIT_SAVEDC_20,IP_CONST_POISON_1D2_STRDAMAGE); break;
            case MDF_RACIALTYPE_PIXIE: ipToAdd = ItemPropertyOnHitProps(IP_CONST_ONHIT_STUN,IP_CONST_ONHIT_SAVEDC_20,IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS); break;
            case MDF_RACIALTYPE_STINGER: ipToAdd = ItemPropertyOnHitProps(IP_CONST_ONHIT_ITEMPOISON,IP_CONST_ONHIT_SAVEDC_20,IP_CONST_POISON_1D2_STRDAMAGE); break;
            case MDF_RACIALTYPE_CENTAUR: ipToAdd = ItemPropertyOnHitProps(IP_CONST_ONHIT_ITEMPOISON,IP_CONST_ONHIT_SAVEDC_20,IP_CONST_POISON_1D2_STRDAMAGE); break;
        }

        if(GetIsItemPropertyValid(ipToAdd))
        {
            ipToAdd = TagItemProperty(ipToAdd,"MMF_ITEMPROPERTY");
            IPSafeAddItemProperty(oItem,ipToAdd,9999.99,X2_IP_ADDPROP_POLICY_KEEP_EXISTING,TRUE);
        }


    }
}

void MMF_RemoveIP(object oItem)
{
    //int iConstant = GetLocalInt(oPC,"POLYMORPHED_FORM");
    itemproperty iP = GetFirstItemProperty(oItem);
    while(GetIsItemPropertyValid(iP))
    {
        if(GetItemPropertyTag(iP) == "MMF_ITEMPROPERTY"){ RemoveItemProperty(oItem,iP); break;}
        iP = GetNextItemProperty(oItem);
    }
}

struct LevelBuffs MMF_GetRaceBuffLevel(int iRacialType, int iLevel)
{
    struct LevelBuffs stcBuffs;

    if( iLevel >= MMF_LEVEL_10){
        if(     iRacialType == MDF_RACIALTYPE_ORC)          {stcBuffs.iSTR = 4;}
        else if(iRacialType == MDF_RACIALTYPE_TROGLODYTE)   {stcBuffs.iSTR = 4;}
        else if(iRacialType == MDF_RACIALTYPE_LIZARMAN)     {stcBuffs.iSTR = 4;}
        else if(iRacialType == MDF_RACIALTYPE_GOBLIN)       {stcBuffs.iDEX = 4;}
        else if(iRacialType == MDF_RACIALTYPE_KOBOLD)       {stcBuffs.iDEX = 4;}
        else if(iRacialType == MDF_RACIALTYPE_DROW)         {stcBuffs.iDEX = 2;}
        else if(iRacialType == MDF_RACIALTYPE_DUERGAR)      {stcBuffs.iDEX = 2; stcBuffs.iCON = 2;}
        else if(iRacialType == MDF_RACIALTYPE_OGRE)         {stcBuffs.iSTR = 4;}
        else if(iRacialType == MDF_RACIALTYPE_ETTIN)        {stcBuffs.iSTR = 4;}
        else if(iRacialType == MDF_RACIALTYPE_TROLL)        {stcBuffs.iSTR = 4;}
        else if(iRacialType == MDF_RACIALTYPE_OGRE_MAGE)    {stcBuffs.iSTR = 3;}
        else if(iRacialType == MDF_RACIALTYPE_GIANT_HILL)   {stcBuffs.iSTR = 2;}
        else if(iRacialType == MDF_RACIALTYPE_MINOTAUR)     {stcBuffs.iSTR = 4;}
        else if(iRacialType == MDF_RACIALTYPE_YETI)         {stcBuffs.iSTR = 4;}
        else if(iRacialType == MDF_RACIALTYPE_CENTAUR)      {stcBuffs.iDEX = 2;}
        else if(iRacialType == MDF_RACIALTYPE_STINGER)      {stcBuffs.iDEX = 2;}
        else if(iRacialType == MDF_RACIALTYPE_GARGOYLE)     {stcBuffs.iSTR = 4;}
        else if(iRacialType == MDF_RACIALTYPE_HARPY)        {stcBuffs.iDEX = 4;}
        //else if(iRacialType == MDF_RACIALTYPE_MEDUSA)       {stcBuffs.iDEX = 2; stcBuffs.iCON = 2;}
        else if(iRacialType == MDF_RACIALTYPE_DRYAD)        {stcBuffs.iDEX = 4;}
        else if(iRacialType == MDF_RACIALTYPE_NYMPH)        {stcBuffs.iDEX = 4;}
        else if(iRacialType == MDF_RACIALTYPE_SATYR)        {stcBuffs.iDEX = 4;}
        else if(iRacialType == MDF_RACIALTYPE_SPIDER_GIANT) {stcBuffs.iSTR = 4;}
        else if(iRacialType == MDF_RACIALTYPE_SCARAB)       {stcBuffs.iSTR = 2;}
        else if(iRacialType == MDF_RACIALTYPE_DRIDER)       {stcBuffs.iSTR = 2;}
        else if(iRacialType == MDF_RACIALTYPE_HOOKHORROR)   {stcBuffs.iSTR = 2;}
        else if(iRacialType == MDF_RACIALTYPE_MYCONID)      {stcBuffs.iSTR = 2;}
    }
    else if( iLevel >= MMF_LEVEL_5){
        if(     iRacialType == MDF_RACIALTYPE_ORC)          {stcBuffs.iSTR = 2;}
        else if(iRacialType == MDF_RACIALTYPE_TROGLODYTE)   {stcBuffs.iSTR = 2;}
        else if(iRacialType == MDF_RACIALTYPE_LIZARMAN)     {stcBuffs.iSTR = 2;}
        else if(iRacialType == MDF_RACIALTYPE_GOBLIN)       {stcBuffs.iDEX = 2;}
        else if(iRacialType == MDF_RACIALTYPE_KOBOLD)       {stcBuffs.iDEX = 2;}
        else if(iRacialType == MDF_RACIALTYPE_OGRE)         {stcBuffs.iSTR = 2;}
        else if(iRacialType == MDF_RACIALTYPE_ETTIN)        {stcBuffs.iSTR = 2;}
        else if(iRacialType == MDF_RACIALTYPE_TROLL)        {stcBuffs.iSTR = 2;}
        else if(iRacialType == MDF_RACIALTYPE_MINOTAUR)     {stcBuffs.iSTR = 2;}
        else if(iRacialType == MDF_RACIALTYPE_YETI)         {stcBuffs.iSTR = 2;}
        else if(iRacialType == MDF_RACIALTYPE_GARGOYLE)     {stcBuffs.iSTR = 2;}
        else if(iRacialType == MDF_RACIALTYPE_HARPY)        {stcBuffs.iDEX = 2;}
        else if(iRacialType == MDF_RACIALTYPE_DRYAD)        {stcBuffs.iDEX = 2;}
        else if(iRacialType == MDF_RACIALTYPE_NYMPH)        {stcBuffs.iDEX = 2;}
        else if(iRacialType == MDF_RACIALTYPE_SATYR)        {stcBuffs.iDEX = 2;}
        else if(iRacialType == MDF_RACIALTYPE_SPIDER_GIANT) {stcBuffs.iDEX = 2;}
    }

    return stcBuffs;
}

struct ChNameDesc MMF_GetNameAndDescription(int iRacialType)
{
    struct ChNameDesc N_D;

    if      (iRacialType == MDF_RACIALTYPE_ORC){                 N_D.sName = GetStringByStrRef(12674); N_D.sDescription = GetStringByStrRef(12673);}
    else if (iRacialType == MDF_RACIALTYPE_TROGLODYTE){          N_D.sName = GetStringByStrRef(110636); N_D.sDescription = GetStringByStrRef(110640);}
    else if (iRacialType == MDF_RACIALTYPE_LIZARMAN){            N_D.sName = GetStringByStrRef(6709); N_D.sDescription = GetStringByStrRef(12667);}
    else if (iRacialType == MDF_RACIALTYPE_GOBLIN){              N_D.sName = GetStringByStrRef(6708); N_D.sDescription = GetStringByStrRef(12565);}
    else if (iRacialType == MDF_RACIALTYPE_KOBOLD){              N_D.sName = GetStringByStrRef(2924); N_D.sDescription = GetStringByStrRef(2927);}
    else if (iRacialType == MDF_RACIALTYPE_DROW){                N_D.sName = GetStringByStrRef(108156); N_D.sDescription = GetStringByStrRef(64101);}
    else if (iRacialType == MDF_RACIALTYPE_DUERGAR){             N_D.sName = GetStringByStrRef(12506); N_D.sDescription = GetStringByStrRef(63230);}
    else if (iRacialType == MDF_RACIALTYPE_OGRE){                N_D.sName = GetStringByStrRef(12664); N_D.sDescription = GetStringByStrRef(12663);}
    else if (iRacialType == MDF_RACIALTYPE_ETTIN){               N_D.sName = GetStringByStrRef(2054); N_D.sDescription = GetStringByStrRef(12523);}
    else if (iRacialType == MDF_RACIALTYPE_TROLL){               N_D.sName = GetStringByStrRef(2137); N_D.sDescription = GetStringByStrRef(12785);}
    else if (iRacialType == MDF_RACIALTYPE_OGRE_MAGE){           N_D.sName = GetStringByStrRef(12666); N_D.sDescription = GetStringByStrRef(12663);}
    else if (iRacialType == MDF_RACIALTYPE_GIANT_HILL){          N_D.sName = GetStringByStrRef(2060); N_D.sDescription = GetStringByStrRef(12561);}
    else if (iRacialType == MDF_RACIALTYPE_GIANT_FIRE){          N_D.sName = GetStringByStrRef(2062); N_D.sDescription = GetStringByStrRef(12557);} // female N_D.sName = GetStringByStrRef(2898); N_D.sDescription = GetStringByStrRef(40607) ;}
    else if (iRacialType == MDF_RACIALTYPE_GIANT_FROST){         N_D.sName = GetStringByStrRef(2063); N_D.sDescription = GetStringByStrRef(12559);} // female N_D.sName = GetStringByStrRef(2897); N_D.sDescription = GetStringByStrRef(40608) ;}
    else if (iRacialType == MDF_RACIALTYPE_MINOTAUR){            N_D.sName = GetStringByStrRef(2096); N_D.sDescription = GetStringByStrRef(12644);}
    else if (iRacialType == MDF_RACIALTYPE_YETI){                N_D.sName = GetStringByStrRef(16780553); N_D.sDescription = GetStringByStrRef(16780554);}
    else if (iRacialType == MDF_RACIALTYPE_CENTAUR){             N_D.sName = GetStringByStrRef(16780555); N_D.sDescription = GetStringByStrRef(16780556);}
    else if (iRacialType == MDF_RACIALTYPE_STINGER){             N_D.sName = GetStringByStrRef(2872); N_D.sDescription = GetStringByStrRef(40620);}
    else if (iRacialType == MDF_RACIALTYPE_GARGOYLE){            N_D.sName = GetStringByStrRef(2055); N_D.sDescription = GetStringByStrRef(12549);}
    else if (iRacialType == MDF_RACIALTYPE_HARPY){               N_D.sName = GetStringByStrRef(3076); N_D.sDescription = GetStringByStrRef(84411);}
    else if (iRacialType == MDF_RACIALTYPE_MEDUSA){              N_D.sName = GetStringByStrRef(2854); N_D.sDescription = GetStringByStrRef(79593);}
    else if (iRacialType == MDF_RACIALTYPE_DRYAD){               N_D.sName = GetStringByStrRef(12505); N_D.sDescription = GetStringByStrRef(12504);}
    else if (iRacialType == MDF_RACIALTYPE_NYMPH){               N_D.sName = GetStringByStrRef(2102); N_D.sDescription = GetStringByStrRef(12661);}
    else if (iRacialType == MDF_RACIALTYPE_PIXIE){               N_D.sName = GetStringByStrRef(6005); N_D.sDescription = GetStringByStrRef(6007);}
    else if (iRacialType == MDF_RACIALTYPE_SATYR){               N_D.sName = GetStringByStrRef(110988); N_D.sDescription = GetStringByStrRef(111385);}
    else if (iRacialType == MDF_RACIALTYPE_SPIDER_GIANT){        N_D.sName = GetStringByStrRef(12720); N_D.sDescription = GetStringByStrRef(12719);}
    else if (iRacialType == MDF_RACIALTYPE_SCARAB){              N_D.sName = GetStringByStrRef(12405); N_D.sDescription = GetStringByStrRef(12404);}
    else if (iRacialType == MDF_RACIALTYPE_SPIDER_GARGAN){       N_D.sName = GetStringByStrRef(16780551); N_D.sDescription = GetStringByStrRef(16780552);}
    else if (iRacialType == MDF_RACIALTYPE_MINDFLAYER){          N_D.sName = GetStringByStrRef(3070); N_D.sDescription = GetStringByStrRef(84403);}
    else if (iRacialType == MDF_RACIALTYPE_DRIDER){              N_D.sName = GetStringByStrRef(3063); N_D.sDescription = GetStringByStrRef(84401);}
    else if (iRacialType == MDF_RACIALTYPE_HOOKHORROR){          N_D.sName = GetStringByStrRef(16780550); N_D.sDescription = GetStringByStrRef(12615);}
    else if (iRacialType == MDF_RACIALTYPE_MYCONID){             N_D.sName = GetStringByStrRef(16780557); N_D.sDescription = GetStringByStrRef(16816648);}
    else if (iRacialType == MDF_RACIALTYPE_ENT){                 N_D.sName = GetStringByStrRef(16816675); N_D.sDescription = GetStringByStrRef(16816678);}
    else if (iRacialType == MDF_RACIALTYPE_OOZE_B_W){            N_D.sName = GetStringByStrRef(16812560); N_D.sDescription = GetStringByStrRef(16816582);}
    else if (iRacialType == MDF_RACIALTYPE_OOZE_CUBE){           N_D.sName = GetStringByStrRef(84439); N_D.sDescription = GetStringByStrRef(86780);}
    else if (iRacialType == MDF_RACIALTYPE_ELEMENTAL_FIRE_E){    N_D.sName = GetStringByStrRef(2043); N_D.sDescription = GetStringByStrRef(12530);}
    else if (iRacialType == MDF_RACIALTYPE_ELEMENTAL_WIND_E){    N_D.sName = GetStringByStrRef(2035); N_D.sDescription = GetStringByStrRef(12355);}
    else if (iRacialType == MDF_RACIALTYPE_ELEMENTAL_EARTH_E){   N_D.sName = GetStringByStrRef(2039); N_D.sDescription = GetStringByStrRef(12514);}
    else if (iRacialType == MDF_RACIALTYPE_ELEMENTAL_WATER_E){   N_D.sName = GetStringByStrRef(2050); N_D.sDescription = GetStringByStrRef(12775);}
    else if (iRacialType == MDF_RACIALTYPE_DRAGON_RED){          N_D.sName = GetStringByStrRef(12491); N_D.sDescription = GetStringByStrRef(12488);}
    else if (iRacialType == MDF_RACIALTYPE_DRAGON_BLUE){         N_D.sName = GetStringByStrRef(12467); N_D.sDescription = GetStringByStrRef(12464);}
    else if (iRacialType == MDF_RACIALTYPE_DRAGON_BLACK){        N_D.sName = GetStringByStrRef(12463); N_D.sDescription = GetStringByStrRef(12460);}
    else if (iRacialType == MDF_RACIALTYPE_DRAGON_GREEN){        N_D.sName = GetStringByStrRef(12487); N_D.sDescription = GetStringByStrRef(12484);}
    else if (iRacialType == MDF_RACIALTYPE_DRAGON_WHITE){        N_D.sName = GetStringByStrRef(12499); N_D.sDescription = GetStringByStrRef(12496);}
    else if (iRacialType == MDF_RACIALTYPE_DRAGON_GOLD){         N_D.sName = GetStringByStrRef(12483); N_D.sDescription = GetStringByStrRef(12480);}
    else if (iRacialType == MDF_RACIALTYPE_DRAGON_BRASS){        N_D.sName = GetStringByStrRef(12471); N_D.sDescription = GetStringByStrRef(12468);}
    else if (iRacialType == MDF_RACIALTYPE_DRAGON_BRONZE){       N_D.sName = GetStringByStrRef(12475); N_D.sDescription = GetStringByStrRef(12472);}
    else if (iRacialType == MDF_RACIALTYPE_DRAGON_COPPER){       N_D.sName = GetStringByStrRef(12479); N_D.sDescription = GetStringByStrRef(12476);}
    else if (iRacialType == MDF_RACIALTYPE_DRAGON_SILVER){       N_D.sName = GetStringByStrRef(12495); N_D.sDescription = GetStringByStrRef(12492);}

    return  N_D;
}

int MDF_GetSpecialAbilityUses(int iPOLYMORPH_TYPE,int iSpellID)
{
    int iUses = 0;

    if     (iPOLYMORPH_TYPE == MDF_RACIALTYPE_DROW ) {
        if     (iSpellID == 1529) iUses = 3;//Darkness
    }
    else if(iPOLYMORPH_TYPE == MDF_RACIALTYPE_DUERGAR ){
        if     (iSpellID == 1530) iUses = 4; //Invisibility
    }
    else if(iPOLYMORPH_TYPE == MDF_RACIALTYPE_OGRE_MAGE ) {
        if     (iSpellID == 1531) iUses = 1; //Charm Person
        else if(iSpellID == 1532) iUses = 1; //Cone of Cold
        else if(iSpellID == 1530) iUses = 3; //Invisibility
    }
    else if(iPOLYMORPH_TYPE == MDF_RACIALTYPE_GIANT_HILL ){
        if     (iSpellID == 1533) iUses = 30; //Throw Stone
    }
    else if(iPOLYMORPH_TYPE == MDF_RACIALTYPE_GIANT_FIRE ){
        if     (iSpellID == 1533) iUses = 30; //Throw Stone
    }
    else if(iPOLYMORPH_TYPE == MDF_RACIALTYPE_GIANT_FROST ){
        if     (iSpellID == 1533) iUses = 30; //Throw Stone
    }
    else if(iPOLYMORPH_TYPE == MDF_RACIALTYPE_STINGER ){
        if     (iSpellID == 1129) iUses = 3; //Dimension door
    }
    else if(iPOLYMORPH_TYPE == MDF_RACIALTYPE_CENTAUR ){
        if     (iSpellID == 1129) iUses = 3; //Dimension door
    }
    else if(iPOLYMORPH_TYPE == MDF_RACIALTYPE_GARGOYLE ){
        if     (iSpellID == 995) iUses = 30; //Fly
    }
    else if(iPOLYMORPH_TYPE == MDF_RACIALTYPE_HARPY ){
        if     (iSpellID == 995) iUses = 30; //Fly
        else if(iSpellID == 1534) iUses = 3; //Charm Monster
    }
    else if(iPOLYMORPH_TYPE == MDF_RACIALTYPE_MEDUSA ){
        if     (iSpellID == 1535) iUses = 30; //Petrifying Gaze
        else if(iSpellID == 1536) iUses = 30; //Poison
    }
    else if(iPOLYMORPH_TYPE == MDF_RACIALTYPE_DRYAD ) {
        if     (iSpellID == 1534) iUses = 5; //Charm Monster
        else if(iSpellID == 1537) iUses = 5; //Dominate Person
        else if(iSpellID == 994) iUses = 30; //Zancada Arborea
    }
    else if(iPOLYMORPH_TYPE == MDF_RACIALTYPE_NYMPH ) {
        if     (iSpellID == 1534) iUses = 5; //Charm Monster
        else if(iSpellID == 1537) iUses = 5; //Dominate Person
        else if(iSpellID == 994) iUses = 30; //Zancada Arborea
    }
    else if(iPOLYMORPH_TYPE == MDF_RACIALTYPE_PIXIE ) {
        if     (iSpellID == 995) iUses = 30; //Fly
        else if(iSpellID == 1538) iUses = 30; //Improved Invisibility
        else if(iSpellID == 1537) iUses = 4; //Dominate person
    }
    else if(iPOLYMORPH_TYPE == MDF_RACIALTYPE_SATYR ) {
        if     (iSpellID == 1534) iUses = 5; //Charm Monster
        else if(iSpellID == 1537) iUses = 5; //Dominate Person
    }
    else if(iPOLYMORPH_TYPE == MDF_RACIALTYPE_SPIDER_GIANT ) {
        if     (iSpellID == 1544) iUses = 4;  //Web
        else if(iSpellID == 1539) iUses = 4; //Trepal cual aracnido
        else if(iSpellID == 1129) iUses = 4; //Dimension door
    }
    else if(iPOLYMORPH_TYPE == MDF_RACIALTYPE_SCARAB ) {
        if     (iSpellID == 1528) iUses = 30; //Fireball
    }
    else if(iPOLYMORPH_TYPE == MDF_RACIALTYPE_SPIDER_GARGAN ) {
        if     (iSpellID == 1545) iUses = 4; //Bebelith Web
        else if(iSpellID == 1106) iUses = 4; //Trepal cual aracnido
    }
    else if(iPOLYMORPH_TYPE == MDF_RACIALTYPE_DRIDER ) {
        if     (iSpellID == 1529) iUses = 3;  //Darkness
        else if(iSpellID == 1546) iUses = 3;  //Dispel Magic
        else if(iSpellID == 1540) iUses = 3; //Mage Armor
    }
    else if(iPOLYMORPH_TYPE == MDF_RACIALTYPE_MINDFLAYER ) {
        if     (iSpellID == 1553) iUses = 5;// Mind Barrier
        else if(iSpellID == 1554) iUses = 5; // Mind Blast
    }
    else if(iPOLYMORPH_TYPE == MDF_RACIALTYPE_MYCONID ) {
        if     (iSpellID == 1534) iUses = 3; //Charm Monster
        else if(iSpellID == 1547) iUses = 3; //Nube azul
    }
    else if(iPOLYMORPH_TYPE == MDF_RACIALTYPE_ENT ) {
        if     (iSpellID == 1548) iUses = 30;//Entangle
    }
    else if(iPOLYMORPH_TYPE == MDF_RACIALTYPE_ELEMENTAL_FIRE_E ) {
        if     (iSpellID == 1541) iUses = 3;//Elemental Shield
    }
    else if(iPOLYMORPH_TYPE == MDF_RACIALTYPE_ELEMENTAL_WIND_E ) {
        if     (iSpellID == 995) iUses = 30; //Fly
    }
    else if(iPOLYMORPH_TYPE == MDF_RACIALTYPE_ELEMENTAL_EARTH_E ) {
        if     (iSpellID == 1542) iUses = 3;//Acid Sheath
    }
    else if(iPOLYMORPH_TYPE == MDF_RACIALTYPE_ELEMENTAL_WATER_E ) {
        if     (iSpellID == 1543) iUses = 2;//Drown
    }
    else if(iPOLYMORPH_TYPE == MDF_RACIALTYPE_DRAGON_RED ) {
        if     (iSpellID == 1551) iUses = 3;//Fire Breath
        else if(iSpellID == 412) iUses = 30; //Fear Aura
        else if(iSpellID == 991) iUses = 1; //Teleport
    }
    else if(iPOLYMORPH_TYPE == MDF_RACIALTYPE_DRAGON_BLUE ) {
        if     (iSpellID == 1552) iUses = 3;//Electric Breath
        else if(iSpellID == 412) iUses = 30; //Fear Aura
        else if(iSpellID == 991) iUses = 1; //Teleport
    }
    else if(iPOLYMORPH_TYPE == MDF_RACIALTYPE_DRAGON_BLACK ) {
        if     (iSpellID == 1549) iUses = 3;//Acid Breath
        else if(iSpellID == 412) iUses = 30; //Fear Aura
        else if(iSpellID == 991) iUses = 1; //Teleport
    }
    else if(iPOLYMORPH_TYPE == MDF_RACIALTYPE_DRAGON_GREEN ) {
        if     (iSpellID == 1549) iUses = 3;//Acid Breath
        else if(iSpellID == 412) iUses = 30; //Fear Aura
        else if(iSpellID == 991) iUses = 1; //Teleport
    }
    else if(iPOLYMORPH_TYPE == MDF_RACIALTYPE_DRAGON_WHITE ) {
        if     (iSpellID == 1550) iUses = 3;//Ice Breath
        else if(iSpellID == 412) iUses = 30; //Fear Aura
        else if(iSpellID == 991) iUses = 1; //Teleport
    }
    else if(iPOLYMORPH_TYPE == MDF_RACIALTYPE_DRAGON_GOLD ) {
        if     (iSpellID == 1551) iUses = 3;//Fire Breath
        else if(iSpellID == 412) iUses = 30; //Fear Aura
        else if(iSpellID == 991) iUses = 1; //Teleport
    }
    else if(iPOLYMORPH_TYPE == MDF_RACIALTYPE_DRAGON_BRASS  ) {
        if     (iSpellID == 1551) iUses = 3;//Fire Breath
        else if(iSpellID == 412) iUses = 30; //Fear Aura
        else if(iSpellID == 991) iUses = 1; //Teleport
    }
    else if(iPOLYMORPH_TYPE == MDF_RACIALTYPE_DRAGON_BRONZE  ) {
        if     (iSpellID == 1552) iUses = 3;//Electric Breath
        else if(iSpellID == 412) iUses = 30; //Fear Aura
        else if(iSpellID == 991) iUses = 1; //Teleport
    }
    else if(iPOLYMORPH_TYPE == MDF_RACIALTYPE_DRAGON_COPPER  ) {
        if     (iSpellID == 1549) iUses = 3;//Acid Breath
        else if(iSpellID == 412) iUses = 30; //Fear Aura
        else if(iSpellID == 991) iUses = 1; //Teleport
    }
    else if(iPOLYMORPH_TYPE == MDF_RACIALTYPE_DRAGON_SILVER  ) {
        if     (iSpellID == 1550) iUses = 3;//Ice Breath
        else if(iSpellID == 412) iUses = 30; //Fear Aura
        else if(iSpellID == 991) iUses = 1; //Teleport
    }

    return iUses;
}


void AddMDFSpecialAbility(object oPC,int iSpellID,int iPOLYMORPH_TYPE,int iLOGGED_OUT = FALSE)
{
    int iUses;
    int iSpecialAbilityCount = NWNX_Creature_GetSpecialAbilityCount(oPC);
    int iLevel = GetHitDice(oPC);
    if (iLevel > 15) iLevel = 15;
    int iCount = ObtenerIntPersistente(oPC,"MDF_SA_COUNT");
    if(iLOGGED_OUT) iUses = ObtenerIntPersistente(oPC,"MMF_SPELL_USES"+IntToString(iSpellID));
    else {iUses = MDF_GetSpecialAbilityUses(iPOLYMORPH_TYPE,iSpellID);}

    if(iUses == 0) return;

    string sSA_index = "MDF_SP_INDEX_";
    int iIndex,i;
    struct NWNX_Creature_SpecialAbility SpecialAbility;
    SpecialAbility.id = iSpellID;
    SpecialAbility.ready = 1;
    SpecialAbility.level = iLevel;
    for( iIndex = 0; iIndex <= iSpecialAbilityCount ; iIndex++)
    {
        if(NWNX_Creature_GetSpecialAbility(oPC,iIndex).id == -1)
        {
            for(i = 0; i < iUses; i++)
            {;
                NWNX_Creature_AddSpecialAbility(oPC,SpecialAbility);
                NWNX_Creature_SetSpecialAbility(oPC,iCount,SpecialAbility);
                GuardarIntPersistente(oPC,sSA_index+IntToString(iCount),iCount);
                iCount++;
            }
        }
    }
    GuardarIntPersistente(oPC,"MDF_SA_COUNT",iCount);
}

void RemoveAllMDFSpecialAbility(object oPC)
{
    string sSA_index = "MDF_SP_INDEX_";
    int iSACount = ObtenerIntPersistente(oPC,"MDF_SA_COUNT");
    int iIndex;
    if(iSACount != 0)
    {
        for(iIndex = 0 ; iIndex < iSACount; iIndex++)
        {
            NWNX_Creature_RemoveSpecialAbility(oPC, ObtenerIntPersistente(oPC,sSA_index+IntToString(iIndex)));
            BorrarIntPersistente(oPC,sSA_index+IntToString(iIndex));
        }
    }
    BorrarIntPersistente(oPC,"MDF_SA_COUNT");

}


void SaveRemainingMMFSpecialAbilityUses(object oPC)
{
    int iConstant = ObtenerIntPersistente(oPC,"POLYMORPHED_FORM");
    int iSpell1 = StringToInt(Get2DAString(sPoly2DA,"SPELL1",iConstant));
    int iSpell2 = StringToInt(Get2DAString(sPoly2DA,"SPELL2",iConstant));
    int iSpell3 = StringToInt(Get2DAString(sPoly2DA,"SPELL3",iConstant));
    int iSpellCount1 = 0;
    int iSpellCount2 = 0;
    int iSpellCount3 = 0;

    string sSA_index = "MDF_SP_INDEX_";
    int iSACount = ObtenerIntPersistente(oPC,"MDF_SA_COUNT");
    int iIndex;
    if(iSACount != 0)
    {
        for(iIndex = 0 ; iIndex < iSACount; iIndex++)
        {
            struct NWNX_Creature_SpecialAbility SpecialAbility = NWNX_Creature_GetSpecialAbility(oPC,iIndex);
            if(SpecialAbility.id == iSpell1 && SpecialAbility.ready == TRUE) iSpellCount1++;
            else if(SpecialAbility.id == iSpell2 && SpecialAbility.ready == TRUE) iSpellCount2++;
            else if(SpecialAbility.id == iSpell3 && SpecialAbility.ready == TRUE) iSpellCount3++;

        }
    }
    if(iSpell1) GuardarIntPersistente(oPC,"MMF_SPELL_USES"+IntToString(iSpell1),iSpellCount1);
    if(iSpell2) GuardarIntPersistente(oPC,"MMF_SPELL_USES"+IntToString(iSpell2),iSpellCount2);
    if(iSpell3) GuardarIntPersistente(oPC,"MMF_SPELL_USES"+IntToString(iSpell3),iSpellCount3);
}

void OnEnterLoadPolymorphed(object oPC)
{
    if(ObtenerIntPersistente(oPC,"LOGGED_OUT_POLYMORPHED"))
    {
        effect e = GetFirstEffect(oPC);
        int i = FALSE;
        while(GetIsEffectValid(e))
        {
            if(GetStringLeft(GetEffectTag(e),13) == "MDF_POLYMORPH"){ i = TRUE; break;}

            e = GetNextEffect(oPC);
        }
        if(i == FALSE){
            effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
            object oContainer = GetItemPossessedBy(oPC,"dmfi_pc_emote");
            BorrarIntPersistente(oPC,"POLYMORPHED");
            BorrarIntPersistente(oPC,"POLYMORPHED_FORM");
            BorrarIntPersistente(oPC,"POLYMORPH_COUNT");
            BorrarIntPersistente(oPC,"POLYMORPH_COUNT_1");
            BorrarIntPersistente(oPC,"POLYMORPH_COUNT_2");

            DeleteLocalJson(oContainer,"MF_OR_WEAPON");
            BorrarIntPersistente(oPC,"MMF_NO_MERGE_ARMOR");
            LoadOriginalData(oPC);
            LoadOriginalEquipment(oPC);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
            if(ObtenerIntPersistente(oPC,"CRIT_RANGE_MODIFIED") == TRUE) NWNX_Creature_SetCriticalRangeOverride(oPC,-1);
            BorrarIntPersistente(oPC,"CRIT_RANGE_MODIFIED");
            /*effect eFirst = GetFirstEffect(oPC);
            while(GetIsEffectValid(eFirst))
            {
                if(GetEffectTag(eFirst) == "POLY_HP_BONUS" || GetEffectSpellId(eFirst)== 412 || GetEffectTag(eFirst) == "MMF_MOV_SPEED") RemoveEffect(oPC,eFirst);
                eFirst = GetNextEffect(oPC);
            } */
            object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
            object oHelm = GetItemInSlot(INVENTORY_SLOT_HEAD,oPC);
            object oCloak = GetItemInSlot(INVENTORY_SLOT_CLOAK,oPC);

            if(GetIsObjectValid(oArmor)) {WrapNWNX_Creature_RunUnequip(oPC,oArmor); DelayCommand(0.1,WrapNWNX_Creature_RunEquip(oPC,oArmor,INVENTORY_SLOT_CHEST));}
            if(GetIsObjectValid(oHelm))  {WrapNWNX_Creature_RunUnequip(oPC,oHelm);  DelayCommand(0.2,WrapNWNX_Creature_RunEquip(oPC,oHelm,INVENTORY_SLOT_HEAD));}
            if(GetIsObjectValid(oCloak)) {WrapNWNX_Creature_RunUnequip(oPC,oCloak); DelayCommand(0.3,WrapNWNX_Creature_RunEquip(oPC,oCloak,INVENTORY_SLOT_CLOAK));}


        }
        else{
            int iConstant = ObtenerIntPersistente(oPC,"POLYMORPHED_FORM");
            int iSpell1 = StringToInt(Get2DAString(sPoly2DA,"SPELL1",iConstant));
            int iSpell2 = StringToInt(Get2DAString(sPoly2DA,"SPELL2",iConstant));
            int iSpell3 = StringToInt(Get2DAString(sPoly2DA,"SPELL3",iConstant));

            if(iSpell1) AddMDFSpecialAbility(oPC,iSpell1,iConstant,TRUE);
            if(iSpell2) AddMDFSpecialAbility(oPC,iSpell2,iConstant,TRUE);
            if(iSpell3) AddMDFSpecialAbility(oPC,iSpell3,iConstant,TRUE);

            //if(StringToInt(Get2DAString(sPoly2DA,"MergeA",ObtenerIntPersistente(oPC,"POLYMORPHED_FORM"))) == TRUE)
            GuardarIntPersistente(oPC,"LOGGED_OUT_REEQUIP",TRUE);

        }
        BorrarIntPersistente(oPC,"LOGGED_OUT_POLYMORPHED");
    }
}

object CreateItemMergingPropertiesFromTemplate(json jItemTemplate,json jPropertiesListToAdd,object oPC, string sNewTag = "")
{
    json jPropListValue = JsonObjectGet(jPropertiesListToAdd,"value");
    json jPolymorphWepProps = JsonObjectGet(jItemTemplate, "PropertiesList");
    json jPolymorphWepPropsValue = JsonObjectGet(jPolymorphWepProps,"value");
    int iNumberPropertiesPW = JsonGetLength(jPolymorphWepPropsValue);
    int i,j;
    object oItem,oHide;
    for(i = 0; i< JsonGetLength(jPropListValue); i++){
        json jPropertyToAdd = JsonArrayGet(jPropListValue,i);
        int iPropertyToAddPropertyName = JsonGetInt(JsonObjectGet(JsonObjectGet(jPropertyToAdd,"PropertyName"),"value"));
        int iPropertyToAddPropertyValue = JsonGetInt(JsonObjectGet(JsonObjectGet(jPropertyToAdd,"CostValue"),"value"));
        int iPropertyToAddPropertySubtype = JsonGetInt(JsonObjectGet(JsonObjectGet(jPropertyToAdd,"Subtype"),"value"));
        if(iPropertyToAddPropertyName == MMF_ITEM_PROPERTY_USE) continue;
        int iMustAdd = TRUE;
        if(iNumberPropertiesPW > 0 ){

            for(j = 0; j < iNumberPropertiesPW; j++){
                json jOriginalProp = JsonArrayGet(jPolymorphWepPropsValue,j);
                int iPropertyName = JsonGetInt(JsonObjectGet(JsonObjectGet(jOriginalProp,"PropertyName"),"value"));
                int iPropertyValue = JsonGetInt(JsonObjectGet(JsonObjectGet(jOriginalProp,"CostValue"),"value"));
                int iPropertySubtype = JsonGetInt(JsonObjectGet(JsonObjectGet(jOriginalProp,"Subtype"),"value"));
                if(iPropertyToAddPropertyName == iPropertyName) {
                    if(iPropertyToAddPropertyName == MMF_ITEM_PROPERTY_ON_HIT){
                        if(iPropertyToAddPropertySubtype == iPropertySubtype) {
                            iMustAdd = FALSE;
                            continue;
                        }
                    }
                    else{
                        if(iPropertyToAddPropertySubtype == iPropertySubtype && iPropertyToAddPropertyValue <= iPropertyValue) {
                            iMustAdd = FALSE;
                        }
                        else if(iPropertyToAddPropertySubtype == iPropertySubtype && iPropertyToAddPropertyValue > iPropertyValue){
                            jPolymorphWepPropsValue = JsonArraySet(jPolymorphWepPropsValue,j,jPropertyToAdd);
                            iMustAdd = FALSE;
                        }
                    }
                }
            }
        }
        if(iPropertyToAddPropertyName == MMF_ITEM_PROPERTY_KEEN){
            oHide = GetItemPossessedBy(oPC,MMF_TAG_HIDE);
            itemproperty ipImprovedCrit = ItemPropertyBonusFeat(IP_CONST_FEAT_IMPCRITUNARM);
            if(IPGetItemHasProperty(oHide,ipImprovedCrit,-1)) NWNX_Creature_SetCriticalRangeOverride(oPC,18);
            else NWNX_Creature_SetCriticalRangeOverride(oPC,19);
            GuardarIntPersistente(oPC,"CRIT_RANGE_MODIFIED",TRUE);
        }
        if (iMustAdd){
            jPolymorphWepPropsValue = JsonArrayInsert(jPolymorphWepPropsValue,jPropertyToAdd);
        }
    }
    JsonObjectSetInplace(jPolymorphWepProps,"value",jPolymorphWepPropsValue);
    JsonObjectSetInplace(jItemTemplate,"PropertiesList",jPolymorphWepProps);
    oItem = JsonToObject(jItemTemplate,GetLocation(oPC),oPC,TRUE);
    if(sNewTag != "") SetTag(oItem,sNewTag);
    return oItem;
}

object MMF_UpdateObjectCreatureHide(object oCreatureHide,int iMMFLevel,int iPOLYMORPH_CONSTANT)
{
    itemproperty ipProperty;

    if((iPOLYMORPH_CONSTANT == MDF_RACIALTYPE_DROW ||
             iPOLYMORPH_CONSTANT == MDF_RACIALTYPE_DRIDER)&& iMMFLevel >= 10)
    {
        ipProperty = ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_26);
        IPSafeAddItemProperty(oCreatureHide,ipProperty,0.0,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);
    }
    return oCreatureHide;
}

void EffectMDFPolymorph(object oPC,int iPOLYMORPH_CONSTANT)
{

    int iMMFLevel = GetLevelByClass(63,oPC);
    struct LevelBuffs stcLevelBuffs = MMF_GetRaceBuffLevel(iPOLYMORPH_CONSTANT,iMMFLevel);
    int iAppareance = ObtenerIntPersistente(oPC,IntToString(iPOLYMORPH_CONSTANT));
    if(iAppareance == 0) iAppareance = StringToInt(Get2DAString(sPoly2DA,"AppearanceType",iPOLYMORPH_CONSTANT));
    if(iPOLYMORPH_CONSTANT == MDF_RACIALTYPE_DUERGAR && ObtenerIntPersistente(oPC,"MMF_DINAMIC_DWARF")) iAppareance = 0;
    else BorrarIntPersistente(oPC,"MMF_DINAMIC_DWARF");
    int iRacialType = StringToInt(Get2DAString(sPoly2DA,"RacialType",iPOLYMORPH_CONSTANT));
    int iPortraitId = ObtenerIntPersistente(oPC,IntToString(iPOLYMORPH_CONSTANT)+"portrait");
    if(iPortraitId == 0) iPortraitId = StringToInt(Get2DAString(sPoly2DA,"PortraitId",iPOLYMORPH_CONSTANT));
    //string sPortrait = Get2DAString(sPoly2DA,"Portrait",iPOLYMORPH_CONSTANT);
    string sCreatureWeapon1 = Get2DAString(sPoly2DA,"CreatureWeapon1",iPOLYMORPH_CONSTANT);
    //string sCreatureWeapon2 = Get2DAString(sPoly2DA,"CreatureWeapon2",iPOLYMORPH_CONSTANT);
    string sCreatureWeapon3 = Get2DAString(sPoly2DA,"CreatureWeapon3",iPOLYMORPH_CONSTANT);
    string sHideItem = Get2DAString(sPoly2DA,"HideItem",iPOLYMORPH_CONSTANT);
    string sEquipped = Get2DAString(sPoly2DA,"EQUIPPED",iPOLYMORPH_CONSTANT);
    int iSTR = StringToInt(Get2DAString(sPoly2DA,"STR",iPOLYMORPH_CONSTANT)) + stcLevelBuffs.iSTR;
    int iCON = StringToInt(Get2DAString(sPoly2DA,"CON",iPOLYMORPH_CONSTANT)) + stcLevelBuffs.iCON;
    int iDEX = StringToInt(Get2DAString(sPoly2DA,"DEX",iPOLYMORPH_CONSTANT)) + stcLevelBuffs.iDEX;
    int iNATURALACBONUS = StringToInt(Get2DAString(sPoly2DA,"NATURALACBONUS",iPOLYMORPH_CONSTANT)) + stcLevelBuffs.iCA;
    int iHPBONUS = StringToInt(Get2DAString(sPoly2DA,"HPBONUS",iPOLYMORPH_CONSTANT));
    int iSoundSet = StringToInt(Get2DAString(sPoly2DA,"SoundSet",iPOLYMORPH_CONSTANT));
    int iSPELL1 = StringToInt(Get2DAString(sPoly2DA,"SPELL1",iPOLYMORPH_CONSTANT));
    int iSPELL2 = StringToInt(Get2DAString(sPoly2DA,"SPELL2",iPOLYMORPH_CONSTANT));
    int iSPELL3 = StringToInt(Get2DAString(sPoly2DA,"SPELL3",iPOLYMORPH_CONSTANT));
    int iMergeW = StringToInt(Get2DAString(sPoly2DA,"MergeW",iPOLYMORPH_CONSTANT));
    int iMergeA = StringToInt(Get2DAString(sPoly2DA,"MergeA",iPOLYMORPH_CONSTANT));
    int iConstant = ObtenerIntPersistente(oPC,"POLYMORPHED_FORM");
    int iSpell1Old = StringToInt(Get2DAString(sPoly2DA,"SPELL1",iConstant));
    int iSpell2Old = StringToInt(Get2DAString(sPoly2DA,"SPELL2",iConstant));
    int iSpell3Old = StringToInt(Get2DAString(sPoly2DA,"SPELL3",iConstant));
    if(iSpell1Old) BorrarIntPersistente(oPC,"MMF_SPELL_USES"+IntToString(iSpell1Old));
    if(iSpell2Old) BorrarIntPersistente(oPC,"MMF_SPELL_USES"+IntToString(iSpell2Old));
    if(iSpell3Old) BorrarIntPersistente(oPC,"MMF_SPELL_USES"+IntToString(iSpell3Old));


    object oContainer = GetItemPossessedBy(oPC,CONTENEDOR_VARIABLES);
    int i;
    object oItem;

    SetGender(oPC,ObtenerIntPersistente(oPC,"ORIGINAL_GENDER"));

    if(ObtenerIntPersistente(oPC,"GENDER_RELATED"+IntToString(iPOLYMORPH_CONSTANT)))
    {
        GuardarIntPersistente(oPC,"ORIGINAL_GENDER",GetGender(oPC));
        SetGender(oPC,ObtenerIntPersistente(oPC,"FORM_GENDER"+IntToString(iPOLYMORPH_CONSTANT)));
        SetColor(oPC,COLOR_CHANNEL_SKIN,134);
        SetColor(oPC,COLOR_CHANNEL_HAIR,62);
    }
    else BorrarIntPersistente(oPC,"ORIGINAL_GENDER");


    SetCreatureAppearanceType(oPC,iAppareance);
    NWNX_Creature_SetRacialType(oPC,iRacialType);
    SetPortraitId(oPC,iPortraitId);

    //SetPortraitResRef(oPC,GetSubString(sPortrait,3,20));
    NWNX_Creature_SetRawAbilityScore(oPC,ABILITY_STRENGTH,iSTR);
    NWNX_Creature_SetRawAbilityScore(oPC,ABILITY_CONSTITUTION,iCON);
    NWNX_Creature_SetRawAbilityScore(oPC,ABILITY_DEXTERITY,iDEX);
    NWNX_Creature_SetBaseAC(oPC,iNATURALACBONUS);

    SetSoundset(oPC,iSoundSet);
    BorrarIntPersistente(oPC,"MMF_NO_MERGE_ARMOR");
    if(ObtenerIntPersistente(oPC,"POLYMORPHED")){
        RemoveAllMDFSpecialAbility(oPC);
        effect eFirst = GetFirstEffect(oPC);
        while(GetIsEffectValid(eFirst))
        {
            if(GetEffectTag(eFirst) == "POLY_HP_BONUS" || GetEffectSpellId(eFirst)== 412 || GetEffectTag(eFirst) == "MMF_MOV_SPEED") RemoveEffect(oPC,eFirst);
            eFirst = GetNextEffect(oPC);
        }
    }
    if(iHPBONUS > 0)
    {
        effect eHPBonus = EffectTemporaryHitpoints(iHPBONUS);
        eHPBonus = TagEffect(eHPBonus,"POLY_HP_BONUS");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,eHPBonus,oPC);
    }
    if(iPOLYMORPH_CONSTANT == MDF_RACIALTYPE_SATYR)
    {
        effect eMovementSpeed = EffectMovementSpeedIncrease(30);
        eMovementSpeed = TagEffect(eMovementSpeed,"MMF_MOV_SPEED");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,eMovementSpeed,oPC);
    }
    else if(iPOLYMORPH_CONSTANT == MDF_RACIALTYPE_CENTAUR || iPOLYMORPH_CONSTANT == MDF_RACIALTYPE_STINGER)
    {
        effect eMovementSpeed = EffectMovementSpeedIncrease(35);
        eMovementSpeed = TagEffect(eMovementSpeed,"MMF_MOV_SPEED");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,eMovementSpeed,oPC);
    }
    if(iPOLYMORPH_CONSTANT == MDF_RACIALTYPE_ENT)
    {
        effect eMovementSpeed = EffectMovementSpeedDecrease(20);
        eMovementSpeed = TagEffect(eMovementSpeed,"MMF_MOV_SPEED");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,eMovementSpeed,oPC);
    }


    oItem = GetItemPossessedBy(oPC,MMF_TAG_CW1);
    if(GetIsObjectValid(oItem)) DestroyObject(oItem);
    oItem = GetItemPossessedBy(oPC,MMF_TAG_CW2);
    if(GetIsObjectValid(oItem)) DestroyObject(oItem);
    oItem = GetItemPossessedBy(oPC,MMF_TAG_CW3);
    if(GetIsObjectValid(oItem)) DestroyObject(oItem);
    oItem = GetItemPossessedBy(oPC,MMF_TAG_HIDE);
    if(GetIsObjectValid(oItem)) DestroyObject(oItem);
    oItem = GetItemPossessedBy(oPC,MMF_TAG_EW);
    if(GetIsObjectValid(oItem)) DestroyObject(oItem);

    if(iSPELL1 != 0) AddMDFSpecialAbility(oPC,iSPELL1,iPOLYMORPH_CONSTANT);
    if(iSPELL2 != 0) AddMDFSpecialAbility(oPC,iSPELL2,iPOLYMORPH_CONSTANT);
    if(iSPELL3 != 0) AddMDFSpecialAbility(oPC,iSPELL3,iPOLYMORPH_CONSTANT);

    json jCreatureHide  = TemplateToJson(sHideItem,RESTYPE_UTI);
    json jCreatureItem1 = TemplateToJson(sCreatureWeapon1,RESTYPE_UTI);
    json jCreatureItem3 = TemplateToJson(sCreatureWeapon3,RESTYPE_UTI);
    object oCreatureHide, oCreatureItem1,oCreatureItem3;



    oCreatureHide = JsonToObject(jCreatureHide,GetLocation(oPC),oPC,TRUE);
    oCreatureHide = MMF_UpdateObjectCreatureHide(oCreatureHide,iMMFLevel,iPOLYMORPH_CONSTANT);
    SetTag(oCreatureHide,MMF_TAG_HIDE);

    if(JsonGetType(jCreatureItem1) != JSON_TYPE_NULL ){
        json jProperties = GetLocalJson(oContainer,"MF_OR_WEAPON");
        oCreatureItem1 = CreateItemMergingPropertiesFromTemplate(jCreatureItem1,jProperties,oPC,MMF_TAG_CW1);
    }
    else  if(JsonGetType(jCreatureItem3) != JSON_TYPE_NULL ){
        json jProperties = GetLocalJson(oContainer,"MF_OR_WEAPON");
        oCreatureItem3 = CreateItemMergingPropertiesFromTemplate(jCreatureItem3,jProperties,oPC,MMF_TAG_CW3);
    }

    if(GetIsObjectValid(oCreatureHide)){
        SetIdentified(oCreatureHide,TRUE);
        NWNX_Item_SetMinEquipLevelOverride(oCreatureHide,1,TRUE);
        NWNX_Creature_RunEquip(oPC,oCreatureHide,INVENTORY_SLOT_CARMOUR);
    }

    if(GetIsObjectValid(oCreatureItem1)){
        SetIdentified(oCreatureItem1,TRUE);
        NWNX_Item_SetMinEquipLevelOverride(oCreatureItem1,1,TRUE);
        NWNX_Creature_RunEquip(oPC,oCreatureItem1,INVENTORY_SLOT_CWEAPON_L);
    }
    else if(GetIsObjectValid(oCreatureItem3)){
        NWNX_Item_SetMinEquipLevelOverride(oCreatureItem3,1,TRUE);
        SetIdentified(oCreatureItem3,TRUE);
        NWNX_Creature_RunEquip(oPC,oCreatureItem3,INVENTORY_SLOT_CWEAPON_B);
    }

    if(!iMergeA) GuardarIntPersistente(oPC,"MMF_NO_MERGE_ARMOR",TRUE);
    else BorrarIntPersistente(oPC,"MMF_NO_MERGE_ARMOR");

    struct ChNameDesc N_D = MMF_GetNameAndDescription(iPOLYMORPH_CONSTANT);

    GuardarStringPersistente(oPC,"Disfrazado_nombre",N_D.sName);
    PB_Disguise_SetNameOverride(oPC, N_D.sName, NWNX_RENAME_PLAYERNAME_OVERRIDE);
    SetDescription(oPC,N_D.sDescription);
}

void StoreOriginalData(object oPC, int iConstant)
{
    if(ObtenerIntPersistente(oPC,"POLYMORPHED")) return;

    int iAppareance = GetAppearanceType(oPC);
    int iRacialType = GetRacialType(oPC);
    int iPortraitId = GetPortraitId(oPC);
    string sPortrait = GetPortraitResRef(oPC);
    string sName = PB_Disguise_GetNameOverride(oPC);
    string sDescription = GetDescription(oPC);

    int iSTR = NWNX_Creature_GetRawAbilityScore(oPC,ABILITY_STRENGTH);
    int iCON = NWNX_Creature_GetRawAbilityScore(oPC,ABILITY_CONSTITUTION);
    int iDEX = NWNX_Creature_GetRawAbilityScore(oPC,ABILITY_DEXTERITY);
    int iBaseAC = NWNX_Creature_GetBaseAC(oPC);
    int iSoundSet = GetSoundset(oPC);
    int iHairColor = GetColor(oPC,COLOR_CHANNEL_HAIR);
    int iSkinColor = GetColor(oPC,COLOR_CHANNEL_SKIN);
    int iGender = GetGender(oPC);

    json jOldData = JsonObject();
    jOldData = JsonObjectSet(jOldData,"Appareance",JsonInt(iAppareance));
    jOldData = JsonObjectSet(jOldData,"RacialType",JsonInt(iRacialType));
    jOldData = JsonObjectSet(jOldData,"PortraitId",JsonInt(iPortraitId));
    jOldData = JsonObjectSet(jOldData,"Portrait",JsonString(sPortrait)) ;
    jOldData = JsonObjectSet(jOldData,"Name",JsonString(sName)) ;
    jOldData = JsonObjectSet(jOldData,"Description",JsonString(sDescription)) ;
    jOldData = JsonObjectSet(jOldData,"STR",JsonInt(iSTR));
    jOldData = JsonObjectSet(jOldData,"CON",JsonInt(iCON));
    jOldData = JsonObjectSet(jOldData,"DEX",JsonInt(iDEX));
    jOldData = JsonObjectSet(jOldData,"BaseAC",JsonInt(iBaseAC));
    jOldData = JsonObjectSet(jOldData,"SoundSet",JsonInt(iSoundSet));
    jOldData = JsonObjectSet(jOldData,"SkinColor",JsonInt(iSkinColor));
    jOldData = JsonObjectSet(jOldData,"HairColor",JsonInt(iHairColor));
    jOldData = JsonObjectSet(jOldData,"Gender",JsonInt(iGender));

    object oContainer = GetItemPossessedBy(oPC,CONTENEDOR_VARIABLES);
    SetLocalJson(oContainer,"OLD_DATA",jOldData);


}

void SaveEquippedItems(object oPC, object oContainer, int iMergeW,int SkipCreatureItems = FALSE)
{
    object oItem;
    int i;
    json jOldEquipment = JsonObject();
    /////////////
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
    object oWeapon2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
    if(GetIsObjectValid(oWeapon))
    {

        if(iMergeW == TRUE)
        {
            json jProperties = JsonObjectGet(ObjectToJson(oWeapon),"PropertiesList");
            SetLocalJson(oContainer,"MF_OR_WEAPON",jProperties);
            SetLocalInt(oWeapon,"INVENTORY_SLOT",INVENTORY_SLOT_RIGHTHAND);
            jOldEquipment = JsonObjectSet(jOldEquipment,IntToString(INVENTORY_SLOT_RIGHTHAND),ObjectToJson(oWeapon,TRUE));
            SetLocalInt(oPC,"MMF_WEAPON_DELETE",TRUE);
            DelayCommand(0.5,DeleteLocalInt(oPC,"MMF_WEAPON_DELETE"));
            if(GetIsObjectValid(oWeapon2)) WrapNWNX_Creature_RunUnequip(oPC,oWeapon2);
            DestroyObject(oWeapon);
        }
        else
        {
            DelayCommand(0.2, WrapNWNX_Creature_RunEquip(oPC,oWeapon,INVENTORY_SLOT_RIGHTHAND));
            if(GetIsObjectValid(oWeapon2)){
                DelayCommand(0.2,WrapNWNX_Creature_RunEquip(oPC,oWeapon2,INVENTORY_SLOT_LEFTHAND));
            }
        }
    }


    for(i = 14; i < 18; i++)
    {
        oItem = GetItemInSlot(i,oPC);
        if(GetIsObjectValid(oItem)){
            SetLocalInt(oItem,"INVENTORY_SLOT",i);

            if (SkipCreatureItems && i >= 14) continue;
            jOldEquipment = JsonObjectSet(jOldEquipment,IntToString(i),ObjectToJson(oItem,TRUE));
            DestroyObject(oItem);
        }
    }
    SetLocalJson(oContainer,"OLD_EQUIPMENT",jOldEquipment);
}

void StoreOriginalEquipment(object oPC, int iPOLYMORPH_CONSTANT)
{
    int iMergeW = StringToInt(Get2DAString(sPoly2DA,"MergeW",iPOLYMORPH_CONSTANT));
    int iMergeA = StringToInt(Get2DAString(sPoly2DA,"MergeA",iPOLYMORPH_CONSTANT));
    object oContainer = GetItemPossessedBy(oPC,CONTENEDOR_VARIABLES);
    object oItem;
    json jOldEquipment;
    PrintString("Running StoreOriginalEquipment function");
    if(ObtenerIntPersistente(oPC,"POLYMORPHED")){
        PrintString("Is polymorphed");
        jOldEquipment = GetLocalJson(oContainer,"OLD_EQUIPMENT");
        if(iMergeW == TRUE && JsonGetType(GetLocalJson(oContainer,"ME_OR_WEAPON")) == JSON_TYPE_NULL)
        {
            PrintString("iMergeW = TRUE and JSON_TYPE_NULL");
            oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
            if(GetIsObjectValid(oItem)){
                PrintString("Player has valid Weapon");
                MMF_RemoveIP(oItem);
                SetLocalInt(oItem,"INVENTORY_SLOT",INVENTORY_SLOT_RIGHTHAND);
                json jProperties = JsonObjectGet(ObjectToJson(oItem),"PropertiesList");
                SetLocalJson(oContainer,"MF_OR_WEAPON",jProperties);
                jOldEquipment = JsonObjectSet(jOldEquipment,IntToString(INVENTORY_SLOT_RIGHTHAND),ObjectToJson(oItem,TRUE));
                SetLocalJson(oContainer,"OLD_EQUIPMENT",jOldEquipment);
                SetLocalInt(oPC,"MMF_WEAPON_DELETE",TRUE);
                DelayCommand(0.5,DeleteLocalInt(oPC,"MMF_WEAPON_DELETE"));
                DestroyObject(oItem);
            }
        }
        else if(iMergeW == FALSE)
        {
            oItem = JsonToObject(JsonObjectGet(jOldEquipment,IntToString(INVENTORY_SLOT_RIGHTHAND)),GetLocation(oPC),oPC,TRUE);
            PrintString("iMergeW = FALSE");
            if(GetIsObjectValid(oItem))
            {
                DelayCommand(0.2,WrapNWNX_Creature_RunEquip(oPC,oItem,GetLocalInt(oItem,"INVENTORY_SLOT")));
                DeleteLocalJson(oContainer,"MF_OR_WEAPON");
                jOldEquipment = JsonObjectDel(jOldEquipment,"4");
                SetLocalJson(oContainer,"OLD_EQUIPMENT",jOldEquipment);
            }
            else
            {
                object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
                if(GetIsObjectValid(oItem)) NWNX_Creature_RunEquip(oPC,oWeapon,INVENTORY_SLOT_RIGHTHAND);
            }
        }

        /*if (!ObtenerIntPersistente(oPC,"MMF_NO_MERGE_ARMOR") && !iMergeA){
            SaveEquippedItems(oPC,oContainer,iMergeW,TRUE);
        }*/

        return;
    }

    SaveEquippedItems(oPC,oContainer,iMergeW,TRUE);

    PrintString("End StoreOriginalEquipment function");
}

void LoadOriginalData(object oPC)
{
    object oContainer = GetItemPossessedBy(oPC,CONTENEDOR_VARIABLES);
    json jOldData = GetLocalJson(oContainer,"OLD_DATA");

    int iAppareance = JsonGetInt(JsonObjectGet(jOldData,"Appareance"));
    int iRacialType = JsonGetInt(JsonObjectGet(jOldData,"RacialType"));
    int iPortraitId = JsonGetInt(JsonObjectGet(jOldData,"PortraitId"));
    string sPortrait = JsonGetString(JsonObjectGet(jOldData,"Portrait"));
    string sName = JsonGetString(JsonObjectGet(jOldData,"Name"));
    string sDescription = JsonGetString(JsonObjectGet(jOldData,"Description"));
    int iSTR = JsonGetInt(JsonObjectGet(jOldData,"STR"));
    int iCON = JsonGetInt(JsonObjectGet(jOldData,"CON"));
    int iDEX = JsonGetInt(JsonObjectGet(jOldData,"DEX"));
    int iBaseAC = JsonGetInt(JsonObjectGet(jOldData,"BaseAC"));
    int iSoundSet = JsonGetInt(JsonObjectGet(jOldData,"SoundSet"));
    int iHairColor = JsonGetInt(JsonObjectGet(jOldData,"HairColor"));
    int iSkinColor = JsonGetInt(JsonObjectGet(jOldData,"SkinColor"));
    int iGender = JsonGetInt(JsonObjectGet(jOldData,"Gender"));
    SetGender(oPC,iGender);
    SetCreatureAppearanceType(oPC,iAppareance);
    NWNX_Creature_SetRacialType(oPC,iRacialType);
    SetPortraitResRef(oPC,sPortrait);
    NWNX_Creature_SetRawAbilityScore(oPC,ABILITY_STRENGTH,iSTR);
    NWNX_Creature_SetRawAbilityScore(oPC,ABILITY_CONSTITUTION,iCON);
    NWNX_Creature_SetRawAbilityScore(oPC,ABILITY_DEXTERITY,iDEX);
    NWNX_Creature_SetBaseAC(oPC,iBaseAC);
    SetSoundset(oPC,iSoundSet);

    GuardarStringPersistente(oPC,"Disfrazado_nombre",sName);
    PB_Disguise_SetNameOverride(oPC, sName, NWNX_RENAME_PLAYERNAME_OVERRIDE);
    SetDescription(oPC,sDescription);
    SetColor(oPC,COLOR_CHANNEL_HAIR,iHairColor);
    SetColor(oPC,COLOR_CHANNEL_SKIN,iSkinColor);

}

void LoadOriginalEquipment(object oPC)
{
    object oContainer = GetItemPossessedBy(oPC,CONTENEDOR_VARIABLES);
    json jOldEquipment = GetLocalJson(oContainer,"OLD_EQUIPMENT");

    json jOldEquipmentKeys = JsonObjectKeys(jOldEquipment);
    int iLenght = JsonGetLength(jOldEquipmentKeys);
    json jKey;
    object oItem;
    int i;

    /*oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
    if(GetIsObjectValid(oItem)) {
        DelayCommand(0.5,WrapNWNX_Creature_RunEquip(oPC,oItem,INVENTORY_SLOT_RIGHTHAND));
    }*/
    for( i = 0; i< iLenght;i++)
    {
        jKey = JsonArrayGet(jOldEquipmentKeys,i);
        oItem = JsonToObject(JsonObjectGet(jOldEquipment,JsonGetString(jKey)),GetLocation(oPC),oPC,TRUE);
        if(GetIsObjectValid(oItem))
        {
            NWNX_Creature_RunUnequip(oPC,oItem);
            NWNX_Creature_RunEquip(oPC,oItem,GetLocalInt(oItem,"INVENTORY_SLOT"));
        }

    }
    DestroyObject(GetItemPossessedBy(oPC,MMF_TAG_HIDE));
    DestroyObject(GetItemPossessedBy(oPC,MMF_TAG_CW1));
    DestroyObject(GetItemPossessedBy(oPC,MMF_TAG_CW2));
    DestroyObject(GetItemPossessedBy(oPC,MMF_TAG_CW3));
    DestroyObject(GetItemPossessedBy(oPC,MMF_TAG_EW));
    DeleteLocalJson(oContainer,"OLD_EQUIPMENT");
}


