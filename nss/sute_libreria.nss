#include "nw_i0_spells"
#include "NW_I0_GENERIC"
#include "mti_libreria"
#include "inc_sqlite_time"
#include "nostack_inc"
#include "inc_spells"

//#include "nwnx_system"
//::////////////////////////////////////////////////////////////////////////:://
//::// LIBRERIA PERSONALIZADA DE SUTEKH                                   //:://
//::////////////////////////////////////////////////////////////////////////:://
//::// MODIFICADA POR CERRIL PARA REUTILIZARLA EN EL SISTEMA DE VENENOS   //:://
//::////////////////////////////////////////////////////////////////////////:://

//Declaraciones
int bonoRealCaracteristicaPJ(int iCaracteristica, object oPC);
void FuncionCrearObjetoYTag(string sResref, object oObjetivo = OBJECT_SELF, int iAcumulable = 1, string sNombre = "", string sNuevoTag = "", int iCantidad = 1);
void usarPocionHerboristeria(object oPC, string sPocion);

void bajarAlineamiento(object oPC, int iPotencia);

//Variables Globales
int iLoop;

//Funciones
int bonoRealCaracteristicaPJ(int iCaracteristica, object oPC){
   int caracteristicaReal= GetAbilityScore(oPC, iCaracteristica, TRUE);
   int bonoReal= ((caracteristicaReal-10)/2);
   return bonoReal;
}

// CREAR OBJETO EN JUGADOR (COMPATIBLE CON DELAYS)
void FuncionCrearObjetoYTag(string sResref, object oObjetivo = OBJECT_SELF, int iAcumulable = 1, string sNombre = "", string sNuevoTag = "", int iCantidad = 1)
{
    for (iLoop = 0; iLoop < iCantidad; iLoop++) {
        object oObjetoCreado = CreateItemOnObject(sResref, oObjetivo, iAcumulable, sNuevoTag);
        if(sNombre != "") SetName(oObjetoCreado, sNombre);
        SetIdentified(oObjetoCreado, TRUE);
    }
}

