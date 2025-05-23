#include "x0_i0_position"
#include "x0_i0_spells"

//------------------------------------------------------------------------------
// FUNCTION DECLARATION
//------------------------------------------------------------------------------

void DoWindstorm(location lTarget);
void DoDetectThoughts(object oCaster);
void DoSillySummon(object oTarget);
void DoBlindnessEffect(object oCaster, location lTarget, float fRadius, int nDuration);

// * Loops through the effects on oTarget and removes any effects from
// * oCreator.
void RemoveEffectsFromCaster(object oTarget, object oCaster);


//* Wrapper function for DestroyObject - use only with Stackable Items.
//*
//* If oItem has a stack value, this function removes 1 item from the stack.
//* If the stack size = 0 after removing 1 item from the stack, the item is
//* destroyed.
//* If oItem does not have a stack value, the item is destroyed.
void DestroyItem(object oItem);

//* Removes nAmount of XP from oTarget
void RemoveXP(object oTarget, int nAmount);

//* Returns TRUE if nSpell has a material component requirement.
//* Returns FALSE if nSpell does not have a material component or is not a
//* valid spell.
int GetHasMaterialComponent(int nSpell);

// * Remove the AOE effect when it is dead, since the normal AOE onExit script is disabled
// * against the creator of the AOE effect.
void DelayDispel(object oTarget, string sAOE);

// * Use in a summon spell script. Call before EffectSummon is applied to allow multiple summons.
void MultiSummonPreSummon(object oPC = OBJECT_SELF);

// Create a Dazzled effect (-1 to Attack, Search, and Spot checks).
effect EffectDazzled();

// Create a Shaken effect (-2 to Attack, Saves, and Skill checks).
effect EffectShaken();

// Create a Sickened effect (-2 to Attack, Damage, Saves, and Skill checks).
effect EffectSickened();

// Create a Fatigued effect (-2 Strength and Dexterity, Movement speed is reduced 25%).
effect EffectFatigued();

// Create an Exhausted effect (-6 Strength and Dexterity, Movement speed is reduced 50%).
//
// Note: This effect is designed to stack with EffectFatigued() - to get the full penalty
// for EffectExhausted(), you must apply EffectFatigued() first.
effect EffectExhausted();


//------------------------------------------------------------------------------
// FUNCTION IMPLEMENTATION
//------------------------------------------------------------------------------

// Windstorm-force gust of wind effect
void DoWindstorm(location lTarget)
{
    // Play a low thundering sound
    PlaySound("as_wt_thunderds4");

    // Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE,
                                           RADIUS_SIZE_HUGE,
                                           lTarget, TRUE,
                                           OBJECT_TYPE_CREATURE |
                                           OBJECT_TYPE_DOOR |
                                           OBJECT_TYPE_AREA_OF_EFFECT);

    // Cycle through the targets within the spell shape
    while (GetIsObjectValid(oTarget)) {

        // Play a random sound
        switch (Random(5)) {
        case 0: AssignCommand(oTarget, PlaySound("as_wt_gustchasm1")); break;
        case 1: AssignCommand(oTarget, PlaySound("as_wt_gustcavrn1")); break;
        case 2: AssignCommand(oTarget, PlaySound("as_wt_gustgrass1")); break;
        case 3: AssignCommand(oTarget, PlaySound("as_wt_guststrng1")); break;
        case 4: AssignCommand(oTarget, PlaySound("fs_floatair")); break;
        }

        // Area-of-effect spells get blown away
        if (GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT) {
            DestroyObject(oTarget);
        }

        // * unlocked doors will reverse their open state
        else if (GetObjectType(oTarget) == OBJECT_TYPE_DOOR) {
            if (!GetLocked(oTarget)) {
                if (GetIsOpen(oTarget) == FALSE)
                    AssignCommand(oTarget, ActionOpenDoor(oTarget));
                else
                    AssignCommand(oTarget, ActionCloseDoor(oTarget));
            }
        }

        // creatures will get knocked down, tough fort saving throw
        // to resist.
        else if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE) {
            if( !FortitudeSave(oTarget, 15) ) {
                effect eKnockdown = EffectKnockdown();
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                                    eKnockdown,
                                    oTarget,
                                    RoundsToSeconds(1));
            }
        }

        // Get the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE,
                                       RADIUS_SIZE_HUGE,
                                       lTarget, TRUE,
                                       OBJECT_TYPE_CREATURE |
                                       OBJECT_TYPE_DOOR |
                                       OBJECT_TYPE_AREA_OF_EFFECT);
    }

}


