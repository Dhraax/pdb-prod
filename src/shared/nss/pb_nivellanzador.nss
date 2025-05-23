#include "x2_inc_switches"
#include "nwnx_creature"
#include "pb_constantes"
#include "inc_sqlite_time"

//Tipo daño Archimago
int ChangedElementalDamage(object oCaster, int nDamageType);

//Llamamos al script de modificaciones de tiradas de Salvacion CDs
int GetChangesToSaveDC(object oCharacter = OBJECT_SELF);

// Esta funciónn devuelve el nivel de lanzador en aquellas clases de prestigio
// que no ganan nivel de lanzador en todos sus niveles para oCharacter.
int GetSpecialCasterLevel(int iClassType, object oCharacter = OBJECT_SELF);

// Devuelve el nivel de lanzador basado en clases
int GetCL(object oCharacter = OBJECT_SELF);

// Devuelve el nivel de lanzador tomando el ultimo hechizo utilizado. Si iDotes se pone en FALSE, la función no tendrá en cuenta las Dotes/Bonos al Lanzador de Conjuros.
int GetTotalCasterLevel(object oCharacter = OBJECT_SELF, int iBaseClass = 255, int Dotes = TRUE);

//Devuelve el nivel de conjuro máximo que puede lanzar una clase. Si iDotes se pone en FALSE, la función no tendrá en cuenta las Dotes/Bonos al Lanzador de Conjuros.
int GetCasterMaxSpellLevel(int nClass, object oCaster = OBJECT_SELF, int iDotes = TRUE);

int GetSpecialCasterLevel(int iClassType, object oCharacter = OBJECT_SELF)
{
    float fCasterLevel = IntToFloat(GetLevelByClass(iClassType, oCharacter));
    int iCasterLevel;

    switch(iClassType)
    {
        // el maestro de la lividez gana niveles de lanzador en todos los niveles
        // menos en el primero
        case CLASS_TYPE_PALEMASTER:
            fCasterLevel = fCasterLevel-1;
            break;

        // el caballero arcano gana niveles de lanzador en todos los niveles
        // menos en el primero
        case CLASS_TYPE_CABALLERO_ARCANO:
            fCasterLevel = fCasterLevel-1;
            break;

       // el adepto sombrio gana niveles de lanzador en todos los niveles
        case CLASS_TYPE_SHADOW_ADEPT:
            fCasterLevel = fCasterLevel;
            break;

       // el adepto sombrio gana niveles de lanzador en todos los niveles
        case CLASS_TYPE_SHADOW_ADEPT_DIVINE:
            fCasterLevel = fCasterLevel;
            break;

       // el archimago gana niveles de lanzador en todos los niveles
        case CLASS_TYPE_ARCHMAGE:
            fCasterLevel = fCasterLevel;
            break;

       // El terugo mistico gana niveles de lanzador en todos los niveles
        case CLASS_TYPE_TEURGO_MIST:
            fCasterLevel = fCasterLevel;
            break;

        case CLASS_TYPE_BLIGHTER:
            fCasterLevel = fCasterLevel;
            break;

        case CLASS_TYPE_HARPER:
            fCasterLevel = fCasterLevel-1;
            break;

        case CLASS_TYPE_HARPER_DIVINE:
            fCasterLevel = fCasterLevel-1;
            break;

        case CLASS_TYPE_WARLOCK:
            fCasterLevel = fCasterLevel;
            break;

        case CLASS_TYPE_FAVORED_SOUL:
            fCasterLevel = fCasterLevel;
            break;

        case CLASS_TYPE_SOLDIER_OF_LIGHT:
            fCasterLevel = fCasterLevel;
            break;

        case CLASS_TYPE_ASSASSIN:
            fCasterLevel = fCasterLevel;
            break;

        // por defecto asumimos que una clase de prestigio extraï¿½a recibe
        // la mitad de nivel de lanzador que sus niveles de clase

        default:
            fCasterLevel = (fCasterLevel/2)+0.5;
    }

    iCasterLevel = FloatToInt(fCasterLevel);
    return iCasterLevel;
}

