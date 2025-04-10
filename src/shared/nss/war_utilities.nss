#include "NW_I0_SPELLS"
#include "pb_nivellanzador"
#include "x0_i0_match"
#include "inc_sqlite_time"

/////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// DECLARACIÓN DE CONSTANTES /////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////

const int WARLOCK_ESENCIA_NORMAL = 0;
const int WARLOCK_ESENCIA_AZUFRE = 1;
const int WARLOCK_ESENCIA_INFERNAL = 2;
const int WARLOCK_ESENCIA_TENEBROSA = 3;
const int WARLOCK_ESENCIA_DERRIBO = 4;
const int WARLOCK_ESENCIA_CAUSTICA = 5;

const int WARLOCK_MOLDEADO_NORMAL = 0;
const int WARLOCK_MOLDEADO_CADENA = 1;
const int WARLOCK_MOLDEADO_CONO = 2;
const int WARLOCK_MOLDEADO_AREA = 3;

const int WARLOCK_SORTILEGA_NORMAL = 0;
const int WARLOCK_SORTILEGA_POTENCIAR = 1500;
const int WARLOCK_SORTILEGA_MAXIMIZAR = 1501;


////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// DECLARACIÓN DE FUNCIONES /////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////

// Función utilizada para calcular la CD de los poderes del Brujo Arcano
// (opcional) oCreature - Objetivo del cual calcular la CD
// (opcional) bGolpeHorrible - Aplicar CD de Golpe Horrible
// (opcional) bIgnorarEsencia - Ignorar la esencia activa a la hora de calcular la CD
int GetWarlockSpellDC(object oCreature = OBJECT_SELF, int bGolpeHorrible = FALSE, int bIgnorarEsencia = FALSE);

// Función utilizada para calcular el da?o que deber?a de hacer la explosi?n sobrenatural de un Brujo Arcano
// (opcional) oCreature - Objetivo del cu?l calcular el da?o
int GetWarlockExplosionDamage(object oCreature = OBJECT_SELF);

// Función utilizada para actualizar las variables relacionadas con las esencias del Brujo Arcano
// nEsencia - Esencia a seleccionar (recomendable usar las constantes declaradas en este script)
int CambiarEsencia(int nEsencia);

// función utilizada para actualizar las variables relacionadas con las modificaciones de aptitudes del Brujo Arcano
// nModAptitud - Aptitud a seleccionar (recomendable usar las constantes declaradas en este script)
void CambiarModAptitud(int nModAptitud);

// función utilizada para aplicar el uso de la modificaci?n de aptitud del Brujo Arcano
void UsoModAptitud();

// Esta función embiste al objetivo.
// Asume que el objetivo no es inmune a embestir.
void ActionRepel(object oTarget, float fDistance, float fTime);

//Función interna para calcular la distancia del derribo/embestida
location NewLoc(object oTarget, float fDistance);

// función utilizada para simular un efecto de DoT (Damage over Time) del Brujo Arcano
// oTarget - Objetivo al cu?l aplicar el efecto
// nDice - Dados d6 a utilizar para calcular el da?o
// nDamageType - Tipo del da?o del efecto
// nSavingThrow - Tirada de salvaci?n utilizada para evitar el efecto (o la repetici?n)
// nHitVFX - Efecto visual a aplicar cu?ndo el objetivo sea da?ado por el efecto
// nDurationVFX - Efecto visual que se mantiene mientras el efecto siga activo
// nMaxHits - Cantidad m?xima de golpes a aplicar
// (opcional) nHit - Cantidad de golpes realizados
// (opcional) nModAptitud - Modificador de aptitud activo
// (opcional) bGolpeHorrible - Aplicar CD de Golpe Horrible
void AplicarDoT(object oTarget, int nDice, int nDamageType, int nSavingThrow, int nHitVFX, int nDurationVFX, int nMaxHits, int nHit = 0, int nModAptitud = 0, int bGolpeHorrible = FALSE);

////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////// IMPLEMENTACI?N DE FUNCIONES ////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
void Volar(object oTarget, float fDistance)
{
 SetObjectVisualTransform(oTarget, OBJECT_VISUAL_TRANSFORM_TRANSLATE_Z, 1.0);
 location lLoc;
 lLoc= NewLoc(oTarget, fDistance);
 SetObjectVisualTransform(oTarget, OBJECT_VISUAL_TRANSFORM_ROTATE_X, 180.0);
 AssignCommand(oTarget, ClearAllActions());
 AssignCommand(oTarget, ActionJumpToLocation(lLoc));
}

