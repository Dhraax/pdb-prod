#include "pb_fecha_inc"
#include "mti_subrazas_inc"
#include "inc_sqlite_time"
#include "pb_constantes"
#include "lib_race"

void main()
{
    object oPC = GetEnteringObject();
    string sSubraza = GetStringLowerCase(GetSubRace(oPC));

    // Resucitamos y curamos al PJ (porsiaca, que a veces el script de vida
    // persistente mata a pjs nuevos si ya hubieron otros pjs con el mismo nombre)
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPC);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(50), oPC);

    // DARLE UNA CANTIDAD INICIAL DE ORO, DARLE UNA ESTERILLA O SARCOFAGO,
    // DARLE UNA RACION DE COMIDA Y SUBIRLE DE NIVEL
    AssignCommand(oPC, TakeGoldFromCreature(GetGold(oPC), oPC, TRUE));
    AssignCommand(oPC, DelayCommand(2.0, GiveGoldToCreature(oPC, 35000)));
    CreateItemOnObject("FoodRation", oPC);
    SetXP(oPC, 10000); //1000

    // VARITAS Y HABILIDADES DEL JUGADOR
    // Contenedor de variables
    CreateItemOnObject("dmfi_pc_emote", oPC);

    // Dar la habilidad de curacion
    CreateItemOnObject("healability", oPC);

    // Dar habilidad foco divino
    if(GetLevelByClass(CLASS_TYPE_CLERIC, oPC) > 0 ||
     GetLevelByClass(CLASS_TYPE_FAVORED_SOUL, oPC) > 0 ||
     GetLevelByClass(CLASS_TYPE_DRUID, oPC) > 0  ||
     GetLevelByClass(CLASS_TYPE_PALADIN, oPC) > 0) CreateItemOnObject("mti_elegfoco", oPC);

    // Dar libro de convocaciones
    if(GetLevelByClass(CLASS_TYPE_SORCERER, oPC) > 0 ||
     GetLevelByClass(CLASS_TYPE_WIZARD, oPC) > 0   ||
     GetLevelByClass(CLASS_TYPE_CLERIC, oPC) > 0   ||
     GetLevelByClass(CLASS_TYPE_DRUID, oPC) > 0    ||
     GetLevelByClass(CLASS_TYPE_WARLOCK, oPC) > 0    ||
     GetLevelByClass(CLASS_TYPE_FAVORED_SOUL, oPC) > 0    ||
     GetLevelByClass(CLASS_TYPE_BARD, oPC) > 0) CreateItemOnObject("librodeconvocaci", oPC);

    //Dar Item de Invocaciones Brujo
    if(GetLevelByClass(57, oPC) > 0) CreateItemOnObject("invocaciones", oPC);

    // FUNCIONES DE SUBRAZAS
    if(GetSubRace(oPC) == "") AplicarNombreRazaBase(oPC);

    // GUARDAR FECHA DE CREACION

    GuardarIntPersistente(oPC, "PB_FECHA_CREACION", SQLite_GetTimeStamp());

    //GUARDAR FENOTIPO INICIAL DEL PERSONAJE.
    GuardarIntPersistente(oPC, "Q_BASE_PHENOTYPE", GetPhenoType(oPC));

    //Ponemos a todos los PJs los tamaños mínimos de sus razas, para que salgan ajustaditos desde 0.
    float fAltura = PB_Race_TamanoMinimo(oPC);
    GuardarIntPersistente(oPC, "CAB_ALTURA", TRUE);
    GuardarFloatPersistente(oPC, "IND_ALTURA", fAltura);
    SetObjectVisualTransform(oPC, OBJECT_VISUAL_TRANSFORM_SCALE, fAltura);
}