int GetTotalCasterLevel(object oCharacter = OBJECT_SELF, int iBaseClass = CLASS_TYPE_INVALID, int Dotes = TRUE)
{
    int iCasterLevel;
    int iDG = GetHitDice(oCharacter);
    int nSpellPowerLevels = 0; //Poder Conjuro Archimago

    // Si el conjuro no se ha lanzado a través de un objeto y no se ha especificado una clase lanzadora
    if (!GetIsObjectValid(GetSpellCastItem()) && iBaseClass == CLASS_TYPE_INVALID)
    {
        // PARCHE: Detección de lanzamiento de invocaciones del Brujo
        int nSpellFeatId = GetSpellFeatId();
        if (nSpellFeatId != -1 && StringToInt(Get2DAString("feat", "MinLevelClass", nSpellFeatId)) == CLASS_TYPE_WARLOCK)
        {
            iBaseClass = CLASS_TYPE_WARLOCK;
        }

        if (nSpellFeatId != -1 && StringToInt(Get2DAString("feat", "MinLevelClass", nSpellFeatId)) == CLASS_TYPE_INGENIERO)
        {
            iBaseClass = CLASS_TYPE_INGENIERO;
        }

        // Si no se ha especificado ninguna clase lanzadora, obtener última clase lanzadora
        if (iBaseClass == CLASS_TYPE_INVALID) {
            iBaseClass = GetLastSpellCastClass();
        }
    }

    iCasterLevel = GetLevelByClass(iBaseClass, oCharacter);

    /* Poder Conjuro Archimago */
    if (GetHasFeat(FEAT_SPELL_POWER_V, oCharacter))  { nSpellPowerLevels = 5;  }
    else if (GetHasFeat(FEAT_SPELL_POWER_IV, oCharacter)) { nSpellPowerLevels = 4;  }
    else if (GetHasFeat(FEAT_SPELL_POWER_III, oCharacter)) {  nSpellPowerLevels = 3;  }
    else if (GetHasFeat(FEAT_SPELL_POWER_II, oCharacter)) { nSpellPowerLevels = 2;    }
    else if (GetHasFeat(FEAT_SPELL_POWER_I, oCharacter)) { nSpellPowerLevels = 1;  }


    switch(iBaseClass)
    {
        case CLASS_TYPE_CLERIC:
            //iCasterLevel = GetCasterLevel(oCharacter);
            if(GetLevelByClass(CLASS_TYPE_TEURGO_MIST,oCharacter)>0){
                iCasterLevel += GetSpecialCasterLevel(CLASS_TYPE_TEURGO_MIST,oCharacter);
            }
            if(GetLevelByClass(CLASS_TYPE_ORCUS,oCharacter)>0){
                iCasterLevel += GetLevelByClass(CLASS_TYPE_ORCUS,oCharacter);
            }
            if(GetLevelByClass(CLASS_TYPE_HARPER_DIVINE,oCharacter)>0){
                iCasterLevel += GetSpecialCasterLevel(CLASS_TYPE_HARPER_DIVINE,oCharacter);
            }
            if(GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT_DIVINE,oCharacter)>0){
                iCasterLevel += GetSpecialCasterLevel(CLASS_TYPE_SHADOW_ADEPT_DIVINE,oCharacter);
            }
            break;

        case CLASS_TYPE_DRUID:
            //iCasterLevel = GetCasterLevel(oCharacter);
            if(GetLevelByClass(CLASS_TYPE_TEURGO_MIST,oCharacter)>0){
                iCasterLevel += GetSpecialCasterLevel(CLASS_TYPE_TEURGO_MIST,oCharacter);
            }
            break;

        case CLASS_TYPE_RANGER:
            //iCasterLevel = GetCasterLevel(oCharacter);
            break;

        case CLASS_TYPE_PALADIN:
            //iCasterLevel = GetCasterLevel(oCharacter);
            break;

        case CLASS_TYPE_PAL_ANTIGUO:
            //iCasterLevel = GetCasterLevel(oCharacter);
            break;

        case CLASS_TYPE_PAL_OSCURO:
            //iCasterLevel = GetCasterLevel(oCharacter);
            break;

        case CLASS_TYPE_PAL_VENGADOR:
            //iCasterLevel = GetCasterLevel(oCharacter);
            break;

        case CLASS_TYPE_BARD:
            //iCasterLevel = GetCasterLevel(oCharacter);
            if(GetLevelByClass(CLASS_TYPE_PALEMASTER,oCharacter)>0){
                iCasterLevel += GetSpecialCasterLevel(CLASS_TYPE_PALEMASTER, oCharacter);
            }
            if(GetLevelByClass(CLASS_TYPE_BRIBON_ARCANO,oCharacter)>0){
                iCasterLevel += GetLevelByClass(CLASS_TYPE_BRIBON_ARCANO,oCharacter);
            }

            if(GetLevelByClass(CLASS_TYPE_CABALLERO_ARCANO,oCharacter)>0){
                iCasterLevel += GetSpecialCasterLevel(CLASS_TYPE_CABALLERO_ARCANO,oCharacter);
            }
            if(GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT,oCharacter)>0){
                iCasterLevel += GetSpecialCasterLevel(CLASS_TYPE_SHADOW_ADEPT,oCharacter);
            }
            break;

        case CLASS_TYPE_SORCERER:
            //iCasterLevel = GetCasterLevel(oCharacter);
            if(GetLevelByClass(CLASS_TYPE_PALEMASTER,oCharacter)>0){
                iCasterLevel += GetSpecialCasterLevel(CLASS_TYPE_PALEMASTER, oCharacter);
            }
            if(GetLevelByClass(CLASS_TYPE_BRIBON_ARCANO,oCharacter)>0){
                iCasterLevel += GetLevelByClass(CLASS_TYPE_BRIBON_ARCANO,oCharacter);
            }
            if(GetLevelByClass(CLASS_TYPE_CABALLERO_ARCANO,oCharacter)>0){
                iCasterLevel += GetSpecialCasterLevel(CLASS_TYPE_CABALLERO_ARCANO,oCharacter);
            }
            if(GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT,oCharacter)>0){
                iCasterLevel += GetSpecialCasterLevel(CLASS_TYPE_SHADOW_ADEPT,oCharacter);
            }
            if(GetLevelByClass(CLASS_TYPE_ARCHMAGE,oCharacter)>0){
                iCasterLevel += GetSpecialCasterLevel(CLASS_TYPE_ARCHMAGE,oCharacter);
            }
            if(GetLevelByClass(CLASS_TYPE_TEURGO_MIST,oCharacter)>0){
                iCasterLevel += GetSpecialCasterLevel(CLASS_TYPE_TEURGO_MIST,oCharacter);
            }
            if(GetLevelByClass(CLASS_TYPE_HARPER,oCharacter)>0){
                iCasterLevel += GetSpecialCasterLevel(CLASS_TYPE_HARPER,oCharacter);
            }
            break;

        case CLASS_TYPE_WIZARD:
                //iCasterLevel = GetLevelByClass(CLASS_TYPE_WIZARD, oCharacter);

            if(GetLevelByClass(CLASS_TYPE_PALEMASTER,oCharacter)>0){
                iCasterLevel += GetSpecialCasterLevel(CLASS_TYPE_PALEMASTER, oCharacter);
            }
            if(GetLevelByClass(CLASS_TYPE_BRIBON_ARCANO,oCharacter)>0){
                iCasterLevel += GetLevelByClass(CLASS_TYPE_BRIBON_ARCANO,oCharacter);
            }
            if(GetLevelByClass(CLASS_TYPE_CABALLERO_ARCANO,oCharacter)>0){
                iCasterLevel += GetSpecialCasterLevel(CLASS_TYPE_CABALLERO_ARCANO,oCharacter);
            }
            if(GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT,oCharacter)>0){
                iCasterLevel += GetSpecialCasterLevel(CLASS_TYPE_SHADOW_ADEPT,oCharacter);
            }
            if(GetLevelByClass(CLASS_TYPE_ARCHMAGE,oCharacter)>0){
                iCasterLevel += GetSpecialCasterLevel(CLASS_TYPE_ARCHMAGE,oCharacter);
            }
            if(GetLevelByClass(CLASS_TYPE_TEURGO_MIST,oCharacter)>0){
                iCasterLevel += GetSpecialCasterLevel(CLASS_TYPE_TEURGO_MIST,oCharacter);
            }
            if(GetLevelByClass(CLASS_TYPE_HARPER,oCharacter)>0){
                iCasterLevel += GetSpecialCasterLevel(CLASS_TYPE_HARPER,oCharacter);
            }

            break;

        case CLASS_TYPE_WARLOCK:
             iCasterLevel = GetLevelByClass(CLASS_TYPE_WARLOCK, oCharacter);

             break;

        case CLASS_TYPE_FAVORED_SOUL:
             iCasterLevel = GetLevelByClass(CLASS_TYPE_FAVORED_SOUL, oCharacter);

             break;

        case CLASS_TYPE_ASSASSIN:
             iCasterLevel = GetLevelByClass(CLASS_TYPE_ASSASSIN, oCharacter);

             break;

        case CLASS_TYPE_BLACKGUARD:
             iCasterLevel = GetLevelByClass(CLASS_TYPE_BLACKGUARD, oCharacter);

             break;

         case CLASS_TYPE_SOLDIER_OF_LIGHT:
             iCasterLevel = GetLevelByClass(CLASS_TYPE_SOLDIER_OF_LIGHT, oCharacter);

             break;

         case CLASS_TYPE_INGENIERO:
             iCasterLevel = GetLevelByClass(CLASS_TYPE_INGENIERO, oCharacter);

             break;

        default:
            iCasterLevel = GetCasterLevel(oCharacter);
    }

    //De base siempre cuenta si tiene o no dotes u otros benficios, para cosas muy concretas se pone la opción de invalidar esto.
    if(Dotes == TRUE)
    {
        //Lanzador de conjuros veterano.
        if (GetSpellCastItem() == OBJECT_INVALID && iBaseClass != 0) {
            if (GetHasFeat(FEAT_CONJUROS_VETERANO, oCharacter)) {
                iCasterLevel += 4;
                if(iCasterLevel > iDG) {
                    iCasterLevel = iDG;
                }
            }
        }
        //Infusión: Elixir de Conocimiento.
        if (GetSpellCastItem() == OBJECT_INVALID && iBaseClass != 0){
            if(GetLocalInt(oCharacter, "CLS_ING_ELIXIRCON") == 1){
                iCasterLevel += 4;
            }
        }
    }

    iCasterLevel = iCasterLevel + nSpellPowerLevels;

    return iCasterLevel;
}