void Aterrizar(object oTarget)
{
SetObjectVisualTransform(oTarget, OBJECT_VISUAL_TRANSFORM_TRANSLATE_Z, 0.0);
}

void Voltear(object oTarget)
{
SetObjectVisualTransform(oTarget, OBJECT_VISUAL_TRANSFORM_ROTATE_X, 0.0);
}

void ActionRepel(object oTarget, float fDistance, float fTime)
{
 if(GetLocalInt(oTarget, "SLIDING")==TRUE)
  return;

 float fPause= 0.2; //Retraso para las animaciones

 //Aplicamos la variable embestido.
 SetLocalInt(oTarget, "SLIDING", TRUE);

 //Evitamos cosas raras
 AssignCommand(oTarget, ClearAllActions());
 AssignCommand(oTarget, PlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0, fPause));

 //Lo hacemos volar
 DelayCommand(fPause, Volar(oTarget, fDistance));
 DelayCommand(fPause+fPause, Aterrizar(oTarget));
 DelayCommand(fTime-fPause+fPause+0.3, Voltear(oTarget));
 DelayCommand(fPause+fPause+0.3, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oTarget, fTime-fPause+fPause+0.3));
 DelayCommand(fPause+fPause+0.3, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(460), oTarget, 1.0));
 DelayCommand(fTime-fPause+fPause+0.3, SetLocalInt(oTarget, "SLIDING", FALSE));

}
location NewLoc(object oTarget, float fDistance)
{
 vector v1= GetPosition(oTarget);
 vector v2= GetPosition(OBJECT_SELF);
 vector v3;
 vector v4= v2*-1.0;
 vector vn= v1+v4;
 vn= VectorNormalize(vn);
 vn= vn*fDistance;
 vn= vn+v1;
 int nNth=1;

 object oWp= GetNearestObjectByTag("repel_limit_marker", oTarget, nNth);
 while(GetIsObjectValid(oWp))
 {
 nNth++;
 v3= GetPosition(oWp);
 if(((v3.x<vn.x)&&(v2.x<v3.x))||((v3.x>vn.x)&&(v2.x>v3.x)))
 vn.x=v3.x;
 if(((v3.y<vn.y)&&(v2.y<v3.y))||((v3.y>vn.y)&&(v2.y>v3.y)))
 vn.y=v3.y;
 oWp= GetNearestObjectByTag("repel_limit_marker", oTarget, nNth);
 }

 return Location(GetArea(OBJECT_SELF), vn, GetFacing(OBJECT_SELF));
}

// función utilizada para mirar si el Brujo Arcano es capaz de usar esa invocaci?n seg?n su modificador de carisma.
// (opcional) oCreature - Objetivo a mirar
int CheckWarlockSpellCharisma(object oCreature = OBJECT_SELF);

int CheckWarlockSpellCharisma(object oCreature = OBJECT_SELF) {
    int nSpellInnate = StringToInt(Get2DAString("spells", "Innate", GetSpellId()));
    int nCharisma = GetAbilityScore(oCreature, ABILITY_CHARISMA, TRUE);

    if (nSpellInnate > (nCharisma - 10)) {
        SendMessageToPC(oCreature, "?No tienes suficiente carisma como para hacer eso!");
        return FALSE;
    }

    //Solo si cumplimos el minimo de nivel de brujo
    if(nSpellInnate >= 8 && GetLevelByClass(57, oCreature) < 16 ) { SendMessageToPC(oCreature, "?No tienes suficiente poder como para hacer eso!");  return FALSE; }
    else if(nSpellInnate >= 6 && GetLevelByClass(57, oCreature) < 11 ) { SendMessageToPC(oCreature, "?No tienes suficiente poder como para hacer eso!");  return FALSE; }
    else if(nSpellInnate >= 4 && GetLevelByClass(57, oCreature) < 6 ) { SendMessageToPC(oCreature, "?No tienes suficiente poder como para hacer eso!");  return FALSE; }
    else if(nSpellInnate >= 2 && GetLevelByClass(57, oCreature) < 1 ) { SendMessageToPC(oCreature, "?No tienes suficiente poder como para hacer eso!");  return FALSE; }

    return TRUE;
}