void usarPocionHerboristeria(object oPC, string sPocion){
    string sNumPocion= GetSubString(sPocion, 9, 3);
    int idPocion= StringToInt(sNumPocion);
    int iDuracionRestringida= 4;
    int iDuracionNormal= 8;
    int iPotenciada= 0;

    int iCurTime = SQLite_GetTimeStamp();
    int iCoolDown = GetLocalInt(oPC, sNumPocion);

    if (iCoolDown - iCurTime > 0){
        FloatingTextStringOnCreature("*¡Tomarte la misma poción dos veces tan seguidas te produce un intenso dolor!*", oPC, FALSE);
        effect eDam = EffectDamage(d6(3),DAMAGE_TYPE_POSITIVE);
        //Apply the VFX impact and effects
        DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oPC));
        return;
    }

    if ((GetCharacterLevel(oPC)<5)&&(idPocion>70)){
        FloatingTextStringOnCreature("*¡Eres demasiado debil para aprovechar los efectos de la pocion!*", oPC, FALSE);
        return;
    }

    if (GetSubString(sPocion, 17, 1)=="d"){
        iDuracionRestringida= 6;
        iDuracionNormal= 12;
    }else if (GetSubString(sPocion, 17, 1)=="p"){
        iPotenciada= 1;
    }

    //Declaracion e inicializacion de variables para los objetivos.
    object oTarget= GetItemActivatedTarget();
    location lTarget= GetItemActivatedTargetLocation();

    //Declaracion de efectos.
    effect eApp, eApp2, eApp3, eApp4, eApp5, eApp6;
    effect eDur, eDur2;
    effect eVis, eVis2;
    effect eLink;
    effect eSearch;
    effect eAC, eRef, eAttack, eAtk, eMov;
    effect eHaste;

    //Variable auxiliares;
    float fDelay;
    int bValid;
    int nPoly;

    //Carga de efectos visuales
    if (idPocion > 128 && idPocion < 135) {
        eVis = EffectVisualEffect(259);
    }

    if (idPocion >= 135 && idPocion <141) {
        eVis = EffectVisualEffect(217);
    }

    if (idPocion == 150) {
        eVis = EffectVisualEffect(VFX_IMP_HEALING_M);
    }
    if (idPocion == 151) {
        eVis = EffectVisualEffect(VFX_IMP_HEALING_G);
    }

    switch (idPocion) {
        case 3:
            //Brumosa, 2/4
            SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_ENTROPIC_SHIELD, FALSE));

            eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
            eApp =  EffectConcealment(20, MISS_CHANCE_TYPE_VS_RANGED);
            eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            eLink = EffectLinkEffects(eApp, eDur);

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionNormal));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionNormal * 60));
            DelayCommand(TurnsToSeconds(iDuracionNormal), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 4:
            //Ferrea, 7/3
            RemoveEffectsFromSpell(oPC, SPELL_IRONGUTS);
            SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_IRONGUTS, FALSE));

            eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
            eVis2 = EffectVisualEffect(VFX_IMP_HEAD_ACID);
            eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            eApp = EffectSavingThrowIncrease(SAVING_THROW_FORT, 4, SAVING_THROW_TYPE_POISON);
            eLink = EffectLinkEffects(eApp, eDur);

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionNormal));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oPC);
            DelayCommand(0.3f,ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC));

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionNormal * 60));
            DelayCommand(TurnsToSeconds(iDuracionNormal), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 5:
            //Descorazonadora, 7
            SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_DOOM));

            eVis = EffectVisualEffect(VFX_IMP_DOOM);
            eLink = CreateDoomEffectsLink();

            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink , oPC, TurnsToSeconds(iDuracionNormal));

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionNormal * 60));
            DelayCommand(TurnsToSeconds(iDuracionNormal), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 6:
            //Mistica, 8
            SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_SLEEP));

            eApp =  EffectSleep();
            eVis2 = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
            eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
            eVis = EffectVisualEffect(VFX_IMP_SLEEP);
            eLink = EffectLinkEffects(eApp, eVis2);
            eLink = EffectLinkEffects(eLink, eDur);

            if (!GetIsImmune(oPC, IMMUNITY_TYPE_SLEEP)) {
                eLink = EffectLinkEffects(eLink, eVis);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionRestringida));
            } else {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eApp, oPC, TurnsToSeconds(iDuracionRestringida));
            }

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionRestringida * 60));
            DelayCommand(TurnsToSeconds(iDuracionRestringida), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 7:
            //Radiante, 4
            SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_LIGHT, FALSE));

            eVis = EffectVisualEffect(VFX_DUR_LIGHT_WHITE_20);
            eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            eLink = EffectLinkEffects(eVis, eDur);

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionNormal));

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionNormal * 60));
            DelayCommand(TurnsToSeconds(iDuracionNormal), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 8:
            //Refrescante, 1/1
            if (iPotenciada==0){
                SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_CURE_LIGHT_WOUNDS, FALSE));
                if (!PB_Race_GetIsUndead(oPC)) {
                    eApp = EffectHeal(d8()+10);
                    eVis = EffectVisualEffect(VFX_IMP_HEALING_S);

                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eApp, oPC);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                } else {
                    eApp = EffectDamage(d8()+10,DAMAGE_TYPE_POSITIVE);
                    eVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);

                    DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eApp, oPC));
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                }
            } else {
                SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_CURE_MODERATE_WOUNDS, FALSE));
                if (!PB_Race_GetIsUndead(oPC)) {
                    eApp = EffectHeal(d8(2)+15);
                    eVis = EffectVisualEffect(VFX_IMP_HEALING_S);

                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eApp, oPC);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                } else {
                    eApp = EffectDamage(d8(2)+15,DAMAGE_TYPE_POSITIVE);
                    eVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);

                    DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eApp, oPC));
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                }
            }
            break;
        case 9:
            //de Aislamiento, 3
             if (iPotenciada==0) {
                SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_ENDURE_ELEMENTS, FALSE));
                RemoveEffectsFromSpell(oPC, SPELL_ENDURE_ELEMENTS);

                eApp = EffectDamageResistance(DAMAGE_TYPE_COLD, 10, 20);
                eApp2 = EffectDamageResistance(DAMAGE_TYPE_FIRE, 10, 20);
                eApp3 = EffectDamageResistance(DAMAGE_TYPE_ACID, 10, 20);
                eApp4 = EffectDamageResistance(DAMAGE_TYPE_SONIC, 10, 20);
                eApp5 = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 10, 20);
            } else {
                SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_RESIST_ELEMENTS, FALSE));
                RemoveEffectsFromSpell(oPC, SPELL_RESIST_ELEMENTS);

                eApp = EffectDamageResistance(DAMAGE_TYPE_COLD, 20, 30);
                eApp2 = EffectDamageResistance(DAMAGE_TYPE_FIRE, 20, 30);
                eApp3 = EffectDamageResistance(DAMAGE_TYPE_ACID, 20, 30);
                eApp4 = EffectDamageResistance(DAMAGE_TYPE_SONIC, 20, 30);
                eApp5 = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 20, 30);
            }
            eVis = EffectVisualEffect(VFX_IMP_ELEMENTAL_PROTECTION);
            eDur = EffectVisualEffect(VFX_DUR_PROTECTION_ELEMENTS);
            eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

            eLink = EffectLinkEffects(eApp, eApp2);
            eLink = EffectLinkEffects(eLink, eApp3);
            eLink = EffectLinkEffects(eLink, eApp4);
            eLink = EffectLinkEffects(eLink, eApp5);
            eLink = EffectLinkEffects(eLink, eDur);
            eLink = EffectLinkEffects(eLink, eDur2);

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionNormal));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionNormal * 60));
            DelayCommand(TurnsToSeconds(iDuracionNormal), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 10:
            //Acustica, 2
            eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
            eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            eApp = EffectSkillIncrease(SKILL_LISTEN, 20);
            eLink = EffectLinkEffects(eApp, eDur);
            if(!GetHasSpellEffect(SPELL_AMPLIFY, oPC)) {
                RemoveEffectsFromSpell(oTarget, 442);
                SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_AMPLIFY, FALSE));
                RemoveEffectsFromSpell(oTarget, 186);
                RemoveEffectsFromSpell(oTarget, 20);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionRestringida));
            }

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionRestringida * 60));
            DelayCommand(TurnsToSeconds(iDuracionRestringida), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 11:
            //de Perseverancia, 6
            SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_RESISTANCE, FALSE));

            eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
            eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            eApp = EffectSavingThrowIncrease(SAVING_THROW_ALL, 1);
            eLink = EffectLinkEffects(eApp, eDur);

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionNormal));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionNormal * 60));
            DelayCommand(TurnsToSeconds(iDuracionNormal), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 12:
            //Turbia 1/7
            eApp = EffectPoison(POISON_CHAOS_MIST);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eApp, oPC);
            break;
        case 13:
            //Desconcertante 8/7
            eApp = EffectPoison(POISON_ID_MOSS);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eApp, oPC);
            break;
        case 14:
            //Mohosa 2/7
            eApp = EffectPoison(POISON_UNGOL_DUST);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eApp, oPC);
            break;
        case 15:
            //Brillante 1/6
            SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_CLARITY, FALSE));

            eApp = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
            eApp2 = EffectDamage(1, DAMAGE_TYPE_NEGATIVE);
            eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);
            eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            eLink = EffectLinkEffects(eApp, eVis);
            eLink = EffectLinkEffects(eLink, eDur);

            eSearch = GetFirstEffect(oPC);
            while(GetIsEffectValid(eSearch)) {
                bValid = FALSE;
                if (GetEffectType(eSearch) == EFFECT_TYPE_DAZED ||
                    GetEffectType(eSearch) == EFFECT_TYPE_CHARMED ||
                    GetEffectType(eSearch) == EFFECT_TYPE_SLEEP ||
                    GetEffectType(eSearch) == EFFECT_TYPE_CONFUSED ||
                    GetEffectType(eSearch) == EFFECT_TYPE_STUNNED) {
                    bValid = TRUE;
                }

                if (bValid) {
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eApp2, oPC);
                    RemoveEffect(oPC, eSearch);
                }

                eSearch = GetNextEffect(oPC);
            }

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionRestringida));

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionRestringida * 60));
            DelayCommand(TurnsToSeconds(iDuracionRestringida), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 16:
            //Rojiza, 7/1
            if (iPotenciada==0){
               SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_INFLICT_LIGHT_WOUNDS, FALSE));
                if (PB_Race_GetIsUndead(oPC)) {
                   eApp = EffectHeal(d8()+10);
                   eVis2 = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);

                   ApplyEffectToObject(DURATION_TYPE_INSTANT, eApp, oPC);
                   ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oPC);
               } else {
                   eApp = EffectDamage(d8()+10,DAMAGE_TYPE_NEGATIVE);
                   eVis = EffectVisualEffect(VFX_IMP_HARM);

                   DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eApp, oPC));
                   ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
               }
            } else {
               SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_INFLICT_MODERATE_WOUNDS, FALSE));
                if (PB_Race_GetIsUndead(oPC)) {
                   eApp = EffectHeal(d8(2)+15);
                   eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);

                   ApplyEffectToObject(DURATION_TYPE_INSTANT, eApp, oPC);
                   ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                   //Fire cast spell at event for the specified target
               } else {
                   eApp = EffectDamage(d8(2)+15,DAMAGE_TYPE_NEGATIVE);
                   eVis = EffectVisualEffect(VFX_IMP_HARM);

                   DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eApp, oPC));
                   ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
               }
            }
            break;
        case 17:
            //Inconsistente 3/7
            eApp = EffectPoison(POISON_MEDIUM_SPIDER_VENOM);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eApp, oPC);
            break;
        case 18:
            //Viscosa 4/7
            eApp = EffectPoison(POISON_TERINAV_ROOT);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eApp, oPC);
            break;
        case 19:
            //Grumosa 5/7
            eApp = EffectPoison(POISON_SASSONE_LEAF_RESIDUE);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eApp, oPC);
            break;
        case 20:
            //Reconfortante 7/5/1
            SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_REMOVE_DISEASE, FALSE));

            eVis = EffectVisualEffect(VFX_IMP_REMOVE_CONDITION);
            eSearch = GetFirstEffect(oPC);
            while(GetIsEffectValid(eSearch)) {
                if (GetEffectType(eSearch) == EFFECT_TYPE_DISEASE) {
                    RemoveEffect(oPC, eSearch);
                    bValid = TRUE;
                }
                //Get the next effect on the target
                eSearch = GetNextEffect(oPC);
            }

            if (bValid) {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
            }
            break;
        case 21:
            //Blanquecina 7/3/4
            SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_STONE_BONES, FALSE));
            RemoveEffectsFromSpell(oPC, SPELL_STONE_BONES);

            eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
            eApp = EffectACIncrease(3, AC_NATURAL_BONUS);
            eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            eLink = EffectLinkEffects(eApp, eDur);

            if(PB_Race_GetIsUndead(oPC)) {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionNormal));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
            } else {
                FloatingTextStrRefOnCreature(85390,oPC); // only affects undead;
            }

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionNormal * 60));
            DelayCommand(TurnsToSeconds(iDuracionNormal), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 22:
            //Opaca 2/2/7
            SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_BLINDNESS_AND_DEAFNESS));

            eApp =  EffectBlindness();
            eApp2 = EffectDeaf();
            eVis = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
            eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
            eLink = EffectLinkEffects(eApp, eApp2);
            eLink = EffectLinkEffects(eLink, eDur);

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionRestringida));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionRestringida * 60));
            DelayCommand(TurnsToSeconds(iDuracionRestringida), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 23:
            //Furiosa 4/4/5
            AssignCommand(oPC, ClearAllActions(TRUE));
            AssignCommand(oPC, ActionCastSpellAtObject(SPELL_BLOOD_FRENZY, oPC, METAMAGIC_ANY, TRUE, 40, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
            DelayCommand(0.2, SetCommandable(FALSE, oPC));
            DelayCommand(2.0, SetCommandable(TRUE, oPC));

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionRestringida * 60));
            DelayCommand(TurnsToSeconds(iDuracionRestringida), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 24:
            //de Soporte 6/4
            SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_AID, FALSE));

            eApp = EffectAttackIncrease(1);
            eApp2 = EffectSavingThrowIncrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_FEAR);
            eApp3 = EffectTemporaryHitpoints(d8(1));
            eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);

            eLink = EffectLinkEffects(eApp, eApp2);
            eLink = EffectLinkEffects(eLink, eDur);

            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionNormal));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eApp3, oPC, TurnsToSeconds(iDuracionNormal));

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionNormal * 60));
            DelayCommand(TurnsToSeconds(iDuracionNormal), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 25:
            //Densa 4/2/7
            SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_SLOW));

            eApp = EffectSlow();
            eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
            eLink = EffectLinkEffects(eApp, eDur);
            eVis = EffectVisualEffect(VFX_IMP_SLOW);
            eVis2 = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);

            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis2, GetLocation(oPC));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionRestringida));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionRestringida * 60));
            DelayCommand(TurnsToSeconds(iDuracionRestringida), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 26:
            //de Lentitud 8/2/7
            SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_FEEBLEMIND));

            eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
            eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
            eApp = EffectAbilityDecrease(ABILITY_INTELLIGENCE, d4(2));
            eLink = EffectLinkEffects(eApp, eDur);

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionRestringida));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionRestringida * 60));
            DelayCommand(TurnsToSeconds(iDuracionRestringida), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 41:
            //Purificadora 7/7/1
            SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_NEUTRALIZE_POISON, FALSE));

            eVis = EffectVisualEffect(VFX_IMP_REMOVE_CONDITION);
            eSearch = GetFirstEffect(oPC);
            while(GetIsEffectValid(eSearch)) {
                if (GetEffectType(eSearch) == EFFECT_TYPE_POISON) {
                    RemoveEffect(oPC, eSearch);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                }
                //Get next effect on target
                eSearch = GetNextEffect(oPC);
            }
            break;
        case 42:
            //de Atraccion 2/5
            AssignCommand(oPC, ClearAllActions(TRUE));
            AssignCommand(oPC, ActionCastSpellAtObject(SPELL_EAGLE_SPLEDOR, oPC, METAMAGIC_ANY, TRUE, 3, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
            DelayCommand(0.2, SetCommandable(FALSE, oPC));
            DelayCommand(2.0, SetCommandable(TRUE, oPC));

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionNormal * 60));
            DelayCommand(TurnsToSeconds(iDuracionNormal), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 43:
            //de Intuicion 1/5
            AssignCommand(oPC, ClearAllActions(TRUE));
            AssignCommand(oPC, ActionCastSpellAtObject(SPELL_OWLS_WISDOM, oPC, METAMAGIC_ANY, TRUE, 3, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
            DelayCommand(0.2, SetCommandable(FALSE, oPC));
            DelayCommand(2.0, SetCommandable(TRUE, oPC));

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionNormal * 60));
            DelayCommand(TurnsToSeconds(iDuracionNormal), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 44:
            //de Deduccion 8/5
            AssignCommand(oPC, ClearAllActions(TRUE));
            AssignCommand(oPC, ActionCastSpellAtObject(SPELL_FOXS_CUNNING, oPC, METAMAGIC_ANY, TRUE, 3, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
            DelayCommand(0.2, SetCommandable(FALSE, oPC));
            DelayCommand(2.0, SetCommandable(TRUE, oPC));

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionNormal * 60));
            DelayCommand(TurnsToSeconds(iDuracionNormal), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 45:
            //Agitada 4/4
            if (GetHasSpellEffect(SPELL_HASTE, oPC) == TRUE) return;
            SignalEvent(oPC, EventSpellCastAt(oPC, 455, FALSE));

            eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            eApp = EffectMovementSpeedIncrease(150);
            eLink = EffectLinkEffects(eApp, eDur);

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionRestringida));

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionRestringida * 60));
            DelayCommand(TurnsToSeconds(iDuracionRestringida), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 46:
            //Sensorial 2/2/1
            SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_REMOVE_BLINDNESS_AND_DEAFNESS, FALSE));

            eVis = EffectVisualEffect(VFX_IMP_REMOVE_CONDITION);
            eSearch = GetFirstEffect(oPC);
            while(GetIsEffectValid(eSearch)) {
                if ((GetEffectType(eSearch) == EFFECT_TYPE_DEAF) || (GetEffectType(eSearch) == EFFECT_TYPE_BLINDNESS)) {
                    RemoveEffect(oPC, eSearch);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                }
                eSearch = GetNextEffect(oPC);
            }
            break;
        case 47:
            //de Dureza 5/5
            AssignCommand(oPC, ClearAllActions(TRUE));
            AssignCommand(oPC, ActionCastSpellAtObject(SPELL_ENDURANCE, oPC, METAMAGIC_ANY, TRUE, 3, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
            DelayCommand(0.2, SetCommandable(FALSE, oPC));
            DelayCommand(2.0, SetCommandable(TRUE, oPC));

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionNormal * 60));
            DelayCommand(TurnsToSeconds(iDuracionNormal), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 48:
            //de Robustez 3/5
            AssignCommand(oPC, ClearAllActions(TRUE));
            AssignCommand(oPC, ActionCastSpellAtObject(SPELL_BULLS_STRENGTH, oPC, METAMAGIC_ANY, TRUE, 3, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
            DelayCommand(0.2, SetCommandable(FALSE, oPC));
            DelayCommand(2.0, SetCommandable(TRUE, oPC));

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionNormal * 60));
            DelayCommand(TurnsToSeconds(iDuracionNormal), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 49:
            //de Agilidad 4/5
            AssignCommand(oPC, ClearAllActions(TRUE));
            AssignCommand(oPC, ActionCastSpellAtObject(SPELL_CATS_GRACE, oPC, METAMAGIC_ANY, TRUE, 3, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
            DelayCommand(0.2, SetCommandable(FALSE, oPC));
            DelayCommand(2.0, SetCommandable(TRUE, oPC));

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionNormal * 60));
            DelayCommand(TurnsToSeconds(iDuracionNormal), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 50:
            //de Proteccion 1/3/4
            SignalEvent(oPC, EventSpellCastAt(oPC, 421, FALSE));

            eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
            eApp = EffectACIncrease(3, AC_DEFLECTION_BONUS);
            eDur = EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR);
            eLink = EffectLinkEffects(eApp, eDur);

            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionNormal));

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionNormal * 60));
            DelayCommand(TurnsToSeconds(iDuracionNormal), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 51:
            //Curativa, 1/1/5
            if (iPotenciada==0){
                SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_CURE_SERIOUS_WOUNDS, FALSE));
                if (!PB_Race_GetIsUndead(oPC)) {
                    eApp = EffectHeal(d8(3)+15);
                    eVis = EffectVisualEffect(VFX_IMP_HEALING_S);

                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eApp, oPC);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
               } else {
                    eApp = EffectDamage(d8(3)+15,DAMAGE_TYPE_POSITIVE);
                    eVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);

                    DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eApp, oPC));
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
               }
            } else {
                SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_CURE_CRITICAL_WOUNDS, FALSE));
                if (!PB_Race_GetIsUndead(oPC)) {
                    eApp = EffectHeal(d8(4)+22);
                    eVis = EffectVisualEffect(VFX_IMP_HEALING_S);

                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eApp, oPC);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
               } else {
                    eApp = EffectDamage(d8(4)+22,DAMAGE_TYPE_POSITIVE);
                    eVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);

                    DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eApp, oPC));
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
               }
            }
            break;
        case 52:
            //Borrosa 8/8/4
            if (iPotenciada==0){
                SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_GHOSTLY_VISAGE, FALSE));

                eVis = EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE);
                eApp = EffectDamageReduction(5, DAMAGE_POWER_PLUS_ONE);
                eApp2 = EffectSpellLevelAbsorption(1);
                eApp3 = EffectConcealment(10);
                eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
                eLink = EffectLinkEffects(eApp, eVis);
                eLink = EffectLinkEffects(eLink, eApp2);
                eLink = EffectLinkEffects(eLink, eApp3);
                eLink = EffectLinkEffects(eLink, eDur);

                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionNormal));
            }else{
                SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_ETHEREAL_VISAGE, FALSE));

                eVis = EffectVisualEffect(VFX_DUR_ETHEREAL_VISAGE);
                eApp = EffectDamageReduction(20, DAMAGE_POWER_PLUS_THREE);
                eApp2 = EffectSpellLevelAbsorption(2);
                eApp3 = EffectConcealment(25);
                eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
                eLink = EffectLinkEffects(eApp, eVis);
                eLink = EffectLinkEffects(eLink, eApp2);
                eLink = EffectLinkEffects(eLink, eApp3);
                eLink = EffectLinkEffects(eLink, eDur);

                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionNormal));
            }

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionNormal * 60));
            DelayCommand(TurnsToSeconds(iDuracionNormal), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 53:
            //Omniosa 7/7/5
            SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_BESTOW_CURSE));

            eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
            eApp = EffectCurse(2, 2, 2, 2, 2, 2);
            eApp = SupernaturalEffect(eApp);

            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eApp, oPC);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
            break;
        case 54:
            //Nocturna 2/7/2
            SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_DARKVISION, FALSE));

            eVis = EffectVisualEffect(VFX_DUR_ULTRAVISION);
            eVis2 = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
            eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            eApp = EffectUltravision();
            eLink = EffectLinkEffects(eVis, eDur);
            eLink = EffectLinkEffects(eLink, eVis2);
            eLink = EffectLinkEffects(eLink, eApp);

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionNormal));

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionNormal * 60));
            DelayCommand(TurnsToSeconds(iDuracionNormal), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 55:
            //Reparadora 5/3/1
            if (iPotenciada==0){
                RemoveEffectsFromSpell(oPC, SPELL_MONSTROUS_REGENERATION);
                SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_MONSTROUS_REGENERATION, FALSE));

                eApp = EffectRegenerate(5, 6.0);
                eVis = EffectVisualEffect(VFX_IMP_HEAD_NATURE);
                eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
                eLink = EffectLinkEffects(eApp, eDur);

                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionRestringida));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
            }else{
                RemoveEffectsFromSpell(oPC, SPELL_REGENERATE);
                SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_REGENERATE, FALSE));

                eApp = EffectRegenerate(8, 6.0);
                eVis = EffectVisualEffect(VFX_IMP_HEAD_NATURE);
                eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
                eLink = EffectLinkEffects(eApp, eDur);

                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionRestringida));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
            }

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionRestringida * 60));
            DelayCommand(TurnsToSeconds(iDuracionRestringida), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 56:
            //Carmesi 7/1/5
            if (iPotenciada==0){
                SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_INFLICT_SERIOUS_WOUNDS, FALSE));
                if (PB_Race_GetIsUndead(oPC)) {
                    eApp = EffectHeal(d8(3)+15);
                    eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);

                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eApp, oPC);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
               } else {
                    eApp = EffectDamage(d8(3)+15,DAMAGE_TYPE_NEGATIVE);
                    eVis = EffectVisualEffect(VFX_IMP_HARM);

                    DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eApp, oPC));
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
               }
            } else {
                SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_INFLICT_CRITICAL_WOUNDS, FALSE));
                if (PB_Race_GetIsUndead(oPC)) {
                    eApp = EffectHeal(d8(4)+22);
                    eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);

                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eApp, oPC);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
               } else {
                    eApp = EffectDamage(d8(4)+22,DAMAGE_TYPE_NEGATIVE);
                    eVis = EffectVisualEffect(VFX_IMP_HARM);

                    DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eApp, oPC));
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
               }
            }
            break;
        case 57:
            //Nudosa 3/1/4
            SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_BARKSKIN, FALSE));

            eVis = EffectVisualEffect(VFX_DUR_PROT_BARKSKIN);
            eVis2 = EffectVisualEffect(VFX_IMP_HEAD_NATURE);
            eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            eApp = EffectACIncrease(3, AC_NATURAL_BONUS);
            eLink = EffectLinkEffects(eVis, eApp);
            eLink = EffectLinkEffects(eLink, eDur);

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionNormal));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oPC);

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionNormal * 60));
            DelayCommand(TurnsToSeconds(iDuracionNormal), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 58:
            //Repulsiva 2/7/5
            eApp = EffectDisease(DISEASE_RED_SLAAD_EGGS);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eApp, oPC);
            break;
        case 59:
            //Obtusa 8/7/5
            eApp = EffectDisease(DISEASE_BURROW_MAGGOTS);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eApp, oPC);
            break;
        case 60:
            //Atontadora 1/7/5
            eApp = EffectDisease(DISEASE_BURROW_MAGGOTS);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eApp, oPC);
            break;
        case 61:
            //de Barrera 1/2/4
            RemoveEffectsFromSpell(oPC, 417);
            SignalEvent(oPC, EventSpellCastAt(oPC, 417, FALSE));

            eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
            eApp = EffectACIncrease(4, AC_DEFLECTION_BONUS);
            eApp2 = EffectSpellImmunity(SPELL_MAGIC_MISSILE);
            eDur = EffectVisualEffect(VFX_DUR_GLOBE_MINOR);
            eLink = EffectLinkEffects(eApp, eDur);
            eLink = EffectLinkEffects(eLink, eApp2);

            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionNormal));

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionNormal * 60));
            DelayCommand(TurnsToSeconds(iDuracionNormal), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 62:
            //Bendita 7/8/6
            SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_REMOVE_CURSE, FALSE));

            eVis = EffectVisualEffect(VFX_IMP_REMOVE_CONDITION);
            eSearch = GetFirstEffect(oPC);
            while(GetIsEffectValid(eSearch)) {
                if (GetEffectType(eSearch) == EFFECT_TYPE_CURSE) {
                    RemoveEffect(oPC, eSearch);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                }
                //Get the next effect on the target
                eSearch = GetNextEffect(oPC);
            }
            break;
        case 63:
            //Malsana 5/7/5
            eApp = EffectPoison(POISON_BEBILITH_VENOM);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eApp, oPC);
            break;
        case 64:
            //Agarrotadora 4/7/5
            eApp = EffectPoison(POISON_GIANT_WASP_POISON);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eApp, oPC);
            break;
        case 65:
            //Debilitante 3/7/5
            eApp = EffectPoison(POISON_LICH_DUST);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eApp, oPC);
            break;
        case 66:
            //de Alivio 7/6/1
            if (iPotenciada==0){
                SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_LESSER_RESTORATION, FALSE));

                eVis = EffectVisualEffect(VFX_IMP_RESTORATION_LESSER);
                eSearch = GetFirstEffect(oPC);
                while(GetIsEffectValid(eSearch)) {
                    if (GetEffectType(eSearch) == EFFECT_TYPE_ABILITY_DECREASE ||
                        GetEffectType(eSearch) == EFFECT_TYPE_AC_DECREASE ||
                        GetEffectType(eSearch) == EFFECT_TYPE_ATTACK_DECREASE ||
                        GetEffectType(eSearch) == EFFECT_TYPE_DAMAGE_DECREASE ||
                        GetEffectType(eSearch) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
                        GetEffectType(eSearch) == EFFECT_TYPE_SAVING_THROW_DECREASE ||
                        GetEffectType(eSearch) == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
                        GetEffectType(eSearch) == EFFECT_TYPE_SKILL_DECREASE)
                    {
                        //Remove effect if it is negative.
                        RemoveEffect(oPC, eSearch);
                    }
                    eSearch = GetNextEffect(oPC);
                }

                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
            }else{
                SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_RESTORATION, FALSE));

                eVis = EffectVisualEffect(VFX_IMP_RESTORATION);
                eSearch = GetFirstEffect(oPC);
                while(GetIsEffectValid(eSearch))
                {
                    if (GetEffectType(eSearch) == EFFECT_TYPE_ABILITY_DECREASE ||
                        GetEffectType(eSearch) == EFFECT_TYPE_AC_DECREASE ||
                        GetEffectType(eSearch) == EFFECT_TYPE_ATTACK_DECREASE ||
                        GetEffectType(eSearch) == EFFECT_TYPE_DAMAGE_DECREASE ||
                        GetEffectType(eSearch) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
                        GetEffectType(eSearch) == EFFECT_TYPE_SAVING_THROW_DECREASE ||
                        GetEffectType(eSearch) == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
                        GetEffectType(eSearch) == EFFECT_TYPE_SKILL_DECREASE ||
                        GetEffectType(eSearch) == EFFECT_TYPE_BLINDNESS ||
                        GetEffectType(eSearch) == EFFECT_TYPE_DEAF ||
                        GetEffectType(eSearch) == EFFECT_TYPE_PARALYZE ||
                        GetEffectType(eSearch) == EFFECT_TYPE_NEGATIVELEVEL)
                        {
                           RemoveEffect(oPC, eSearch);
                        }
                    eSearch = GetNextEffect(oPC);
                }
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
            }
            break;
        case 67:
            //de Desvio 2/1/4
            RemoveEffectsFromSpell(oPC, SPELL_MAGE_ARMOR);
            SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_MAGE_ARMOR, FALSE));

            eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
            eApp = EffectACIncrease(1, AC_ARMOUR_ENCHANTMENT_BONUS);
            eApp2 = EffectACIncrease(1, AC_DEFLECTION_BONUS);
            eApp3 = EffectACIncrease(1, AC_DODGE_BONUS);
            eApp4 = EffectACIncrease(1, AC_NATURAL_BONUS);
            eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            eLink = EffectLinkEffects(eApp, eApp2);
            eLink = EffectLinkEffects(eLink, eApp3);
            eLink = EffectLinkEffects(eLink, eApp4);
            eLink = EffectLinkEffects(eLink, eDur);

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionNormal));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionNormal * 60));
            DelayCommand(TurnsToSeconds(iDuracionNormal), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 68:
            //Transparente 2/8/7
            if (iPotenciada==0){
               SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_INVISIBILITY, FALSE));

               eApp = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
               eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
               eLink = EffectLinkEffects(eApp, eDur);

               ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionRestringida));
            }else{
               SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_IMPROVED_INVISIBILITY, FALSE));

               eVis2 = EffectVisualEffect(VFX_IMP_HEAD_MIND);
               eApp = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
               eVis = EffectVisualEffect(VFX_DUR_INVISIBILITY);
               eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
               eApp2 = EffectConcealment(50);
               eLink = EffectLinkEffects(eDur, eApp2);
               eLink = EffectLinkEffects(eLink, eVis);

               ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oPC);
               ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionRestringida));
               ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eApp, oPC, TurnsToSeconds(iDuracionRestringida));
            }

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionRestringida * 60));
            DelayCommand(TurnsToSeconds(iDuracionRestringida), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 69:
            //de Absorcion 8/6/3
            SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_SPELL_RESISTANCE, FALSE));

            eApp = EffectSpellResistanceIncrease(20);
            eVis = EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION);
            eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            eDur2 = EffectVisualEffect(249);
            eLink = EffectLinkEffects(eApp, eDur);
            eLink = EffectLinkEffects(eLink, eDur2);

            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionNormal));

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionNormal * 60));
            DelayCommand(TurnsToSeconds(iDuracionNormal), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 70:
            //Consciente 2/2/5
            eVis = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
            eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            eLink = EffectLinkEffects(eLink, eVis);
            eLink = EffectLinkEffects(eLink, eDur);
            //Si no tenemos el conjuro clarividencia y tampoco el de amplificar.
            if(!GetHasSpellEffect(SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE, oPC) && !GetHasSpellEffect(SPELL_AMPLIFY, oPC)) {
                RemoveEffectsFromSpell(oTarget, 20);
                SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE, FALSE));
                RemoveEffectsFromSpell(oTarget, 186);
                RemoveEffectsFromSpell(oTarget, 442);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(iDuracionRestringida));
                DoNoStackSkillBonus(OBJECT_SELF, oTarget, 10, SKILL_SPOT, TurnsToSeconds(iDuracionRestringida));
                DoNoStackSkillBonus(OBJECT_SELF, oTarget, 10, SKILL_LISTEN, TurnsToSeconds(iDuracionRestringida));
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionRestringida));
            }

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionRestringida * 60));
            DelayCommand(TurnsToSeconds(iDuracionRestringida), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 71:
            //Evolutiva 5/5/8
            SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_POLYMORPH_SELF, FALSE));

            eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
            switch (d6()) {
                case 1:
                    nPoly = POLYMORPH_TYPE_GIANT_SPIDER;
                    break;
                case 2:
                    nPoly = POLYMORPH_TYPE_TROLL;
                    break;
                case 3:
                    nPoly = POLYMORPH_TYPE_UMBER_HULK;
                    break;
                case 4:
                    nPoly = POLYMORPH_TYPE_PIXIE;
                    break;
                case 5:
                    nPoly = POLYMORPH_TYPE_ZOMBIE;
                    break;
                case 6:
                    nPoly = POLYMORPH_TYPE_CHICKEN;
                    break;
            }
            eApp = EffectPolymorph(nPoly);

            AssignCommand(oPC, ClearAllActions());
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eApp, oPC, TurnsToSeconds(iDuracionNormal));

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionNormal * 60));
            DelayCommand(TurnsToSeconds(iDuracionNormal), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 72:
            //Polvorienta 3/4/3
            if (iPotenciada==0){
               RemoveEffectsFromSpell(oPC, SPELL_STONESKIN);
               SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_STONESKIN, FALSE));

               eApp = EffectDamageReduction(10, DAMAGE_POWER_PLUS_FIVE, 70);
               eVis2 = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
            }else{
               RemoveEffectsFromSpell(oPC, SPELL_GREATER_STONESKIN);
               SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_GREATER_STONESKIN, FALSE));

               eApp = EffectDamageReduction(20, DAMAGE_POWER_PLUS_FIVE, 110);
               eVis2 = EffectVisualEffect(VFX_IMP_POLYMORPH);
            }

            eVis = EffectVisualEffect(VFX_DUR_PROT_STONESKIN);
            eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            eLink = EffectLinkEffects(eApp, eVis);
            eLink = EffectLinkEffects(eLink, eDur);

            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oPC);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionNormal));

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionNormal * 60));
            DelayCommand(TurnsToSeconds(iDuracionNormal), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 73:
            //Replandeciente 2/2/2
            SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_SEE_INVISIBILITY, FALSE));

            eVis = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
            eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            eApp = EffectSeeInvisible();
            eLink = EffectLinkEffects(eVis, eApp);
            eLink = EffectLinkEffects(eLink, eDur);

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionRestringida));

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionRestringida * 60));
            DelayCommand(TurnsToSeconds(iDuracionRestringida), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 74:
            //Disipadora 3/3/5
            if (iPotenciada==0){
                RemoveEffectsFromSpell(oPC, SPELL_PROTECTION_FROM_ELEMENTS);
                SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_PROTECTION_FROM_ELEMENTS, FALSE));

                eApp = EffectDamageResistance(DAMAGE_TYPE_COLD, 30, 40);
                eApp2 = EffectDamageResistance(DAMAGE_TYPE_FIRE, 30, 40);
                eApp3 = EffectDamageResistance(DAMAGE_TYPE_ACID, 30, 40);
                eApp4 = EffectDamageResistance(DAMAGE_TYPE_SONIC, 30, 40);
                eApp5 = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 30, 40);
                eDur = EffectVisualEffect(VFX_DUR_PROTECTION_ELEMENTS);
            }else{
                RemoveEffectsFromSpell(oPC, SPELL_ENERGY_BUFFER);
                SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_ENERGY_BUFFER, FALSE));

                eApp = EffectDamageResistance(DAMAGE_TYPE_COLD, 40, 60);
                eApp2 = EffectDamageResistance(DAMAGE_TYPE_FIRE, 40, 60);
                eApp3 = EffectDamageResistance(DAMAGE_TYPE_ACID, 40, 60);
                eApp4 = EffectDamageResistance(DAMAGE_TYPE_SONIC, 40, 60);
                eApp5 = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 40, 60);
                eDur = EffectVisualEffect(VFX_DUR_PROTECTION_ELEMENTS);
            }
            eVis = EffectVisualEffect(VFX_IMP_ELEMENTAL_PROTECTION);
            eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            eLink = EffectLinkEffects(eApp, eApp2);
            eLink = EffectLinkEffects(eLink, eApp3);
            eLink = EffectLinkEffects(eLink, eApp4);
            eLink = EffectLinkEffects(eLink, eApp5);
            eLink = EffectLinkEffects(eLink, eDur);
            eLink = EffectLinkEffects(eLink, eDur2);

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionNormal));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionNormal * 60));
            DelayCommand(TurnsToSeconds(iDuracionNormal), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 89:
            //de Verdad 8/7/2
            eVis = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
            eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            eApp = EffectSkillIncrease(SKILL_SPOT, 5);
            eApp2 = EffectSeeInvisible();
            eApp3 = EffectUltravision();
            eApp4 = EffectSpellImmunity(SPELL_PHANTASMAL_KILLER);
            eApp5 = EffectSpellImmunity(SPELL_WEIRD);
            eLink = EffectLinkEffects(eVis, eApp);
            eLink = EffectLinkEffects(eLink, eApp2);
            eLink = EffectLinkEffects(eLink, eApp3);
            eLink = EffectLinkEffects(eLink, eApp4);
            eLink = EffectLinkEffects(eLink, eApp5);
            eLink = EffectLinkEffects(eLink, eDur);

            if (!GetHasSpellEffect(SPELL_TRUE_SEEING, oPC)) {
                RemoveEffectsFromSpell(oTarget, 186);
                SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_TRUE_SEEING, FALSE));
                RemoveEffectsFromSpell(oTarget, 442);
                RemoveEffectsFromSpell(oTarget, 20);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionRestringida));
            }

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionRestringida * 60));
            DelayCommand(TurnsToSeconds(iDuracionRestringida), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 90:
            //Translucida 2/4/8
            SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_DISPLACEMENT, FALSE));

            eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
            eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            eApp = EffectConcealment(50);
            eLink = EffectLinkEffects(eApp, eDur);

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionRestringida));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionRestringida * 60));
            DelayCommand(TurnsToSeconds(iDuracionRestringida), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 91:
            //Negra 6/1/6
            SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_PROTECTION_FROM_GOOD, FALSE));

            eApp = EffectACIncrease(2, AC_DEFLECTION_BONUS);
            eApp2 = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2);
            eApp3 = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);

            eApp = VersusAlignmentEffect(eApp, ALIGNMENT_ALL, ALIGNMENT_GOOD);
            eApp2 = VersusAlignmentEffect(eApp2,ALIGNMENT_ALL, ALIGNMENT_GOOD);
            eApp3 = VersusAlignmentEffect(eApp3,ALIGNMENT_ALL, ALIGNMENT_GOOD);

            eDur = EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MINOR);
            eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

            eLink = EffectLinkEffects(eApp, eApp2);
            eLink = EffectLinkEffects(eLink, eApp3);
            eLink = EffectLinkEffects(eLink, eDur);
            eLink = EffectLinkEffects(eLink, eDur2);

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionNormal));

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionNormal * 60));
            DelayCommand(TurnsToSeconds(iDuracionNormal), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 92:
            //Blanca 7/1/6
            SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_PROTECTION_FROM_EVIL, FALSE));

            eApp = EffectACIncrease(2, AC_DEFLECTION_BONUS);
            eApp2 = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2);
            eApp3 = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);

            eApp = VersusAlignmentEffect(eApp,ALIGNMENT_ALL, ALIGNMENT_EVIL);
            eApp2 = VersusAlignmentEffect(eApp2,ALIGNMENT_ALL, ALIGNMENT_EVIL);
            eApp3 = VersusAlignmentEffect(eApp3,ALIGNMENT_ALL, ALIGNMENT_EVIL);

            eDur = EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR);
            eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

            eLink = EffectLinkEffects(eApp, eApp2);
            eLink = EffectLinkEffects(eLink, eApp3);
            eLink = EffectLinkEffects(eLink, eDur);
            eLink = EffectLinkEffects(eLink, eDur2);

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionNormal));

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionNormal * 60));
            DelayCommand(TurnsToSeconds(iDuracionNormal), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 93:
            //Tenaz 4/6/6
            SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_FREEDOM_OF_MOVEMENT, FALSE));

            eApp = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
            eApp2 = EffectImmunity(IMMUNITY_TYPE_ENTANGLE);
            eApp3 = EffectImmunity(IMMUNITY_TYPE_SLOW);
            eApp4 = EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE);
            eVis = EffectVisualEffect(VFX_DUR_FREEDOM_OF_MOVEMENT);
            eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

            eLink = EffectLinkEffects(eApp, eApp2);
            eLink = EffectLinkEffects(eLink, eApp3);
            eLink = EffectLinkEffects(eLink, eApp4);
            eLink = EffectLinkEffects(eLink, eVis);
            eLink = EffectLinkEffects(eLink, eDur);

            eSearch = GetFirstEffect(oPC);
            while(GetIsEffectValid(eSearch)) {
                if(GetEffectType(eSearch) == EFFECT_TYPE_PARALYZE ||
                    GetEffectType(eSearch) == EFFECT_TYPE_ENTANGLE ||
                    GetEffectType(eSearch) == EFFECT_TYPE_SLOW ||
                    GetEffectType(eSearch) == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE)
                {
                    RemoveEffect(oPC, eSearch);
                }
                eSearch = GetNextEffect(oPC);
            }

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionNormal));

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionNormal * 60));
            DelayCommand(TurnsToSeconds(iDuracionNormal), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 94:
            //Oscura 7/4/6
            RemoveEffectsFromSpell(oPC, SPELL_DEATH_ARMOR);
            SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_DEATH_ARMOR, FALSE));

            eApp = EffectDamageShield(1, DAMAGE_BONUS_1d4, DAMAGE_TYPE_MAGICAL);
            eDur = EffectVisualEffect(463);
            eLink = EffectLinkEffects(eApp, eDur);

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionRestringida));

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionRestringida * 60));
            DelayCommand(TurnsToSeconds(iDuracionRestringida), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 95:
            //de Poder 3/4/5
            AssignCommand(oPC, ClearAllActions(TRUE));
            AssignCommand(oPC, ActionCastSpellAtObject(SPELL_DIVINE_POWER, oPC, METAMAGIC_ANY, TRUE, 40, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
            DelayCommand(0.2, SetCommandable(FALSE, oPC));
            DelayCommand(2.0, SetCommandable(TRUE, oPC));

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionRestringida * 60));
            DelayCommand(TurnsToSeconds(iDuracionRestringida), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 96:
            //Vital 7/7/6
            SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_DEATH_WARD, FALSE));

            eApp = EffectImmunity(IMMUNITY_TYPE_DEATH);
            eVis = EffectVisualEffect(VFX_IMP_DEATH_WARD);
            eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            eLink = EffectLinkEffects(eApp, eDur);

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionNormal));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionNormal * 60));
            DelayCommand(TurnsToSeconds(iDuracionNormal), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 97:
            //Corrosiva 4/3/4
            RemoveEffectsFromSpell(oPC, 524);
            RemoveEffectsFromSpell(oPC, SPELL_MESTILS_ACID_SHEATH);
            SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_MESTILS_ACID_SHEATH, FALSE));

            eVis = EffectVisualEffect(448);
            eApp = EffectDamageShield(18, DAMAGE_BONUS_1d6, DAMAGE_TYPE_ACID);
            eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            eLink = EffectLinkEffects(eApp, eDur);
            eLink = EffectLinkEffects(eLink, eVis);
            eLink = TagEffect(eLink,"POCION_CORROSIVA");

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionRestringida));

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionRestringida * 60));
            DelayCommand(TurnsToSeconds(iDuracionRestringida), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 98:
            //Volatil 4/2/5
            eAC = EffectACIncrease(1, AC_DODGE_BONUS);
            eVis2 = EffectVisualEffect(VFX_DUR_SMOKE);
            eVis2 = TagEffect(eVis2, "SPELL_ACELERARVISUAL");
            eRef = EffectSavingThrowIncrease(SAVING_THROW_REFLEX ,1);
            eAttack = EffectAttackIncrease(1);
            eAtk = EffectModifyAttacks(1);
            eMov = EffectMovementSpeedIncrease(50);
            eVis = EffectVisualEffect(VFX_IMP_HASTE);
            eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            eLink = EffectLinkEffects(eAC, eAttack);
                    eLink = EffectLinkEffects(eLink, eAtk);
                    eLink = EffectLinkEffects(eLink, eMov);
                    eLink = EffectLinkEffects(eLink, eDur);
                    eLink = EffectLinkEffects(eLink, eRef);
                    eLink = TagEffect(eLink, "SPELL_ACELERAR");


            SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_HASTE, FALSE));

            if (GetHasSpellEffect(SPELL_EXPEDITIOUS_RETREAT, oPC) == TRUE)
            {
                gsSPRemoveEffect(oPC,456);
            }
            if (GetHasSpellEffect(647, oPC) == TRUE)
            {
                gsSPRemoveEffect(oPC,647);
            }
            if (GetHasSpellEffect(78, oPC) == TRUE)
            {
                gsSPRemoveEffect(oPC,78);
            }
            if (GetHasSpellEffect(113, oPC) == TRUE)
            {
                gsSPRemoveEffect(oPC,113);
            }
            PJ_EfectoQuitarTag(oPC, "POCION_SIDRAPERA");
            PJ_EfectoQuitarTag(oPC, "SPELL_ACELERAR");
            PJ_EfectoQuitarTag(oPC, "SPELL_ACELERARVISUAL");


            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionRestringida));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVis2, oPC, TurnsToSeconds(iDuracionRestringida));

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionRestringida * 60));
            DelayCommand(TurnsToSeconds(iDuracionRestringida), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 99:
            //de Guerra 4/6/5
            SignalEvent(oPC, EventSpellCastAt(oPC, 414, FALSE));

            eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
            eVis2 = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);

            eApp = EffectAttackIncrease(1);
            eApp2 = EffectDamageIncrease(1, DAMAGE_TYPE_MAGICAL);
            eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            eLink = EffectLinkEffects(eApp, eApp2);
            eLink = EffectLinkEffects(eLink, eDur);

            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis2, GetLocation(oPC));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionNormal));

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionNormal * 60));
            DelayCommand(TurnsToSeconds(iDuracionNormal), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 100:
            //Calorifica 4/4/6
            RemoveEffectsFromSpell(oPC, SPELL_ELEMENTAL_SHIELD);
            SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_ELEMENTAL_SHIELD, FALSE));

            eApp = EffectDamageShield(7, DAMAGE_BONUS_1d6, DAMAGE_TYPE_FIRE);
            eApp2 = EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 50);
            eApp3 = EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 50);
            eDur = EffectVisualEffect(147);
            eLink = EffectLinkEffects(eApp, eDur);
            eLink = EffectLinkEffects(eApp2, eLink);
            eLink = EffectLinkEffects(eApp3, eLink);
            eLink = TagEffect(eLink,"POCION_CALORIFICA");

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionRestringida));

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionRestringida * 60));
            DelayCommand(TurnsToSeconds(iDuracionRestringida), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 101:
            //Antimagia 8/1/6
            SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_PROTECTION_FROM_SPELLS, FALSE));

            eVis = EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION);
            eApp = EffectSavingThrowIncrease(SAVING_THROW_ALL, 8, SAVING_THROW_TYPE_SPELL);
            eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            eDur2 = EffectVisualEffect(VFX_DUR_MAGIC_RESISTANCE);
            eLink = EffectLinkEffects(eApp, eDur);
            eLink = EffectLinkEffects(eLink, eDur2);

            fDelay = GetRandomDelay();
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionNormal)));

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionNormal * 60));
            DelayCommand(TurnsToSeconds(iDuracionNormal), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 102:
            //de Descenso 7/7/8
            if (GetHasEffect(EFFECT_TYPE_CURSE, oPC)){
                SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_POLYMORPH_SELF, FALSE));

                eSearch = GetFirstEffect(oPC);
                while (GetIsEffectValid(eSearch)) {
                    if (GetEffectType(eSearch) == EFFECT_TYPE_CURSE) {
                        RemoveEffect(oPC, eSearch);
                    }
                   eSearch = GetNextEffect(oPC);
                }
                eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
                eApp = EffectPolymorph(POLYMORPH_TYPE_DOOM_KNIGHT);

                AssignCommand(oPC, ClearAllActions()); // prevents an exploit
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eApp, oPC, TurnsToSeconds(iDuracionNormal));

                SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionNormal * 60));
                DelayCommand(TurnsToSeconds(iDuracionNormal), DeleteLocalInt(oPC, sNumPocion));
            }else{
                DelayCommand(2.0, FloatingTextStringOnCreature("*La pocion parece no hacerte efecto...*", oPC, FALSE));
            }
            break;
        case 103:
            //de Ascenso 6/6/8
            if ((GetHasEffect(EFFECT_TYPE_BLINDNESS, oPC))||(GetHasEffect(EFFECT_TYPE_DEAF, oPC))){
                SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_POLYMORPH_SELF, FALSE));

                eSearch = GetFirstEffect(oPC);
                while (GetIsEffectValid(eSearch)){
                   if ((GetEffectType(eSearch)==EFFECT_TYPE_BLINDNESS)||(GetEffectType(eSearch)==EFFECT_TYPE_DEAF)){
                         RemoveEffect(oPC, eSearch);
                   }
                   eSearch = GetNextEffect(oPC);
                }
                eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
                eApp = EffectPolymorph(POLYMORPH_TYPE_CELESTIAL_AVENGER);

                AssignCommand(oPC, ClearAllActions()); // prevents an exploit
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eApp, oPC, TurnsToSeconds(iDuracionNormal));

                SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionNormal * 60));
                DelayCommand(TurnsToSeconds(iDuracionNormal), DeleteLocalInt(oPC, sNumPocion));
            }else{
                DelayCommand(2.0, FloatingTextStringOnCreature("*La pocion parece no hacerte efecto...*", oPC, FALSE));
            }
            break;
        case 104:
            //de Furia 4/3/8
            SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_TENSERS_TRANSFORMATION, FALSE));

            //Declare effects
            eApp = EffectAttackIncrease(11/2);
            eApp2 = EffectSavingThrowIncrease(SAVING_THROW_FORT, 5);
            eApp3 = EffectPolymorph(28);
            eApp4 = EffectModifyAttacks(2);
            eApp5 = EffectTemporaryHitpoints(d6(11));
            eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            eLink = EffectLinkEffects(eApp, eApp2);
            eLink = EffectLinkEffects(eLink, eApp3);
            eLink = EffectLinkEffects(eLink, eApp4);
            eLink = EffectLinkEffects(eLink, eDur);
            eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);

            ClearAllActions(); // prevents an exploit
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eApp5, oPC, TurnsToSeconds(iDuracionNormal));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionNormal));

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionNormal * 60));
            DelayCommand(TurnsToSeconds(iDuracionNormal), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 105:
            //de Fuego 4/4/8
            SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_POLYMORPH_SELF, FALSE));

            eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
            eApp = EffectPolymorph(POLYMORPH_TYPE_HUGE_FIRE_ELEMENTAL);

            AssignCommand(oPC, ClearAllActions()); // prevents an exploit
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eApp, oPC, TurnsToSeconds(iDuracionNormal));

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionNormal * 60));
            DelayCommand(TurnsToSeconds(iDuracionNormal), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 106:
            //de Tierra 3/3/8
            SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_POLYMORPH_SELF, FALSE));

            eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
            eApp = EffectPolymorph(POLYMORPH_TYPE_HUGE_EARTH_ELEMENTAL);

            AssignCommand(oPC, ClearAllActions()); // prevents an exploit
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eApp, oPC, TurnsToSeconds(iDuracionNormal));

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionNormal * 60));
            DelayCommand(TurnsToSeconds(iDuracionNormal), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 107:
            //de Aire 2/2/8
            SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_POLYMORPH_SELF, FALSE));

            eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
            eApp = EffectPolymorph(POLYMORPH_TYPE_HUGE_AIR_ELEMENTAL);

            AssignCommand(oPC, ClearAllActions()); // prevents an exploit
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eApp, oPC, TurnsToSeconds(iDuracionNormal));

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionNormal * 60));
            DelayCommand(TurnsToSeconds(iDuracionNormal), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 108:
            //de Agua 1/1/8
            SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_POLYMORPH_SELF, FALSE));

            eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
            eApp = EffectPolymorph(POLYMORPH_TYPE_HUGE_WATER_ELEMENTAL);

            AssignCommand(oPC, ClearAllActions()); // prevents an exploit
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eApp, oPC, TurnsToSeconds(iDuracionNormal));

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionNormal * 60));
            DelayCommand(TurnsToSeconds(iDuracionNormal), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 109:
            //Aullante 2/4/6
            SignalEvent(oPC, EventSpellCastAt(oPC, 441, FALSE));
            if (GetHasSpellEffect(SPELL_WOUNDING_WHISPERS)) {
                RemoveSpellEffects(SPELL_WOUNDING_WHISPERS,oPC,oPC);
            }

            eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);
            eApp = EffectDamageShield(d6(1) + 5, 0, DAMAGE_TYPE_SONIC);
            eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            eLink = EffectLinkEffects(eApp, eDur);
            eLink = EffectLinkEffects(eLink, eVis);

            //Apply the VFX impact and effects
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionRestringida));

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionRestringida * 60));
            DelayCommand(TurnsToSeconds(iDuracionRestringida), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 110:
            //de Supervivencia 7/6/6
            SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_NEGATIVE_ENERGY_PROTECTION, FALSE));

            eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);
            eApp = EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE, 100);
            eApp2 = EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL);
            eApp3 = EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE);
            eLink = EffectLinkEffects(eApp, eApp2);
            eLink = EffectLinkEffects(eLink, eApp3);

            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(iDuracionNormal));

            SetLocalInt(oPC, sNumPocion, SQLite_GetTimeStamp() + (iDuracionNormal * 60));
            DelayCommand(TurnsToSeconds(iDuracionNormal), DeleteLocalInt(oPC, sNumPocion));
            break;
        case 129:
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
            eApp = EffectPoison(POISON_MEDIUM_SPIDER_VENOM);
            break;
        case 130:
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
            eApp = EffectPoison(POISON_TERINAV_ROOT);
            break;
        case 131:
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
            eApp = EffectPoison(POISON_SASSONE_LEAF_RESIDUE);
            break;
        case 132:
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
            eApp = EffectPoison(POISON_CHAOS_MIST);
            break;
        case 133:
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
            eApp = EffectPoison(POISON_ID_MOSS);
            break;
        case 134:
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
            eApp = EffectPoison(POISON_UNGOL_DUST);
            break;
        case 135:
            eApp = EffectPoison(POISON_LICH_DUST);
            break;
        case 136:
            eApp = EffectPoison(POISON_GIANT_WASP_POISON);
            break;
        case 137:
            eApp = EffectPoison(POISON_BEBILITH_VENOM);
            break;
        case 138:
            eApp = EffectDisease(DISEASE_BURROW_MAGGOTS);
            break;
        case 139:
            eApp = EffectPoison(DISEASE_BURROW_MAGGOTS);
            break;
        case 140:
            eApp = EffectPoison(DISEASE_RED_SLAAD_EGGS);
            break;
        case 150:
            if (GetIsInCombat(oPC)!=TRUE){
                eApp = EffectHeal(d12(2)+3*GetSkillRank(SKILL_HEAL, oPC, TRUE));
                //Aplicamos la curacion.
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eApp, oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }else{
                FloatingTextStringOnCreature("*¡No puedes usar las Vendas Alquímicas en combate!*", oPC, FALSE);
            }
            break;
        case 151:
            if (GetIsInCombat(oPC)!=TRUE){
                eApp = EffectHeal(d12(3)+4*GetSkillRank(SKILL_HEAL, oPC, TRUE));
                //Apply heal effect and VFX impact
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eApp, oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }else{
                FloatingTextStringOnCreature("*¡No puedes usar las Vendas Alquímicas Mayores en combate!*", oPC, FALSE);
            }
            break;
    }

    //Efectos lanzados en masa
    if (idPocion > 128 && idPocion < 135) {
        fDelay;
        object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget);
        while(GetIsObjectValid(oTarget)) {
            fDelay = GetRandomDelay();
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eApp, oTarget));
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget);
        }
    }

    //Efectos lanzados en delay
    if (idPocion >= 135 && idPocion < 141) {
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget));
        fDelay = GetRandomDelay();
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eApp, oTarget));
    }

   idPocion = 0;
}

//void main(){}
