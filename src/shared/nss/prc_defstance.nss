#include "x2_inc_spellhook"
#include "nw_i0_spells"

void EndOfDefPosition(object oTarget, object oCaster);

void AjustesFatiga(object oPC, effect eEffect) {
    if (GetLocalInt(oPC, "FATIGADO2") == TRUE) {
        if (GetIsInCombat(oPC) == TRUE)
            DelayCommand(10.0f, AjustesFatiga(oPC, eEffect));
        else {
            RemoveEffect(oPC, eEffect);
            DeleteLocalInt(oPC, "FATIGADO2");
        }
    } else DelayCommand(10.0f, AjustesFatiga(oPC, eEffect));
}

int GetDelayedSpellEffectsExpired(int nSpell_ID, object oTarget, object oCaster);
int GetDelayedSpellEffectsExpired(int nSpell_ID, object oTarget, object oCaster) {

    if (!GetHasSpellEffect(nSpell_ID, oTarget)) {
        DeleteLocalInt(oTarget, "XP2_L_SPELL_SAVE_DC_" + IntToString(nSpell_ID));
        return TRUE;
    }

    //--------------------------------------------------------------------------
    // GZ: 2003-Oct-15
    // If the caster is dead or no longer there, cancel the spell, as it is
    // directed
    //--------------------------------------------------------------------------
    if (!GetIsObjectValid(oCaster)) {
        RemoveSpellEffects(nSpell_ID, oTarget, oTarget);
        DeleteLocalInt(oTarget, "XP2_L_SPELL_SAVE_DC_" + IntToString(nSpell_ID));
        return TRUE;
    }

    if (GetIsDead(oCaster)) {
        DeleteLocalInt(oTarget, "XP2_L_SPELL_SAVE_DC_" + IntToString(nSpell_ID));
        RemoveSpellEffects(nSpell_ID, oTarget, oTarget);
        return TRUE;
    }

    return FALSE;

}

void main() {
    if (!GetHasFeatEffect(1458)) // Posicion Defensiva
    {

        if (GetLocalInt(OBJECT_SELF, "FATIGADO2") == TRUE) //Fatigado no hay Posicin de Defensa
        {
            SendMessageToPC(OBJECT_SELF, "<ct<<>Estás fatigado a causa de la Posicion Defensiva, deja de combatir y volverás a la normalidad.</c>");
            IncrementRemainingFeatUses(OBJECT_SELF, 1458);
            return;
        }

        // Declare major variables
        int nLevel = GetLevelByClass(36); // Enano Defensor

        object oTarget = GetSpellTargetObject();

        PlayVoiceChat(VOICE_CHAT_BATTLECRY1);

        //Determine the duration
        int nCon = 3 + GetAbilityModifier(ABILITY_CONSTITUTION);

        effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, 2);
        effect eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION, 4);
        effect eAC = EffectACIncrease(4, AC_DODGE_BONUS);
        effect eMove = EffectMovementSpeedDecrease(80);
        effect eSave = EffectSavingThrowIncrease(SAVING_THROW_TYPE_ALL, 2, SAVING_THROW_TYPE_NONE);

        //Link Effects
        effect eLink = EffectLinkEffects(eStr, eAC);
       //eLink = EffectLinkEffects(eLink, eAC);
        eLink = EffectLinkEffects(eLink, eCon);
        eLink = EffectLinkEffects(eLink, eSave);

        eLink = EffectLinkEffects(eLink, eMove);

        SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_EPIC_MIGHTY_RAGE, FALSE));

        //Make effect extraordinary
        eLink = ExtraordinaryEffect(eLink);
        effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);

        if (nCon > 0) {
            //Apply the VFX impact and effects
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(nCon));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);

            SetLocalInt(OBJECT_SELF, "FATIGADO2", TRUE);

            object oSelf = OBJECT_SELF;
            DelayCommand(6.0f, EndOfDefPosition(oTarget, oSelf));
        }
    } else {
        SendMessageToPC(OBJECT_SELF, "<ct<<>No puedes activar Posición Defensiva mientras ya estás en ella.</c>");
        IncrementRemainingFeatUses(OBJECT_SELF, 1458);
    }
}

void EndOfDefPosition(object oTarget, object oCaster) {
    if (GetDelayedSpellEffectsExpired(1333, oTarget, oCaster)) // Si ya no estamos en Posicion defensiva, paramos
    {
        effect eStrPen = EffectAbilityDecrease(ABILITY_STRENGTH, 2);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eStrPen, oTarget);
        //SetLocalInt(oTarget, "FATIGADO2", TRUE);
        DelayCommand(10.0f, AjustesFatiga(oTarget, eStrPen));

        return;
    }

    DelayCommand(6.0f, EndOfDefPosition(oTarget, oCaster)); //Checkeamos otro round.
}