// Give premonition for a few rounds, up to d4*5 hp
void DoDetectThoughts(object oCaster)
{
    int nRounds = d4();
    int nLimit = nRounds * 5;

    effect ePrem = EffectDamageReduction(30, DAMAGE_POWER_PLUS_FIVE, nLimit);
    effect eVis = EffectVisualEffect(VFX_DUR_PROT_PREMONITION);

    //Link the visual and the damage reduction effect
    effect eLink = EffectLinkEffects(ePrem, eVis);

    //Fire cast spell at event for the specified target
    SignalEvent(oCaster, EventSpellCastAt(oCaster, SPELL_PREMONITION, FALSE));

    //Apply the linked effect
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                        eLink, oCaster, RoundsToSeconds(nRounds));
}

// Summon something extremely silly (rats will be hostile to caster!)
void DoSillySummon(object oTarget)
{
    location lTargetLoc = GetOppositeLocation(oTarget);
    int nSummon = d100();
    string sSummon = "";
    if (nSummon < 26) {
        sSummon = "x0_penguin001";
    } else if (nSummon < 51) {
        sSummon = "nw_cow";
    } else {
        sSummon = "nw_rat001";
    }

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,
                          EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1),
                          lTargetLoc);

    CreateObject(OBJECT_TYPE_CREATURE, sSummon, lTargetLoc, TRUE);
}

// Do a blindness spell on all in the given radius of a cone for the given
// number of rounds in duration.
void DoBlindnessEffect(object oCaster, location lTarget, float fRadius, int nDuration)
{
    vector vOrigin = GetPosition(oCaster);

    effect eVis = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectBlindness();
    eLink = EffectLinkEffects(eLink, eDur);

    object oTarget = GetFirstObjectInShape(SHAPE_CONE,
                                           fRadius,
                                           lTarget,
                                           TRUE,
                                           OBJECT_TYPE_CREATURE,
                                           vOrigin);

    while (GetIsObjectValid(oTarget)) {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF,
                    SPELL_BLINDNESS_AND_DEAFNESS));

        //Do SR check
        if ( !MyResistSpell(OBJECT_SELF, oTarget)) {
            // Make Fortitude save to negate
            if (! MySavingThrow(SAVING_THROW_FORT, oTarget, 13)) {
                //Apply visual and effects
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget,
                                    RoundsToSeconds(nDuration));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_CONE,
                                           fRadius,
                                           lTarget,
                                           TRUE,
                                           OBJECT_TYPE_CREATURE,
                                           vOrigin);
    }
}

