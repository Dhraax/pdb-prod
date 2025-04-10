//::///////////////////////////////////////////////
//:: Sunbeam
//:: s_Sunbeam.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:: All creatures in the beam are struck blind and suffer 4d6 points of damage. (A successful
//:: Reflex save negates the blindness and reduces the damage by half.) Creatures to whom sunlight
//:: is harmful or unnatural suffer double damage.
//::
//:: Undead creatures caught within the ray are dealt 1d6 points of damage per caster level
//:: (maximum 20d6), or half damage if a Reflex save is successful. In addition, the ray results in
//:: the total destruction of undead creatures specifically affected by sunlight if they fail their saves.
//:://////////////////////////////////////////////
//:: Created By: Keith Soleski
//:: Created On: Feb 22, 2001
//:://////////////////////////////////////////////
//:: Last Modified By: Keith Soleski, On: March 21, 2001
//:: VFX Pass By: Preston W, On: June 25, 2001

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "colors_inc"

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);

    if (!X2PreSpellCastCode()) return;

    //Si tiene la dote Urdimbre Sombria el conjuro falla.
    if( GetHasFeat(1354, OBJECT_SELF))
    {
        SetModuleOverrideSpellScriptFinished();
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(62), OBJECT_SELF);
        SendMessageToPC(OBJECT_SELF, ColorToken(254,60,60) + "Este conjuro no funciona con Urdimbre Sombria.</c>");
        return;
    }

    //Declare major variables
    int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
    effect eVis2 = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
    effect eStrike = EffectVisualEffect(VFX_FNF_SUNBEAM);
    effect eDam;
    effect eBlind = EffectBlindness();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eBlind, eDur);

    int nCasterLevel = GetTotalCasterLevel(OBJECT_SELF);
    int nDamage;
    int nOrgDam;
    int nMax;
    int bDoNotDoDamage = FALSE;
    float fDelay;
    int nBlindLength = nCasterLevel;
    //Limit caster level
    if (nCasterLevel > 20) nCasterLevel = 20;

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eStrike, GetSpellTargetLocation());
    //Get the first target in the spell area
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetSpellTargetLocation());
    while(GetIsObjectValid(oTarget))
    {
        // Make a faction check
        if ((GetHasFeat(FEAT_MASTERY_SHAPES, OBJECT_SELF)) && (GetLocalInt(OBJECT_SELF, "archmage_mastery_shaping") == 1) && (!GetIsReactionTypeHostile(oTarget, OBJECT_SELF) || oTarget == OBJECT_SELF || GetMaster(oTarget) == OBJECT_SELF))
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SPELL_MANTLE_USE), oTarget);
        }
        else if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            fDelay = GetRandomDelay(1.0, 2.0);
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SUNBEAM));
            //Make an SR check
            if (!MyResistSpell(OBJECT_SELF, oTarget, 1.0))
            {
                // * if a vampire then destroy it
                if (GetAppearanceType(oTarget) == APPEARANCE_TYPE_VAMPIRE_MALE || GetAppearanceType(oTarget) == APPEARANCE_TYPE_VAMPIRE_FEMALE || GetStringLowerCase(GetSubRace(oTarget)) == "vampire" || GetStringLowerCase(GetSubRace(oTarget)) == "vampiro" )
                {
                    // SpeakString("I vampire");
                    // * if reflex saving throw fails no blindness
                    if (!ReflexSave(oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(OBJECT_SELF)), SAVING_THROW_TYPE_SPELL))
                    {
                        effect eDeath = EffectDeath();
                        effect eExplode = EffectVisualEffect(VFX_IMP_FLAME_M);

                        // Need to make this supernatural, so that it ignores death immunity.
                        eDeath = SupernaturalEffect( eDeath );
                        //Apply epicenter explosion on caster
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eExplode, oTarget);
                        if(GetHasSpellEffect(1329,oTarget)) SetImmortal(oTarget, FALSE);
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
                        bDoNotDoDamage = TRUE;
                    }
                }
                if (!bDoNotDoDamage) {
                    //Check if the target is an undead or ooze
                    if (PB_Race_GetIsUndead(oTarget) || GetRacialType(oTarget) == RACIAL_TYPE_OOZE)
                    {
                        //Roll damage and save
                        nCasterLevel = GetTotalCasterLevel(OBJECT_SELF);
                        nDamage = d6(nCasterLevel);
                        nMax = 6;
                    }
                    else {
                        //Roll damage and save
                        nDamage = d6(3);
                        nOrgDam = nDamage;
                        nMax = 6;
                        nCasterLevel = 3;
                        //Get the adjusted damage due to Reflex Save, Evasion or Improved Evasion
                    }

                    //Do metamagic checks
                    if (nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = nMax * nCasterLevel;
                    if (nMetaMagic == METAMAGIC_EMPOWER) nDamage = nDamage + (nDamage/2);
                }

                //Check that a reflex save was made.
                if(MySavingThrow(SAVING_THROW_REFLEX, oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(OBJECT_SELF)), SAVING_THROW_TYPE_DIVINE, OBJECT_SELF, 1.0) == 0)
                {
                    DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nBlindLength)));
                }
                else nDamage = GetReflexAdjustedDamage(nDamage, oTarget, 0, SAVING_THROW_TYPE_DIVINE);

                //Set damage effect
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_DIVINE);
                if(nDamage > 0)
                {
                    //Apply the damage effect and VFX impact
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                }
            }

            bDoNotDoDamage = FALSE;
        }

        //Get the next target in the spell area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetSpellTargetLocation());
    }

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
