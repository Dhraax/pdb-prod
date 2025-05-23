#include "f_vampire_h"

void RemoveBothersomeEffects() {
    //these effect can mess up the cutscene invis that is needed to make stuff look
    //right. So they are removed.
    effect eE = GetFirstEffect(OBJECT_SELF);
    int iType;
    while(GetIsEffectValid(eE)) {
        iType = GetEffectType(eE);
        if(iType == EFFECT_TYPE_ETHEREAL ||
           iType == EFFECT_TYPE_IMPROVEDINVISIBILITY ||
           iType == EFFECT_TYPE_INVISIBILITY ||
           iType == EFFECT_TYPE_CONCEALMENT ||
           iType == EFFECT_TYPE_SANCTUARY) {
             RemoveEffect(OBJECT_SELF, eE);
        }
        eE = GetNextEffect(OBJECT_SELF);
    }
}

void main()
{
    int myHD = Determine_Vampire_Level(OBJECT_SELF);
    effect eInvis = ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY));
    effect eVis = EffectVisualEffect(VFX_FNF_DISPEL_DISJUNCTION);
    effect eMist = ExtraordinaryEffect(EffectAreaOfEffect(MistAOEType, "f_vampiremist2", "f_vampiremist3", "****"));
    effect eSilence = ExtraordinaryEffect(EffectSilence());
    effect eSpellFail = ExtraordinaryEffect(EffectSpellFailure(100, SPELL_SCHOOL_GENERAL));
    effect eMovement = ExtraordinaryEffect(EffectMovementSpeedDecrease((21 - myHD) * 3));
    effect eMiss = ExtraordinaryEffect(EffectMissChance(100));
    effect eTrapImmune = ExtraordinaryEffect(EffectImmunity(IMMUNITY_TYPE_TRAP));
    effect eDD = ExtraordinaryEffect(EffectDamageDecrease(200, DAMAGE_TYPE_ACID));
    effect eDLink = ExtraordinaryEffect(EffectDamageDecrease(200, DAMAGE_TYPE_BLUDGEONING));
    eDLink = ExtraordinaryEffect(EffectLinkEffects(eDD, eDLink));
    eDD = ExtraordinaryEffect(EffectDamageDecrease(200, DAMAGE_TYPE_COLD));
    eDLink = ExtraordinaryEffect(EffectLinkEffects(eDD, eDLink));
    eDD = ExtraordinaryEffect(EffectDamageDecrease(200, DAMAGE_TYPE_DIVINE));
    eDLink = ExtraordinaryEffect(EffectLinkEffects(eDD, eDLink));
    eDD = ExtraordinaryEffect(EffectDamageDecrease(200, DAMAGE_TYPE_ELECTRICAL));
    eDLink = ExtraordinaryEffect(EffectLinkEffects(eDD, eDLink));
    eDD = ExtraordinaryEffect(EffectDamageDecrease(200, DAMAGE_TYPE_FIRE));
    eDLink = ExtraordinaryEffect(EffectLinkEffects(eDD, eDLink));
    eDD = ExtraordinaryEffect(EffectDamageDecrease(200, DAMAGE_TYPE_MAGICAL));
    eDLink = ExtraordinaryEffect(EffectLinkEffects(eDD, eDLink));
    eDD = ExtraordinaryEffect(EffectDamageDecrease(200, DAMAGE_TYPE_NEGATIVE));
    eDLink = ExtraordinaryEffect(EffectLinkEffects(eDD, eDLink));
    eDD = ExtraordinaryEffect(EffectDamageDecrease(200, DAMAGE_TYPE_PIERCING));
    eDLink = ExtraordinaryEffect(EffectLinkEffects(eDD, eDLink));
    eDD = ExtraordinaryEffect(EffectDamageDecrease(200, DAMAGE_TYPE_POSITIVE));
    eDLink = ExtraordinaryEffect(EffectLinkEffects(eDD, eDLink));
    eDD = ExtraordinaryEffect(EffectDamageDecrease(200, DAMAGE_TYPE_SLASHING));
    eDLink = ExtraordinaryEffect(EffectLinkEffects(eDD, eDLink));
    eDD = ExtraordinaryEffect(EffectDamageDecrease(200, DAMAGE_TYPE_SONIC));
    eDLink = ExtraordinaryEffect(EffectLinkEffects(eDD, eDLink));
    RemoveBothersomeEffects();
    ClearAllActions(TRUE);
    SetCommandable(FALSE, OBJECT_SELF);
    Vampire_Remove_Stats(OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMist, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eInvis, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSilence, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSpellFail, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMovement, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eTrapImmune, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMiss, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDLink, OBJECT_SELF);
    SetCommandable(TRUE, OBJECT_SELF);
}
