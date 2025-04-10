#include "x0_i0_spells"
#include "pb_nivellanzador"
#include "mti_libreria"

const int SPELL_DISPEL_ALL = 0;
const int SPELL_DISPEL_BEST = 1;

//Metodos publicos:-------------------------------------------------------------

//Metodo adecuado al servidor puerta de baldur para disipar conjuros.
void pbDispelMagic(object oTarget, int nCasterLevel, effect eVis, effect eImpac, int bAll = TRUE, int bBreachSpells = FALSE);

//Metodo adecuado al servidor puerta de baldur para disipar las areas de efecto.
void pbDispelAoE(object oTargetAoE, object oCaster, int nCasterLevel);

//Metodo que obtiene el nombre del conjuro en base a su identificador.
string getSpellName(int nSpellId);

//Metodo que obtiene el nivel innato del conjuro en base a su identificador.
int getSpellInnateLevel(int nSpellId);

// Metodo que obtiene la escuela de magia el conjuro pasado.
// Valores devueltos:
// A: Abjuracion
// C: Conjuracion
// D: Adivinacion
// E: Encantamiento
// I: Ilusion
// N: Nigromancia
// T: Transmutacion
// V: Evocacion
string getSpellShool(int nSpellId);

//Método que comprueba si un efecto es de tipo EffectSummon
int getIsEffectSummon(effect eSummon);

//Método para recuperar el efecto de convocación a partir de un convocado
effect getSummonEffectSummon(object oMaster, object oSummon);

//Método para calcular la disipación de convocados
int doSummonDispel(object oTarget, int nCasterLevel);

//Método para crear el objeto temporal que se utilizará para almacenar las variables de disipación
object createVariableContainer() {
    return CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", GetStartingLocation());
}

// Creación del contenedor de variables del proceso de disipación
object oVariableContainer = createVariableContainer();


// Métodos privados
//------------------------------------------------------------------------------

void addSpellCheck(effect eEfecto){   //METODO PRIVADO
    //Añade a la pila de conjuros chequeados.
    int nDispelTableLength = GetLocalInt(oVariableContainer, "CheckSpellLength");
    int nSpellId = GetEffectSpellId(eEfecto);
    object oCreator = GetEffectCreator(eEfecto);

    SetLocalInt(oVariableContainer, "CheckSpellId"+IntToString(nDispelTableLength), nSpellId);
    SetLocalObject(oVariableContainer, "CheckSpellCreator"+IntToString(nDispelTableLength), oCreator);
    SetLocalInt(oVariableContainer, "CheckSpellLength", nDispelTableLength + 1);
}

int getSpellCheck(effect eEfecto){    //METODO PRIVADO
    //Chequea la pila de conjuros chequeados.
    int nDispelTableLength = GetLocalInt(oVariableContainer, "CheckSpellLength"),
        i = 0;

    int nSpellId = GetEffectSpellId(eEfecto);
    int nValor;

    for (i = 0; i < nDispelTableLength; i++) {
        nValor = GetLocalInt(oVariableContainer, "CheckSpellId"+IntToString(i));

        if (nValor == nSpellId) return TRUE;
    }

    return FALSE;
}

void swapSpell(int x, int y) {
    int nSpellId1 = GetLocalInt(oVariableContainer, "CheckSpellId"+IntToString(x));
    int nSpellId2 = GetLocalInt(oVariableContainer, "CheckSpellId"+IntToString(y));
    object oCreator1 = GetLocalObject(oVariableContainer, "CheckSpellCreator"+IntToString(x));
    object oCreator2 = GetLocalObject(oVariableContainer, "CheckSpellCreator"+IntToString(y));;

    int nAux;
    object oAux;
    nAux = nSpellId1;
    oAux = oCreator1;

    SetLocalInt(oVariableContainer, "CheckSpellId"+IntToString(x), nSpellId2);
    SetLocalObject(oVariableContainer, "CheckSpellCreator"+IntToString(x), oCreator2);

    SetLocalInt(oVariableContainer, "CheckSpellId"+IntToString(y), nAux);
    SetLocalObject(oVariableContainer, "CheckSpellCreator"+IntToString(y), oAux);
}