int GetCL(object oCharacter = OBJECT_SELF)
{
    int iCasterLevel = 0;
    int i;
    // Iterar sobre las tres clases del personaje
    for (i = 1; i <= 3; i++)
    {
        int iClass = GetClassByPosition(i, oCharacter);
        int iLevel = GetLevelByClass(iClass, oCharacter);
        // Aplicar condiciones específicas según la clase
        switch(iClass)
        {
            case CLASS_TYPE_CLERIC:
                iCasterLevel += iLevel;
                if(GetLevelByClass(CLASS_TYPE_TEURGO_MIST, oCharacter) > 0)
                    iCasterLevel += GetSpecialCasterLevel(CLASS_TYPE_TEURGO_MIST, oCharacter);
                if(GetLevelByClass(CLASS_TYPE_HARPER_DIVINE, oCharacter) > 0)
                    iCasterLevel += GetSpecialCasterLevel(CLASS_TYPE_HARPER_DIVINE, oCharacter);
                if(GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT_DIVINE, oCharacter) > 0)
                    iCasterLevel += GetSpecialCasterLevel(CLASS_TYPE_SHADOW_ADEPT_DIVINE, oCharacter);
                break;

            case CLASS_TYPE_DRUID:
                iCasterLevel += iLevel;
                if(GetLevelByClass(CLASS_TYPE_TEURGO_MIST, oCharacter) > 0)
                    iCasterLevel += GetSpecialCasterLevel(CLASS_TYPE_TEURGO_MIST, oCharacter);
                break;

            case CLASS_TYPE_BARD:
            case CLASS_TYPE_SORCERER:
            case CLASS_TYPE_WIZARD:
                iCasterLevel += iLevel;
                if(GetLevelByClass(CLASS_TYPE_PALEMASTER, oCharacter) > 0)
                    iCasterLevel += GetSpecialCasterLevel(CLASS_TYPE_PALEMASTER, oCharacter);
                if(GetLevelByClass(CLASS_TYPE_BRIBON_ARCANO, oCharacter) > 0)
                    iCasterLevel += GetLevelByClass(CLASS_TYPE_BRIBON_ARCANO, oCharacter);
                if(GetLevelByClass(CLASS_TYPE_CABALLERO_ARCANO, oCharacter) > 0)
                    iCasterLevel += GetSpecialCasterLevel(CLASS_TYPE_CABALLERO_ARCANO, oCharacter);
                if(GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oCharacter) > 0)
                    iCasterLevel += GetSpecialCasterLevel(CLASS_TYPE_SHADOW_ADEPT, oCharacter);
                if(GetLevelByClass(CLASS_TYPE_ARCHMAGE, oCharacter) > 0)
                    iCasterLevel += GetSpecialCasterLevel(CLASS_TYPE_ARCHMAGE, oCharacter);
                if(GetLevelByClass(CLASS_TYPE_TEURGO_MIST, oCharacter) > 0)
                    iCasterLevel += GetSpecialCasterLevel(CLASS_TYPE_TEURGO_MIST, oCharacter);
                if(GetLevelByClass(CLASS_TYPE_HARPER, oCharacter) > 0)
                    iCasterLevel += GetSpecialCasterLevel(CLASS_TYPE_HARPER, oCharacter);
                break;
            case CLASS_TYPE_FAVORED_SOUL:
                iCasterLevel += iLevel;
                iCasterLevel += GetLevelByClass(CLASS_TYPE_FAVORED_SOUL, oCharacter);
                break;
            case CLASS_TYPE_WARLOCK:
                iCasterLevel += iLevel;
                iCasterLevel += GetLevelByClass(CLASS_TYPE_WARLOCK, oCharacter);
                break;
            case CLASS_TYPE_INGENIERO:
                iCasterLevel += iLevel;
                iCasterLevel += GetLevelByClass(CLASS_TYPE_INGENIERO, oCharacter);
                break;
        }
    }
    return iCasterLevel;
}