int GetHasMaterialComponent(int nSpell)
{
    int bValid = FALSE;

    switch (nSpell)
    {
        case SPELL_ACID_FOG                         :
        case SPELL_AID                              :
        //case SPELL_ANIMATE_DEAD                     :
        case SPELL_AURAOFGLORY                      :
        case SPELL_BALL_LIGHTNING                   :
        case SPELL_BANE                             :
        case SPELL_BANISHMENT                       :
        case SPELL_BARKSKIN                         :
        case SPELL_BATTLETIDE                       :
        case SPELL_BIGBYS_CLENCHED_FIST             :
        case SPELL_BIGBYS_CRUSHING_HAND             :
        case SPELL_BIGBYS_FORCEFUL_HAND             :
        case SPELL_BIGBYS_GRASPING_HAND             :
        case SPELL_BIGBYS_INTERPOSING_HAND          :
        //case SPELL_BLACKSTAFF                       :
        case SPELL_BLESS                            :
        case SPELL_BOMBARDMENT                      :
        case SPELL_BULLS_STRENGTH                   :
        case SPELL_CATS_GRACE                       :
        case SPELL_CHAIN_LIGHTNING                  :
        //case SPELL_CIRCLE_OF_DEATH                  :
        case SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE   :
        case SPELL_CLARITY                          :
        //case SPELL_CLOAK_OF_CHAOS                   :
        case SPELL_COLOR_SPRAY                      :
        case SPELL_COMBUST                          :
        case SPELL_CONE_OF_COLD                     :
        case SPELL_CONFUSION                        :
        //case SPELL_CONTINUAL_FLAME                  :
        case SPELL_CONTROL_UNDEAD                   :
        //case SPELL_CREATE_GREATER_UNDEAD            :
        //case SPELL_CREATE_UNDEAD                    :
        case SPELL_DARKNESS                         :
        case SPELL_DARKVISION                       :
        case SPELL_DAZE                             :
        case SPELL_DEAFENING_CLANG                  :
        case SPELL_DEATH_ARMOR                      :
        case SPELL_DEATH_WARD                       :
        case SPELL_DELAYED_BLAST_FIREBALL           :
        //case SPELL_DESTRUCTION                      :
        case SPELL_DISMISSAL                        :
        case SPELL_DISPLACEMENT                     :
        case SPELL_DIVINE_FAVOR                     :
        case SPELL_DOOM                             :
        case SPELL_DROWN                            :
        case SPELL_EAGLE_SPLEDOR                    :
        case SPELL_EARTHQUAKE                       :
        case SPELL_ELEMENTAL_SHIELD                 :
        case SPELL_ENDURANCE                        :
        case SPELL_ENTANGLE                         :
        //case SPELL_EPIC_MUMMY_DUST                  :
        case SPELL_EVARDS_BLACK_TENTACLES           :
        case SPELL_FEAR                             :
        case SPELL_FEEBLEMIND                       :
        case SPELL_FIREBALL                         :
        //case SPELL_FIREBRAND                        :
        case SPELL_FLAME_ARROW                      :
        case SPELL_FLAME_STRIKE                     :
        case SPELL_FLESH_TO_STONE                   :
        case SPELL_FOXS_CUNNING                     :
        case SPELL_FREEDOM_OF_MOVEMENT              :
        //case SPELL_GATE                             :
        case SPELL_GEDLEES_ELECTRIC_LOOP            :
        case SPELL_GHOUL_TOUCH                      :
        case SPELL_GLOBE_OF_INVULNERABILITY         :
        //case SPELL_GLYPH_OF_WARDING                 :
        case SPELL_GREASE                           :
        case SPELL_GREAT_THUNDERCLAP                :
        case SPELL_GREATER_BULLS_STRENGTH           :
        case SPELL_GREATER_CATS_GRACE               :
        case SPELL_GREATER_EAGLE_SPLENDOR           :
        case SPELL_GREATER_ENDURANCE                :
        case SPELL_GREATER_FOXS_CUNNING             :
        case SPELL_GREATER_MAGIC_FANG               :
        case SPELL_GREATER_MAGIC_WEAPON             :
        case SPELL_GREATER_OWLS_WISDOM              :
        //case SPELL_GREATER_RESTORATION              :
        case SPELL_GREATER_STONESKIN                :
        case SPELL_HASTE                            :
        case SPELL_HEALING_STING                    :
        case SPELL_HOLD_MONSTER                     :
        case SPELL_HOLD_PERSON                      :
        //case SPELL_HOLY_AURA                        :
        case SPELL_HORRID_WILTING                   :
        case SPELL_ICE_DAGGER                       :
        case SPELL_ICE_STORM                        :
        //case SPELL_IDENTIFY                         :
        case SPELL_INFERNO                          :
        case SPELL_INFESTATION_OF_MAGGOTS           :
        case SPELL_INVISIBILITY                     :
        case SPELL_INVISIBILITY_SPHERE              :
        case SPELL_IRONGUTS                         :
        //case SPELL_LEGEND_LORE                      :
        case SPELL_LIGHT                            :
        case SPELL_LIGHTNING_BOLT                   :
        case SPELL_MAGE_ARMOR                       :
        case SPELL_MAGIC_CIRCLE_AGAINST_CHAOS       :
        case SPELL_MAGIC_CIRCLE_AGAINST_EVIL        :
        case SPELL_MAGIC_CIRCLE_AGAINST_GOOD        :
        case SPELL_MAGIC_CIRCLE_AGAINST_LAW         :
        case SPELL_MAGIC_FANG                       :
        case SPELL_MAGIC_VESTMENT                   :
        case SPELL_MAGIC_WEAPON                     :
        case SPELL_MASS_HASTE                       :
        case SPELL_MELFS_ACID_ARROW                 :
        case SPELL_MESTILS_ACID_BREATH              :
        case SPELL_MESTILS_ACID_SHEATH              :
        case SPELL_MINOR_GLOBE_OF_INVULNERABILITY   :
        //case SPELL_MORDENKAINENS_SWORD              :
        case SPELL_NEGATIVE_ENERGY_RAY              :
        case SPELL_NEUTRALIZE_POISON                :
        case SPELL_OWLS_WISDOM                      :
        //case SPELL_PLANAR_ALLY                      :
        case SPELL_POISON                           :
        case SPELL_PROTECTION__FROM_CHAOS           :
        case SPELL_PROTECTION_FROM_ELEMENTS         :
        case SPELL_PROTECTION_FROM_EVIL             :
        case SPELL_PROTECTION_FROM_GOOD             :
        case SPELL_PROTECTION_FROM_LAW              :
        //case SPELL_PROTECTION_FROM_SPELLS           :
        case SPELL_RAISE_DEAD                       :
        case SPELL_REGENERATE                       :
        case SPELL_RESIST_ELEMENTS                  :
        case SPELL_RESISTANCE                       :
        //case SPELL_RESTORATION                      :
        case SPELL_RESURRECTION                     :
        case SPELL_SANCTUARY                        :
        case SPELL_SCARE                            :
        case SPELL_SCINTILLATING_SPHERE             :
        case SPELL_SEE_INVISIBILITY                 :
        //case SPELL_SHAPECHANGE                      :
        //case SPELL_SHELGARNS_PERSISTENT_BLADE       :
        case SPELL_SHIELD_OF_FAITH                  :
        //case SPELL_SHIELD_OF_LAW                    :
        case SPELL_SLEEP                            :
        case SPELL_SLOW                             :
        case SPELL_SOUND_BURST                      :
        case SPELL_SPELL_RESISTANCE                 :
        //case SPELL_SPELLSTAFF                       :
        case SPELL_SPIKE_GROWTH                     :
        case SPELL_STINKING_CLOUD                   :
        case SPELL_STONE_BONES                      :
        case SPELL_STONE_TO_FLESH                   :
        case SPELL_STONESKIN                        :
        case SPELL_SUMMON_CREATURE_I                :
        case SPELL_SUMMON_CREATURE_II               :
        case SPELL_SUMMON_CREATURE_III              :
        case SPELL_SUMMON_CREATURE_IV               :
        case SPELL_SUMMON_CREATURE_V                :
        case SPELL_SUMMON_CREATURE_VI               :
        case SPELL_SUMMON_CREATURE_VII              :
        case SPELL_SUMMON_CREATURE_VIII             :
        case SPELL_SUMMON_CREATURE_IX               :
        case SPELL_SUNBEAM                          :
        case SPELL_SUNBURST                         :
        case SPELL_TASHAS_HIDEOUS_LAUGHTER          :
        //case SPELL_TENSERS_TRANSFORMATION           :
        //case SPELL_UNDEATH_TO_DEATH                 :
        case SPELL_UNDEATHS_ETERNAL_FOE             :
        //case SPELL_UNHOLY_AURA                      :
        case SPELL_VINE_MINE                        :
        case SPELL_VINE_MINE_CAMOUFLAGE             :
        case SPELL_VINE_MINE_ENTANGLE               :
        case SPELL_VINE_MINE_HAMPER_MOVEMENT        :
        case SPELL_VIRTUE                           :
        case SPELL_WALL_OF_FIRE                     :
        case SPELL_WEB                              : bValid = TRUE; break;
    }

    return bValid;
}

