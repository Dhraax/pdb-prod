#include "f_vampire_h"
#include "f_vampirepenta_h"



void RemoveBothersomeEffects() {
    //these effect can mess up the cutscene invis that is needed to make stuff look
    //right. So they are removed.
    effect eSearch = GetFirstEffect(OBJECT_SELF);
    int iType;
    while(GetIsEffectValid(eSearch)){
        iType = GetEffectType(eSearch);

        if(
        iType == EFFECT_TYPE_VISUALEFFECT ||
        iType == EFFECT_TYPE_IMPROVEDINVISIBILITY ||
        iType == EFFECT_TYPE_INVISIBILITY ||
        iType == EFFECT_TYPE_AREA_OF_EFFECT ||
        iType == EFFECT_TYPE_SILENCE ||
        iType == EFFECT_TYPE_SPELL_FAILURE ||
        iType == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE ||
        iType == EFFECT_TYPE_MISS_CHANCE ||
        iType == EFFECT_TYPE_IMMUNITY ||
        iType == EFFECT_TYPE_MOVEMENT_SPEED_INCREASE ||
        iType == EFFECT_TYPE_ULTRAVISION ||
        iType == EFFECT_TYPE_DAMAGE_RESISTANCE ||
        iType == EFFECT_TYPE_DAMAGE_DECREASE) {
             RemoveEffect(OBJECT_SELF, eSearch);
        }
        eSearch = GetNextEffect(OBJECT_SELF);
    }
}

void main()
{
    //Modificado por Asyel
    int iHD = Determine_Vampire_Level(OBJECT_SELF);

    if(!GetIsVampire(OBJECT_SELF)) {
        //this should not be able to happen, but may as well make sure.
        SetIsVampire(FALSE, OBJECT_SELF);
        return;
    }

    if(GetLocalInt(OBJECT_SELF, "FALLEN_VAMPIRE_MIST") > 0) {
        effect eVis2 = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
        ClearAllActions(TRUE);
        SetCommandable(FALSE, OBJECT_SELF);
        pentagram(GetLocation(OBJECT_SELF), VFX_BEAM_EVIL, 3.0);
        DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, OBJECT_SELF));
        DelayCommand(2.4, RemoveBothersomeEffects());
        DelayCommand(2.5, Vampire_Apply_Stats(OBJECT_SELF));
        DelayCommand(3.0, SetCommandable(TRUE, OBJECT_SELF));
        SetLocalInt(OBJECT_SELF, "FALLEN_VAMPIRE_MIST", FALSE);
        return;
    }

    SetLocalInt(OBJECT_SELF, "FALLEN_VAMPIRE_MIST", TRUE);
    int myHD = Determine_Vampire_Level(OBJECT_SELF);

    effect eInvis = ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY));
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
    effect eMist = ExtraordinaryEffect(EffectAreaOfEffect(MistAOEType, "f_vampiremist2", "f_vampiremist3", "****"));
    effect eSilence = ExtraordinaryEffect(EffectSilence());
    effect eSpellFail = ExtraordinaryEffect(EffectSpellFailure(100, SPELL_SCHOOL_GENERAL));
    effect eMovement = ExtraordinaryEffect(EffectMovementSpeedDecrease((21 - myHD) * 3));
    effect eMiss = ExtraordinaryEffect(EffectMissChance(100));
    effect eTrapImmune = ExtraordinaryEffect(EffectImmunity(IMMUNITY_TYPE_TRAP));

    //Modificado Asyel
    effect eSpeedUp = ExtraordinaryEffect(EffectMovementSpeedIncrease((iHD * 2)));
    effect eVision = ExtraordinaryEffect(EffectUltravision());
    effect eContu = ExtraordinaryEffect(EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING,200,0));
    effect ePerfo = ExtraordinaryEffect(EffectDamageResistance(DAMAGE_TYPE_PIERCING,200,0));
    effect eCortan = ExtraordinaryEffect(EffectDamageResistance(DAMAGE_TYPE_SLASHING,200,0));
    effect eDD = ExtraordinaryEffect(EffectDamageDecrease(200, DAMAGE_TYPE_ACID));
    effect eDLink = ExtraordinaryEffect(EffectDamageDecrease(200, DAMAGE_TYPE_BLUDGEONING));  //contundente

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
    eDD = ExtraordinaryEffect(EffectDamageDecrease(200, DAMAGE_TYPE_PIERCING)); //perforante
    eDLink = ExtraordinaryEffect(EffectLinkEffects(eDD, eDLink));
    eDD = ExtraordinaryEffect(EffectDamageDecrease(200, DAMAGE_TYPE_POSITIVE));
    eDLink = ExtraordinaryEffect(EffectLinkEffects(eDD, eDLink));
    eDD = ExtraordinaryEffect(EffectDamageDecrease(200, DAMAGE_TYPE_SLASHING));
    eDLink = ExtraordinaryEffect(EffectLinkEffects(eDD, eDLink));
    eDD = ExtraordinaryEffect(EffectDamageDecrease(200, DAMAGE_TYPE_SONIC));
    eDLink = ExtraordinaryEffect(EffectLinkEffects(eDD, eDLink));

    RemoveBothersomeEffects();
    ClearAllActions(TRUE);
    ActionWait(3.0);
    DelayCommand(0.5, pentagram(GetLocation(OBJECT_SELF), VFX_BEAM_EVIL, 5.5, 0.4, 0.6));
    SetCommandable(FALSE, OBJECT_SELF);
    DelayCommand(4.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF));

    //DelayCommand(5.0, Vampire_Remove_Stats(OBJECT_SELF));
    DelayCommand(5.1, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMist, OBJECT_SELF));
    DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eInvis, OBJECT_SELF));
    DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSilence, OBJECT_SELF));
    DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSpellFail, OBJECT_SELF));
    DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMovement, OBJECT_SELF));
    DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eTrapImmune, OBJECT_SELF));
    DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMiss, OBJECT_SELF));
    DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSpeedUp, OBJECT_SELF));
    DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVision, OBJECT_SELF));
    DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eContu, OBJECT_SELF));
    DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePerfo, OBJECT_SELF));
    DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCortan, OBJECT_SELF));
    DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDLink, OBJECT_SELF));
    DelayCommand(6.5, SetCommandable(TRUE, OBJECT_SELF));
}