//Llamamos al script de modificaciones de tiradas de Salvacion CDs
int GetChangesToSaveDC(object oCharacter)
{
    return  ExecuteScriptAndReturnInt("add_spell_dc", oCharacter);
}

//Maestria de los Elementos (Archimago)
int ChangedElementalDamage(object oCaster, int nDamageType)
{
int nNewType = ExecuteScriptAndReturnInt("set_damage_type", oCaster);
if(nNewType != 0)
{
nDamageType = nNewType;
}
return nDamageType;
}

int GetCasterMaxSpellLevel(int nClass, object oCaster = OBJECT_SELF, int iDotes = TRUE)
{
    if(nClass == CLASS_TYPE_INVALID) return 9;
    int nCasterLevel = GetTotalCasterLevel(oCaster, nClass);
    if(iDotes == FALSE) nCasterLevel = GetTotalCasterLevel(oCaster, nClass, FALSE);
    int nMax = 9;
    switch (nClass)
    {
        case CLASS_TYPE_WIZARD:
        case CLASS_TYPE_DRUID:
        case CLASS_TYPE_CLERIC:
            nMax = FloatToInt((nCasterLevel + 1)/2.0f);
            break;
        case CLASS_TYPE_SORCERER:
            nMax = FloatToInt((nCasterLevel)/2.0f);
            break;
        case CLASS_TYPE_BARD:
            nMax = FloatToInt((nCasterLevel + 2)/3.0f);
            break;
        case CLASS_TYPE_PALADIN:
        case CLASS_TYPE_PAL_ANTIGUO:
        case CLASS_TYPE_PAL_OSCURO:
        case CLASS_TYPE_PAL_VENGADOR:
        case CLASS_TYPE_RANGER:
            if(nCasterLevel>=14)
                nMax = 4;
            else if(nCasterLevel>=11)
                nMax = 3;
            else if(nCasterLevel>=8)
                nMax = 2;
            else if(nCasterLevel>=4)
                nMax = 1;
            else
                nMax = 0;
            break;
        case CLASS_TYPE_INGENIERO:
    }
    int nPrcLevel;
    if(nClass == CLASS_TYPE_DRUID)
    {
        nPrcLevel = GetLevelByClass(CLASS_TYPE_BLIGHTER, oCaster);
        if(nPrcLevel > 0 && nMax > nPrcLevel)
            nMax = nPrcLevel;
    }
    if(nMax > 9) nMax = 9;
    if(nMax < 1) nMax = 0;
    return nMax;
}