int GetWarlockSpellDC(object oCreature = OBJECT_SELF, int bGolpeHorrible = FALSE, int bIgnorarEsencia = FALSE) {
    int nSpellId = GetSpellId();
    int nSpellInnate = StringToInt(Get2DAString("spells", "Innate", nSpellId));
    int nSpellLevelBonus = nSpellInnate + 1;
    int nAptitudeBonus = 0;
    int nEsencia = GetLocalInt(oCreature, "esencia_ajustes");

    //  !(Ignorar Esencia)  Explosión           Lanza               Cadena              Cono                Perdici?n
    if (!bIgnorarEsencia && (nSpellId == 1335 || nSpellId == 1337 || nSpellId == 1344 || nSpellId == 1346 || nSpellId == 1347 || bGolpeHorrible)) {
        switch(nEsencia) {
            case WARLOCK_ESENCIA_AZUFRE: case WARLOCK_ESENCIA_INFERNAL: nSpellLevelBonus = 5; break;
            case WARLOCK_ESENCIA_CAUSTICA: case WARLOCK_ESENCIA_DERRIBO: nSpellLevelBonus = 7; break;
            case WARLOCK_ESENCIA_TENEBROSA: nSpellLevelBonus = 9; break;
        }
    }

    nAptitudeBonus += GetHasFeat(1499, oCreature) ? 2 : 0;

    return 10 + nSpellLevelBonus + nAptitudeBonus + GetAbilityModifier(ABILITY_CHARISMA);
}

int GetWarlockExplosionDamage(object oCreature = OBJECT_SELF) {
    // Declaración de variables
    int nLevel = GetLevelByClass(57, oCreature);
    int nEsencia = GetLocalInt(oCreature, "esencia_ajustes");
    int nModAptitud = GetLocalInt(oCreature, "war_mod_aptitud");
    int nDam = 1;
    int nTotalDam;

     // Calcular el daño de la explosión según el nivel
    if (nLevel >= 24 )      nDam = 11;
    else if (nLevel >= 22 ) nDam = 10;
    else if (nLevel >= 20 ) nDam = 9;
    else if (nLevel >= 17)  nDam = 8;
    else if (nLevel >= 14)  nDam = 7;
    else if (nLevel >= 11)  nDam = 6;
    else if (nLevel >= 9)   nDam = 5;
    else if (nLevel >= 7)   nDam = 4;
    else if (nLevel >= 5)   nDam = 3;
    else if (nLevel >= 3)   nDam = 2;

    //Epic EldrichBlast
    if(GetHasFeat(FEAT_EPIC_WARLOCK_EXPLOSION_4, oCreature)) nDam = nDam +4;
    else if(GetHasFeat(FEAT_EPIC_WARLOCK_EXPLOSION_3, oCreature)) nDam = nDam +3;
    else if(GetHasFeat(FEAT_EPIC_WARLOCK_EXPLOSION_2, oCreature)) nDam = nDam +2;
    else if(GetHasFeat(FEAT_EPIC_WARLOCK_EXPLOSION_1, oCreature)) nDam = nDam +1;

    if (nEsencia && nEsencia != WARLOCK_ESENCIA_DERRIBO) nDam += (nEsencia != WARLOCK_ESENCIA_CAUSTICA) ? 2 : 1;

    nTotalDam = d6(nDam);

    if (nModAptitud == WARLOCK_SORTILEGA_POTENCIAR) nTotalDam = FloatToInt(nTotalDam * 1.5);
    else if (nModAptitud == WARLOCK_SORTILEGA_MAXIMIZAR) nTotalDam = nDam * 6;

    return nTotalDam;
}

void CambiarModAptitud(int nModAptitud) {
    object oPC = OBJECT_SELF;
    int nModActual = GetLocalInt(oPC, "war_mod_aptitud");

    if (nModAptitud == nModActual) {
        SetLocalInt(oPC, "war_mod_aptitud", 0);
        FloatingTextStringOnCreature("Modificaci?n de aptitud sort?lega desactivada.", oPC, FALSE);
    }
    else
    {
        switch(nModAptitud)
        {
            case WARLOCK_SORTILEGA_POTENCIAR:
                SetLocalInt(oPC, "war_mod_aptitud", WARLOCK_SORTILEGA_POTENCIAR);
                FloatingTextStringOnCreature("Aptitud sort?lega potenciada.", oPC, FALSE);
                break;

            case WARLOCK_SORTILEGA_MAXIMIZAR:
                SetLocalInt(oPC, "war_mod_aptitud", WARLOCK_SORTILEGA_MAXIMIZAR);
                FloatingTextStringOnCreature("Aptitud sort?lega maximizada.", oPC, FALSE);
                break;
        }
    }

    IncrementRemainingFeatUses(oPC, nModAptitud);
}