void RemoveXP(object oTarget, int nAmount)
{
    int nXP = GetXP(oTarget);
    nXP -= nAmount;

    SetXP(oTarget, nXP);
}

void DestroyItem(object oItem)
{
    int nStack = GetItemStackSize(oItem);

    if (nStack > 1)
    {
        nStack --;
        if (nStack == 0)
        {
            DestroyObject(oItem);
        }
        else
        {
            SetItemStackSize(oItem, nStack);
        }
    }
    else
    {
        DestroyObject(oItem);
    }
}

void DelayDispel(object oTarget, string sAOE)
{
    //Search through the valid effects on the target.
    effect eAOE = GetFirstEffect(oTarget);
    while ( GetIsEffectValid(eAOE))
    {
        //If the effect was created by the Battletide then remove it
        if(GetEffectSpellId(eAOE) == 517)
        {
            RemoveEffect(oTarget, eAOE);
        }
        //Get next effect on the target
        eAOE = GetNextEffect(oTarget);
    }
    DeleteLocalObject(oTarget, sAOE);
}

void MultiSummonPreSummon(object oPC = OBJECT_SELF)
{
    int i=1;
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED,oPC,i);
    while(GetIsObjectValid(oSummon))
    {
        AssignCommand(oSummon,SetIsDestroyable(FALSE,FALSE,FALSE));
        AssignCommand(oSummon,DelayCommand(6.0,SetIsDestroyable(TRUE,FALSE,FALSE)));
        oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC,++i);
    }
}