int GetCasterCanCast(object oCaster = OBJECT_SELF)
{
    object oItem = GetSpellCastItem();
    if(oItem != OBJECT_INVALID || !GetIsPC(oCaster)) return TRUE;
    string sLvl = ""; int nLvl;
    int nSpellId = GetSpellId();
    int nClass = GetLastSpellCastClass();
    string sMasterId = Get2DAString("spells","Master",nSpellId);
    if(sMasterId != "") nSpellId = StringToInt(sMasterId);

    switch (nClass)
    {
        case CLASS_TYPE_WIZARD:
        case CLASS_TYPE_INGENIERO:
            sLvl = Get2DAString("spells","Wiz_Sorc",nSpellId);
            break;
        case CLASS_TYPE_SORCERER:
            sLvl = Get2DAString("spells","Wiz_Sorc",nSpellId);
            break;
        case CLASS_TYPE_BARD:
            sLvl = Get2DAString("spells","Bard",nSpellId);
            break;
        case CLASS_TYPE_CLERIC:
            sLvl = Get2DAString("spells","Cleric",nSpellId);
            break;
        case CLASS_TYPE_DRUID:
            sLvl = Get2DAString("spells","Druid",nSpellId);
            break;
        case CLASS_TYPE_PALADIN:
            sLvl = Get2DAString("spells","Paladin",nSpellId);
            break;
        case CLASS_TYPE_PAL_ANTIGUO:
            sLvl = Get2DAString("spells","PaladinAntiguos",nSpellId);
            break;
        case CLASS_TYPE_PAL_OSCURO:
            sLvl = Get2DAString("spells","PaladinOscuro",nSpellId);
            break;
        case CLASS_TYPE_PAL_VENGADOR:
            sLvl = Get2DAString("spells","PaladinVengador",nSpellId);
            break;
        case CLASS_TYPE_RANGER:
            sLvl = Get2DAString("spells","Ranger",nSpellId);
            break;
        case CLASS_TYPE_FAVORED_SOUL:
            sLvl = Get2DAString("spells","Cleric",nSpellId);
            break;
    }
    //Fix to get cleric domain spell levels
    if(nClass == CLASS_TYPE_CLERIC)
    {
        //int nDomain = NWNX_Creature_GetClericDomain(oCaster, 1);
        int nDomain = GetDomain(oCaster, 1, CLASS_TYPE_CLERIC);
        string sDomLevel = "";
        int nDomLevel;
        for(nDomLevel = 1; nDomLevel < 10; nDomLevel++) {
            sDomLevel = Get2DAString("domains","Level_" + IntToString(nDomLevel),nDomain);
            if(sDomLevel != "" && nSpellId == StringToInt(sDomLevel))
                break;
        }
        if(nDomLevel < 10)
            sLvl = IntToString(nDomLevel);
        else
        {
            //nDomain = NWNX_Creature_GetClericDomain(oCaster, 2);
            nDomain = GetDomain(oCaster, 2, CLASS_TYPE_CLERIC);
            for(nDomLevel = 1; nDomLevel < 10; nDomLevel++) {
                sDomLevel = Get2DAString("domains","Level_" + IntToString(nDomLevel),nDomain);
                if(sDomLevel != "" && nSpellId == StringToInt(sDomLevel))
                    break;
            }
            if(nDomLevel < 10)
                sLvl = IntToString(nDomLevel);
        }
    }
    if(sLvl == "")
        sLvl = Get2DAString("spells","Innate",nSpellId);
    if(sLvl == "")
        nLvl = 0;
    else
        nLvl = StringToInt(sLvl);
    return nLvl <= GetCasterMaxSpellLevel(nClass, oCaster);
}

//void main(){}