void ordSpellCheck(object oTarget){                 //METODO PRIVADO
    //Ordena la pila de conjuros chequeados por nivel innato y nivel de lanzador.
    int nDispelTableLength = GetLocalInt(oVariableContainer, "CheckSpellLength"),
        i = 0, j = 0;

    int nSpellId1;
    int nSpellId2;
    int nSpellLv1;
    int nSpellLv2;
    int nSpellCD1;
    int nSpellCD2;
    object oCreator1;
    object oCreator2;

    int nAux;
    object oAux;

    //Ordenamos los conjuros por nivel innato y nivel de lanzador (Bubble Sort)
    for (i = 0; i < nDispelTableLength - 1; i++) {
        // El último elemento ya está ordenado
        for (j = 0; j < nDispelTableLength - i - 1; j++) {
            nSpellId1 = GetLocalInt(oVariableContainer, "CheckSpellId"+IntToString(j));
            nSpellLv1 = getSpellInnateLevel(nSpellId1);
            oCreator1 = GetLocalObject(oVariableContainer, "CheckSpellCreator"+IntToString(j));
            nSpellCD1 = GetLocalInt(oTarget,GetName(oCreator1, TRUE)+IntToString(nSpellId1));

            nSpellId2 = GetLocalInt(oVariableContainer, "CheckSpellId"+IntToString(j+1));
            nSpellLv2 = getSpellInnateLevel(nSpellId2);
            oCreator2 = GetLocalObject(oVariableContainer, "CheckSpellCreator"+IntToString(j+1));
            nSpellCD2 = GetLocalInt(oTarget,GetName(oCreator2, TRUE)+IntToString(nSpellId2));

            if (nSpellLv2 >= nSpellLv1) swapSpell(nSpellId1, nSpellId2);
            else if (nSpellLv2 == nSpellLv1 && nSpellCD2 > nSpellCD1) swapSpell(nSpellId1, nSpellId2);
        }
    }
}

void destroySpell(int nSpellId, object oTarget){ //METODO PRIVADO
    //Elimina los efectos de un conjuro determinado.
    int nId;

    effect eSearch = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eSearch)){
        nId = GetEffectSpellId(eSearch);

        if(nSpellId == nId) {
            if (GetEffectSubType(eSearch) == SUBTYPE_MAGICAL){
                RemoveEffect(oTarget, eSearch);
            }
        }

        eSearch = GetNextEffect(oTarget);
    }
}

void applyDispelAll(object oTarget, int nCasterLevel){  //METODO PRIVADO
    //Metodo que elimina todos los conjuros del objetivo realizando una prueba
    //enfrentada de nivel de lanzador.

    int nTirada;                //Tirada de disipacion.
    int nSpellId;               //Id del conjuro.
    int nCD;                    //CD de disipacion.
    string sSpellCode;          //Nombre de la variable local que almacena el nivel del lanzador.
    string sMensaje;            //Mensaje presentado a los usuarios.
    object oCreator;            //Creador del conjuro.
    string sSpellShool;         //Escuela de magia.
    int nMagiaTenaz;            //Lanzado mediante magia tenaz.
    int nUrdimbreSombria;       //Lanzado mediante urdimbre sombria.

    // Disipación de convocados
    if (doSummonDispel(oTarget, nCasterLevel)) return;

    effect eSearch = GetFirstEffect(oTarget);

    while(GetIsEffectValid(eSearch)){
        nSpellId = GetEffectSpellId(eSearch);
        oCreator = GetEffectCreator(eSearch);
        sSpellCode = GetName(oCreator, TRUE)+IntToString(nSpellId);

        sSpellShool = getSpellShool(nSpellId);

        //Calculo de la CD de disipacion.
        nCD = GetLocalInt(oTarget,sSpellCode);
        nCD += 11;

        nMagiaTenaz = GetLocalInt(oTarget, "TENACIOUS_MAGIC_"+sSpellCode);
        if(!GetHasFeat(1354, OBJECT_SELF)){
            //El lanzador no es usuario de urdimbre sombria.
            if(nMagiaTenaz){
                //El conjuro fue lanzado mediante la dote magia tenaz.
                if(sSpellShool != "V" && sSpellShool != "T"){
                    //Las escuelas de Evocacion y transmutacion no tienen efecto.
                    nCD += 4;
                }
            }
        }

        nUrdimbreSombria = GetLocalInt(oTarget, "SHADOW_WEAVE_"+sSpellCode);
        if(GetHasFeat(1355, OBJECT_SELF)){
            //El lanzador posee la dote magia tenaz
            if(!nUrdimbreSombria){
                //El conjuro no fue lanzado mediante urdimbre sombria.
                if(sSpellShool != "E" && sSpellShool != "I" && sSpellShool != "N"){
                    /*
                      Las escuelas de Encantamiento, Ilusion y Nigromancia no
                      tienen efecto
                    */
                    nCD += 2;
                }
            }
        }

        if(GetEffectSubType(eSearch) == SUBTYPE_MAGICAL && !getIsEffectSummon(eSearch) && GetIsObjectValid(oCreator)){
            if (!getSpellCheck(eSearch)){
                nTirada = d20();
                nTirada += nCasterLevel;
                //FloatingTextStringOnCreature("Tirada de disipacion: "+IntToString(nTirada)+" vs CD "+ IntToString(nCD), OBJECT_SELF);
                addSpellCheck(eSearch);
                if (nTirada >= nCD){
                    destroySpell(nSpellId, oTarget);
                    if(GetStringLength(sMensaje) <= 0){
                        sMensaje = "<cÌwþ>Disipar magia: <cÌwÌ>"+GetName(oTarget)+": <cÌwþ>";
                        sMensaje += getSpellName(nSpellId);
                    } else {
                        sMensaje += ", "+getSpellName(nSpellId);
                    }
                }
            }
        }

        eSearch = GetNextEffect(oTarget);
    }

    if (GetStringLength(sMensaje) > 0){
        SendMessageToPC(OBJECT_SELF, sMensaje);
        SendMessageToPC(oTarget, sMensaje);
    }
    int nVampireMist = GetLocalInt(oTarget, "FALLEN_VAMPIRE_MIST");

    if (GetStringLowerCase(GetSubRace(oTarget)) == "vampiro") {
        ReaplicarEfectosPB(oTarget,TRUE, FALSE, TRUE);
        SetLocalInt(oTarget, "FALLEN_VAMPIRE_MIST", nVampireMist);
    }
}