/*
void RemoveTemporaryHitPoints(int nSpellID, object oTarget = OBJECT_SELF)
{
    effect eRemove = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eRemove))
    {
        if (GetEffectType(eRemove) == EFFECT_TYPE_TEMPORARY_HITPOINTS && GetEffectSpellId(eRemove) == nSpellID)
        {
            RemoveEffect(oTarget, eRemove);
        }
        eRemove = GetNextEffect(oTarget);
    }
}
*/

effect EffectDazzled()
{
    effect eAttack  = EffectAttackDecrease(1, ATTACK_BONUS_MISC);
    effect eSkill1  = EffectSkillDecrease(2, SKILL_SEARCH);
    effect eSkill2  = EffectSkillDecrease(2, SKILL_SPOT);

    effect eLink    = EffectLinkEffects(eAttack, eSkill1);
    eLink           = EffectLinkEffects(eLink, eSkill2);

    return eLink;
}


effect EffectShaken()
{
    effect eAttack  = EffectAttackDecrease(2, ATTACK_BONUS_MISC);
    effect eSave    = EffectSavingThrowDecrease(2, SAVING_THROW_ALL, SAVING_THROW_TYPE_ALL);
    effect eSkill   = EffectSkillDecrease(2, SKILL_ALL_SKILLS);

    effect eLink    = EffectLinkEffects(eAttack, eSave);
    eLink           = EffectLinkEffects(eLink, eSkill);

    return eLink;
}

effect EffectSickened()
{
    effect eAttack  = EffectAttackDecrease(2, ATTACK_BONUS_MISC);
    effect eSave    = EffectSavingThrowDecrease(2, SAVING_THROW_ALL, SAVING_THROW_TYPE_ALL);
    effect eSkill   = EffectSkillDecrease(2, SKILL_ALL_SKILLS);
    effect eDam     = EffectDamageDecrease(2, DAMAGE_TYPE_BASE_WEAPON);

    effect eLink    = EffectLinkEffects(eAttack, eSave);
    eLink           = EffectLinkEffects(eLink, eSkill);
    eLink           = EffectLinkEffects(eLink, eDam);

    return eLink;
}

effect EffectFatigued()
{
    //Include the VFX so it can be removed later via RemoveFatigue()
    effect eStr  = EffectAbilityDecrease(ABILITY_STRENGTH, 2);
    effect eDex  = EffectAbilityDecrease(ABILITY_DEXTERITY, 2);
    effect eMove = EffectMovementSpeedDecrease(25);
    effect eVis =  EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    effect eLink = EffectLinkEffects(eStr, eDex);
    eLink        = EffectLinkEffects(eLink, eMove);
    eLink        = EffectLinkEffects(eLink, eVis);
    eLink        = ExtraordinaryEffect(eLink);

    return eLink;
}

effect EffectExhausted()
{
    //Include the VFX so it can be removed later via RemoveFatigue()
    effect eStr  = EffectAbilityDecrease(ABILITY_STRENGTH, 4);
    effect eDex  = EffectAbilityDecrease(ABILITY_DEXTERITY, 4);
    effect eMove = EffectMovementSpeedDecrease(25);
    effect eVis =  EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    effect eLink = EffectLinkEffects(eStr, eDex);
    eLink        = EffectLinkEffects(eLink, eMove);
    eLink        = EffectLinkEffects(eLink, eVis);
    eLink        = ExtraordinaryEffect(eLink);

    return eLink;
}

void RemoveEffectsFromCaster(object oTarget, object oCaster)
{
    effect eEffect = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eEffect))
    {
        if (GetEffectCreator(eEffect) == oCaster)
            RemoveEffect(oTarget, eEffect);

        eEffect = GetNextEffect(oTarget);
    }
}