void UsoModAptitud() {
    object oPC = OBJECT_SELF;
    int nModAptitud = GetLocalInt(oPC, "war_mod_aptitud");

    SetLocalInt(oPC, "war_mod_aptitud", 0);
    FloatingTextStringOnCreature("Modificaci?n de aptitud sort?lega aplicada.", oPC, FALSE);
    DecrementRemainingFeatUses(oPC, nModAptitud);
}


// función utilizada para modificar la esencia activa del Brujo Arcano
int CambiarEsencia(int nEsencia)
{
    object oPC = OBJECT_SELF;
    int nEsenciaActual = GetLocalInt(oPC, "esencia_ajustes");
    string sVarName = "esencia_effectdelay_" + GetName(OBJECT_SELF);
    int nEffectDelay = GetLocalInt(GetModule(), sVarName);
    int nTimeStamp = SQLite_GetTimeStamp();

    // Si se est? desactivando la esencia o la esencia escogida es la que tiene activa actualmente, desactivar esencias
    if (nEsencia == nEsenciaActual)
    {
        effect eDur = EffectVisualEffect(460);
        if (nTimeStamp > nEffectDelay) ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oPC, RoundsToSeconds(2));
        SetLocalInt(oPC, "esencia_sobrenatural", 0);
        SetLocalInt(oPC, "esencia_ajustes", 0);
        FloatingTextStringOnCreature("Invocaci?n: Explosi?n Sobrenatural normal.", oPC, FALSE);
    }
    // Ajustar variables de esencia y el tipo de da?o de la esencia dependiendo de la esencia escogida
    else
    {
        switch(nEsencia)
        {
            case WARLOCK_ESENCIA_AZUFRE:
                SetLocalInt(oPC, "esencia_sobrenatural", DAMAGE_TYPE_FIRE);
                SetLocalInt(oPC, "esencia_ajustes", WARLOCK_ESENCIA_AZUFRE);
                FloatingTextStringOnCreature("Invocaci?n: Explosi?n de Azufre.", oPC, FALSE);
                break;

            case WARLOCK_ESENCIA_CAUSTICA:
                SetLocalInt(oPC, "esencia_sobrenatural", DAMAGE_TYPE_ACID);
                SetLocalInt(oPC, "esencia_ajustes", WARLOCK_ESENCIA_CAUSTICA);
                FloatingTextStringOnCreature("Invocaci?n: Explosi?n C?ustica.", oPC, FALSE);
                break;

            case WARLOCK_ESENCIA_INFERNAL:
                SetLocalInt(oPC, "esencia_sobrenatural", DAMAGE_TYPE_COLD);
                SetLocalInt(oPC, "esencia_ajustes", WARLOCK_ESENCIA_INFERNAL);
                FloatingTextStringOnCreature("Invocaci?n: Explosi?n del Infierno.", oPC, FALSE);
                break;

            case WARLOCK_ESENCIA_TENEBROSA:
                SetLocalInt(oPC, "esencia_sobrenatural", DAMAGE_TYPE_NEGATIVE);
                SetLocalInt(oPC, "esencia_ajustes", WARLOCK_ESENCIA_TENEBROSA);
                FloatingTextStringOnCreature("Invocaci?n: Explosi?n Tenebrosa.", oPC, FALSE);
                break;

            case WARLOCK_ESENCIA_DERRIBO:
                SetLocalInt(oPC, "esencia_sobrenatural", DAMAGE_TYPE_MAGICAL);
                SetLocalInt(oPC, "esencia_ajustes", WARLOCK_ESENCIA_DERRIBO);
                FloatingTextStringOnCreature("Invocaci?n: Explosi?n Impactante.", oPC, FALSE);
                break;
        }

        if (nTimeStamp > nEffectDelay) {
            SetLocalInt(GetModule(), sVarName, nTimeStamp+4);
            return TRUE;
        }
    }
    return FALSE;
}