void applyDispelBest(object oTarget, int nCasterLevel){ //METODO PRIVADO
    //Metodo que elimina el primer conjuro del objetivo realizando una prueba
    //enfrentada de nivel de lanzador.
    //Los conjuros se chequean comenzando por los de mayor nivel de poder
    //entendiendo como tales los de mayor nivel innato y mayor CD de disipacion.

    int nTirada;                //Tirada de disipacion.
    int nSpellId;               //Id del conjuro.
    int nCD;                    //CD de disipacion.
    string sSpellCode;          //Nombre de la variable local que almacena el nivel del lanzador.
    string sMensaje;            //Mensaje presentado a los usuarios.
    object oCreator;            //Creador del conjuro.
    string sSpellShool;         //Escuela de magia.
    int nMagiaTenaz;            //Lanzado mediante magia tenaz.
    int nUrdimbreSombria;       //Lanzado mediante urdimbre sombria.

    // Disipación de convocados
    if (doSummonDispel(oTarget, nCasterLevel)) return;

    effect eSearch = GetFirstEffect(oTarget);

    while(GetIsEffectValid(eSearch)){
        nSpellId = GetEffectSpellId(eSearch);
        oCreator = GetEffectCreator(eSearch);
        sSpellCode = GetName(oCreator, TRUE)+IntToString(nSpellId);

        if(GetEffectSubType(eSearch) == SUBTYPE_MAGICAL && !getIsEffectSummon(eSearch) && GetIsObjectValid(oCreator)){
            if(!getSpellCheck(eSearch)){
                addSpellCheck(eSearch);
            }
        }

        eSearch = GetNextEffect(oTarget);
    }
    ordSpellCheck(oTarget);

    int i = 0;
    while(GetLocalInt(oVariableContainer, "CheckSpellId"+IntToString(i)) != 0){
        nSpellId = GetLocalInt(oVariableContainer, "CheckSpellId"+IntToString(i));
        oCreator = GetLocalObject(oVariableContainer, "CheckSpellCreator"+IntToString(i));
        sSpellCode = GetName(oCreator, TRUE)+IntToString(nSpellId);
        nCD = GetLocalInt(oTarget, sSpellCode);
        nCD += 11;

        nMagiaTenaz = GetLocalInt(oTarget, "TENACIOUS_MAGIC_"+sSpellCode);
        if(!GetHasFeat(1354, OBJECT_SELF)){
            //El lanzador no es usuario de urdimbre sombria.
            if(nMagiaTenaz){
                //El conjuro fue lanzado mediante la dote magia tenaz.
                if(sSpellShool != "V" && sSpellShool != "T"){
                    //Las escuelas de Evocacion y transmutacion no tienen efecto.
                    nCD += 4;
                }
            }
        }

        nUrdimbreSombria = GetLocalInt(oTarget, "SHADOW_WEAVE_"+sSpellCode);
        if(GetHasFeat(1355, OBJECT_SELF)){
            //El lanzador posee la dote magia tenaz
            if(!nUrdimbreSombria){
                //El conjuro no fue lanzado mediante urdimbre sombria.
                if(sSpellShool != "E" && sSpellShool != "I" && sSpellShool != "N"){
                    /*
                      Las escuelas de Encantamiento, Ilusion y Nigromancia no
                      tienen efecto
                    */
                    nCD += 2;
                }
            }
        }

        //Realizamos una tirada por conjuro a disipar.
        nTirada = d20();
        nTirada += nCasterLevel;
        //FloatingTextStringOnCreature("Tirada de disipacion: "+IntToString(nTirada)+" vs CD "+ IntToString(nCD), OBJECT_SELF);
        if(nTirada >= nCD){
            //Cuando logra disipar un conjuro sale, sino continua hasta el final de la lista.
            destroySpell(nSpellId, oTarget);

            //Cargamos el mensaje de disipacion.
            sMensaje = "<cÌwþ>Disipar magia: <cÌwÌ>"+GetName(oTarget)+": <cÌwþ>";
            sMensaje += getSpellName(nSpellId);
            break;
        }

        i++;
    }

    if (GetStringLength(sMensaje) > 0){
        SendMessageToPC(OBJECT_SELF, sMensaje);
        SendMessageToPC(oTarget, sMensaje);
    }
    int nVampireMist = GetLocalInt(oTarget, "FALLEN_VAMPIRE_MIST");
    if (GetStringLowerCase(GetSubRace(oTarget)) == "vampiro"){
        ReaplicarEfectosPB(oTarget,TRUE,FALSE,TRUE);
        SetLocalInt(oTarget, "FALLEN_VAMPIRE_MIST", nVampireMist);
    }

}

