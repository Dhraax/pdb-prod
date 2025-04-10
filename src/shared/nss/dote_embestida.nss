//::///////////////////////////////////////////////
//:: DOTE EMBESTIDA Y EMBESTIDA MEJORADA
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Embestida.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 15 de Junio de 2011
//:://////////////////////////////////////////////

#include "mti_libreria"
#include "inc_sqlite_time"
#include "nwnx_creature"

void EliminarAtaqueElastico(object oPC)
{
  NWNX_Creature_RemoveFeat(oPC, FEAT_SPRING_ATTACK);
}

void main() {
    object oPC = OBJECT_SELF;
    object oObjetivo = GetSpellTargetObject();

    int iCurTime = SQLite_GetTimeStamp();
    int iCoolDown = GetLocalInt(oPC, "EMBESTIDA_NOSATURAR");
    // Anti-saturamiento de embestida
    if(iCurTime - iCoolDown < 10) {
        FloatingTextStringOnCreature("<cþ<<>* No puedes iniciar una nueva embestida tan rápidamente *</c>", OBJECT_SELF, FALSE);
        return;
    }

    SetLocalInt(oPC, "EMBESTIDA_NOSATURAR", SQLite_GetTimeStamp());
    DelayCommand(10.0, DeleteLocalInt(oPC, "EMBESTIDA_NOSATURAR"));

    // Solo se embiste a criaturas
    if(GetObjectType(oObjetivo) != OBJECT_TYPE_CREATURE) {
        FloatingTextStringOnCreature("<cþ<<>* Sólo puedes embestir a criaturas *</c>", OBJECT_SELF, FALSE);
        return;
    }

    // No puedes embestir a uno mismo
    if(oObjetivo == oPC) {
        FloatingTextStringOnCreature("<cþ<<>* ¡No puedes embestirte a ti mismo! *</c>", OBJECT_SELF, FALSE);
        return;
    }

    // Con efectos dayninos no puedes usarla
    int iFalloDote = FALSE;
    if(GetIsResting(oPC) || GetLocalInt(oPC, "DERRIBADO") || GetLocalInt(oPC, "SLIDING")) iFalloDote = TRUE;

    effect eEfecto = GetFirstEffect(oPC);
    while(GetIsEffectValid(eEfecto)) {
        if(GetEffectType(eEfecto) == EFFECT_TYPE_CHARMED ||           GetEffectType(eEfecto) == EFFECT_TYPE_CONFUSED ||
        GetEffectType(eEfecto) == EFFECT_TYPE_CUTSCENE_PARALYZE || GetEffectType(eEfecto) == EFFECT_TYPE_CUTSCENEIMMOBILIZE ||
        GetEffectType(eEfecto) == EFFECT_TYPE_DAZED ||             GetEffectType(eEfecto) == EFFECT_TYPE_DOMINATED ||
        GetEffectType(eEfecto) == EFFECT_TYPE_ENTANGLE ||          GetEffectType(eEfecto) == EFFECT_TYPE_FRIGHTENED ||
        GetEffectType(eEfecto) == EFFECT_TYPE_PARALYZE ||          GetEffectType(eEfecto) == EFFECT_TYPE_PETRIFY ||
        GetEffectType(eEfecto) == EFFECT_TYPE_SLEEP ||             GetEffectType(eEfecto) == EFFECT_TYPE_STUNNED)
        {
            iFalloDote = TRUE;
        }

        eEfecto = GetNextEffect(oPC);
    }

    if(iFalloDote == TRUE) {
        FloatingTextStringOnCreature("<cþ<<>* En tu estado no puedes activar el Modo Embestida *</c>", OBJECT_SELF, FALSE);
        return;
    }

    // Comprobacion de distancia (4 o 10 metros, segun el tipo de embestida)
    // y tipo de embesitda (mas tarde se usa)
    float fDistanciaEmbestida = GetDistanceBetween(oPC, oObjetivo);
    int iBonoCarga;
    string sMensajeCarga;

    if(fDistanciaEmbestida < 4.0) {
        FloatingTextStringOnCreature("<cþ<<>* Necesitas estar a 4 metros o más para iniciar una embestida *</c>", OBJECT_SELF, FALSE);
        return;
    } else if(fDistanciaEmbestida < 10.0) {
        iBonoCarga = 0;
        sMensajeCarga = "sin carga";
    } else {
        iBonoCarga = 2;
        sMensajeCarga = "con carga";
    }

    SetLocalInt(oPC, "EMBESTIDA_BONOCARGA", iBonoCarga);

    // Embestida mejorada, ataque elastico
    if(GetHasFeat(1157, oPC)) {
        if(GetHasFeat(FEAT_SPRING_ATTACK, oPC) == FALSE) {
            NWNX_Creature_AddFeat(oPC, FEAT_SPRING_ATTACK);
            DelayCommand(fDistanciaEmbestida / 5.0, EliminarAtaqueElastico(oPC));
            GuardarIntPersistente(oPC, "EMBESTIDA_ATAQUELEASTICO", TRUE);
            DelayCommand(fDistanciaEmbestida / 5.0, GuardarIntPersistente(oPC, "EMBESTIDA_ATAQUELEASTICO", FALSE));
        }
    }

    // EMBESTIDA
    SetLocalObject(oPC, "EMBESTIDA_DEFENSOR", oObjetivo);
    AssignCommand(oPC, ClearAllActions(TRUE));
    DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectMovementSpeedIncrease(200), oPC, fDistanciaEmbestida / 5.0));
    DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(425), oPC, fDistanciaEmbestida / 5.0));
    DelayCommand(0.1, AssignCommand(oPC, ActionForceMoveToObject(oObjetivo, TRUE, 0.2)));
    DelayCommand(fDistanciaEmbestida / 5.0, AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_CUSTOM19, 5.0, 1.5)));
    DelayCommand(fDistanciaEmbestida / 5.0 + 1.5, AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_CUSTOM19, 1.0, 0.1)));
    DelayCommand(fDistanciaEmbestida / 5.0, ExecuteScript("dote_embestida2", oPC));
    AssignCommand(oPC, DelayCommand(0.2, SetCommandable(FALSE)));
    AssignCommand(oPC, DelayCommand(fDistanciaEmbestida / 5.0, SetCommandable(TRUE)));
}