// función utilizada para aplicar el da?o de fuego de la explosi?n de azufre
void AplicarDoT(object oTarget, int nDice, int nDamageType, int nSavingThrow, int nHitVFX, int nDurationVFX, int nMaxHits, int nHit = 0, int nModAptitud = 0, int bGolpeHorrible = FALSE) {
    string sVarName = "esencia_dot_" + IntToString(nDamageType);
    object oPC = OBJECT_SELF;

    int nDamage = d6(nDice);
    if (nModAptitud == WARLOCK_SORTILEGA_POTENCIAR) nDamage = FloatToInt(nDamage * 1.5);
    else if (nModAptitud == WARLOCK_SORTILEGA_MAXIMIZAR) nDamage = nDice * 6;

    effect eDam = EffectDamage(nDamage, nDamageType);
    effect eVis = EffectVisualEffect(nHitVFX);
    effect eDur = EffectVisualEffect(nDurationVFX);
    eDam = EffectLinkEffects(eVis,eDam);

    if (!GetIsDead(oTarget) && !MySavingThrow(nSavingThrow, oTarget, GetWarlockSpellDC(OBJECT_SELF, bGolpeHorrible)))
    {
        SetLocalInt(oTarget, sVarName, 1);
        ApplyEffectToObject (DURATION_TYPE_INSTANT,eDam,oTarget);

        if (nDurationVFX) ApplyEffectToObject (DURATION_TYPE_TEMPORARY,eDur,oTarget, 6.0f);

        nHit += 1;
        // Si no se ha alcanzado el m?ximo de golpes, continuar la ejecuci?n
        if (nMaxHits > nHit) DelayCommand(6.0f, AplicarDoT(oTarget, nDice, nDamageType, nSavingThrow, nHitVFX, nDurationVFX, nMaxHits, nHit, nModAptitud, bGolpeHorrible));
        else SetLocalInt(oTarget, sVarName, 0);
    }
    else SetLocalInt(oTarget, sVarName, 0);
}

//Da?o secundario de las diferentes esencias activas
void AjusteEsencia(object oTarget, int nModAptitud = 0, object oPC = OBJECT_SELF, int bGolpeHorrible = FALSE)
{
    int nEsencia = GetLocalInt(oPC, "esencia_ajustes");

    if (nEsencia == WARLOCK_ESENCIA_AZUFRE) //Explosion de Azufre
    {
        if (!GetLocalInt(oTarget, "esencia_dot_" + IntToString(DAMAGE_TYPE_FIRE)))
            AplicarDoT(oTarget, 2, DAMAGE_TYPE_FIRE, SAVING_THROW_REFLEX, VFX_IMP_FLAME_S, 498, 5, 0, nModAptitud, bGolpeHorrible);
    }

    else if (nEsencia == WARLOCK_ESENCIA_CAUSTICA) //Explosion Caustica
    {
        if (!GetLocalInt(oTarget, "esencia_dot_" + IntToString(DAMAGE_TYPE_ACID)))
            AplicarDoT(oTarget, 2, DAMAGE_TYPE_ACID, SAVING_THROW_REFLEX, 283, FALSE, 5, 0, nModAptitud, bGolpeHorrible);
    }

    else if (nEsencia == WARLOCK_ESENCIA_INFERNAL) //Explosion del Infierno
    {
        effect eDestreza = EffectAbilityDecrease(ABILITY_DEXTERITY, 4);
        effect eVis = EffectVisualEffect(VFX_IMP_FROST_L);
        effect eEffect = EffectLinkEffects(eVis,eDestreza);

        if (!MySavingThrow(SAVING_THROW_FORT, oTarget, GetWarlockSpellDC(oPC, bGolpeHorrible)))
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, TurnsToSeconds(10));
        }
    }

    else if (nEsencia == WARLOCK_ESENCIA_TENEBROSA) //Explosion Tenebrosa
    {
        effect eDrain = EffectNegativeLevel(2);
        eDrain = SupernaturalEffect(eDrain);
        effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);

        if (!MySavingThrow(SAVING_THROW_FORT, oTarget, GetWarlockSpellDC(oPC, bGolpeHorrible)))
        {
            ApplyEffectToObject (DURATION_TYPE_TEMPORARY,eDrain,oTarget, HoursToSeconds(1));
            ApplyEffectToObject (DURATION_TYPE_INSTANT, eVis, oTarget);
        }
    }

     else if (nEsencia == WARLOCK_ESENCIA_DERRIBO) //Explosion Impactante
    {
        //effect eKnock = EffectKnockdown();
        effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
        int iSize = GetCreatureSize(oTarget);
        float fDistance = 1.0 + d6();

        //Si es enorme o grande no hay derribo
        if(iSize == CREATURE_SIZE_HUGE || iSize == 22 || iSize == 23) return;
        if(GetIsImmune(oTarget, IMMUNITY_TYPE_KNOCKDOWN)) return;

        if(!GetHasSpellEffect(62, oTarget))
        {
            if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, GetWarlockSpellDC(oPC, bGolpeHorrible))) {
            //ApplyEffectToObject (DURATION_TYPE_TEMPORARY,eKnock,oTarget, RoundsToSeconds(1));
            ActionRepel(oTarget, fDistance, 6.0);
            ApplyEffectToObject (DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
    }
}