string getSpellName(int nSpellId){
    string sValor = Get2DAString("spells", "Name", nSpellId);
    return GetStringByStrRef(StringToInt(sValor));
}

int getSpellInnateLevel(int nSpellId){
    string sValor = Get2DAString("spells", "Innate", nSpellId);
    return StringToInt(sValor);
}

string getSpellShool(int nSpellId){
    return Get2DAString("spells", "School", nSpellId);
}

int getIsEffectSummon(effect eEffect) {
    if (GetStringLength(GetEffectString(eEffect, 0))) return TRUE;
    else return FALSE;
}

effect getSummonEffectSummon(object oMaster, object oSummon) {
    string sResRef = GetStringUpperCase(GetResRef(oSummon));

    effect eEffect = GetFirstEffect(oMaster);

    while (GetIsEffectValid(eEffect)) {
        if (getIsEffectSummon(eEffect) && GetStringUpperCase(GetEffectString(eEffect, 0)) == sResRef) {
            return eEffect;
        }

        eEffect = GetNextEffect(oMaster);
    }

    return eEffect;
}

int doSummonDispel(object oTarget, int nCasterLevel) {
    // Disipación de convocados
    if (GetAssociateType(oTarget) == ASSOCIATE_TYPE_SUMMONED) {
        object oMaster = GetMaster(oTarget);
        effect eSummon = getSummonEffectSummon(oMaster, oTarget);

        // Recuperar datos del conjuro de convocación
        int nSpellId = GetEffectSpellId(eSummon);
        object oCreator = GetEffectCreator(eSummon);
        string sSpellCode = GetName(oCreator, TRUE)+IntToString(nSpellId);

        // Cálculo de la tirada de disipación
        int nTirada = d20();
        nTirada += nCasterLevel;

        // Cálculo de la CD de disipación
        int nCD = GetLocalInt(oMaster, sSpellCode);
        nCD += 11;

        if (nTirada >= nCD) {
            RemoveEffect(oMaster, eSummon);
            return TRUE;
        }
    }

    return FALSE;
}

void pbDispelMagic(object oTarget, int nCasterLevel, effect eVis, effect eImpac, int bAll = TRUE, int bBreachSpells = FALSE)
{
    //--------------------------------------------------------------------------
    // No se disipa a criaturas petrificadas o marcadas como inmunes a la
    // disipacion.
    //--------------------------------------------------------------------------
    if (GetHasEffect(EFFECT_TYPE_PETRIFY, oTarget) == TRUE || GetLocalInt(oTarget, "X1_L_IMMUNE_TO_DISPEL") == 10)
    {
        return;
    }

    float fDelay = GetRandomDelay(0.1, 0.3);
    int nSpellId = GetSpellId();
    int nDispel = SPELL_DISPEL_ALL;

    //--------------------------------------------------------------------------
    // Disparamos el evento hostil solo si el blanco es hostil...
    //--------------------------------------------------------------------------
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellId));
    }
    else
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellId, FALSE));
    }

    //--------------------------------------------------------------------------
    // Se disipan todos los efectos, incluso si se utiliza en un AOE.
    //--------------------------------------------------------------------------
    if (bAll == TRUE )
    {
        //----------------------------------------------------------------------
        // Soporte para la disyuncion de Mordenkainen (aplica la bajada de RC).
        //----------------------------------------------------------------------
        if (bBreachSpells)
        {
            DoSpellBreach(oTarget, 6, 10, nSpellId);
        }
    }
    else
    {
        nDispel = SPELL_DISPEL_BEST;
        if (bBreachSpells)
        {
           DoSpellBreach(oTarget, 2, 10, nSpellId);
        }
    }

    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
    if(nDispel == SPELL_DISPEL_ALL){
        //Llamada a disipar todo.
        applyDispelAll(oTarget, nCasterLevel);
    } else {
        //Llamada a disipar el mejor.
        applyDispelBest(oTarget, nCasterLevel);
    }

    // Destruir el objeto contenedor de variables de disipación
    DestroyObject(oVariableContainer);
}

void pbDispelAoE(object oTargetAoE, object oCaster, int nCasterLevel)
{
    //Revisa que el area de efecto no sea indisipable.
    effect eSearch = GetFirstEffect(oTargetAoE);

    // Únicamente se pueden disipar efectos de área sin subtipo o de subtipo mágico
    int nSubType = GetEffectSubType(eSearch);
    if(nSubType && nSubType != SUBTYPE_MAGICAL) return;

    int nTirada = d20();                                    //Tirada de disipacion.
    object oCreator = GetAreaOfEffectCreator(oTargetAoE);   //Creador del conjuro.
    int nCD = GetLocalInt(oTargetAoE, "AoEDispellCD");      //CD de disipacion.
    string sSpellShool = GetLocalString(oTargetAoE, "SCHOOL_OF_MAGIC_AOE"); //Escuela de magia.

    nCD += 11;                                              //Bono a la CD del objetivo.
    nTirada += nCasterLevel;                                //Bono a la tirada del lanzador.

    int nMagiaTenaz = GetLocalInt(oTargetAoE, "TENACIOUS_MAGIC_AOE");
    if(!GetHasFeat(1354, OBJECT_SELF)){
        //El lanzador no es usuario de urdimbre sombria.
        if(nMagiaTenaz){
            //El area de efecto fue lanzada mediante la dote magia tenaz.
            if(sSpellShool != "V" && sSpellShool != "T"){
                //Las escuelas de Evocacion y transmutacion no tienen efecto.
                nCD += 4;
            }
        }
    }

    int nUrdimbreSombria = GetLocalInt(oTargetAoE, "SHADOW_WEAVE_AOE");
    if(GetHasFeat(1355, OBJECT_SELF)){
        //El lanzador posee la dote magia tenaz
        if(!nUrdimbreSombria){
            //El conjuro no fue lanzado mediante urdimbre sombria.
            if(sSpellShool != "E" && sSpellShool != "I" && sSpellShool != "N"){
                /*
                  Las escuelas de Encantamiento, Ilusion y Nigromancia no
                  tienen efecto
                */
                nCD += 2;
            }
        }
    }

    //FloatingTextStringOnCreature("Tirada de disipacion: "+IntToString(nTirada)+" vs CD "+ IntToString(nCD), OBJECT_SELF);
    if ((nTirada >= nCD)|| GetIsDM(oCaster) || (oCaster == oCreator))
    {
        FloatingTextStrRefOnCreature(100929,oCaster);  // "AoE dispelled"
        DestroyObject(oTargetAoE);
    }
    else FloatingTextStrRefOnCreature(100930,oCaster); // "AoE not dispelled"
}
