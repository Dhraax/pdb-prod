//::///////////////////////////////////////////////
//:: Unholy Aura
//:: NW_S0_UnhAura.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Objetivos: cualquier criatura no hostil en una
    esfera de 20m de radio
    Bonos:
    +4 Ca desvio y +4 salvaciones universales contra todos
    RC 25 e immunidad conjuros enajenadores solo contra buenos
    escudo de danyo 3+1d4 contra todos
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 1 enero 2010
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "x0_i0_spells"
#include "pb_nivellanzador"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);
    /*
      Spellcast Hook Code
      Added 2003-06-20 by Georg
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more

    */

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    // End of Spell Cast Hook

    //Declare major variables
    int nDuration = GetTotalCasterLevel(OBJECT_SELF);
    int nTargets = nDuration - 1;
    int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
    float fDelay;

    if (nMetaMagic == METAMAGIC_EXTEND)
    {
       nDuration = nDuration * 2;    //Duration is +100%
    }

    effect eVis  = EffectVisualEffect(VFX_FNF_LOS_EVIL_30);
    effect eDur  = EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MAJOR);
    effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    effect eAC     = EffectACIncrease(4, AC_DEFLECTION_BONUS);
    effect eSave   = EffectSavingThrowIncrease(SAVING_THROW_ALL, 4);
    effect eSR     = EffectSpellResistanceIncrease(25);
    effect eImmune = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
    effect eEvil   = EffectDamageShield(3, DAMAGE_BONUS_1d4, DAMAGE_TYPE_NEGATIVE);

    // * make them versus the alignment
    eSR = VersusAlignmentEffect(eSR,ALIGNMENT_ALL, ALIGNMENT_GOOD);
    eImmune = VersusAlignmentEffect(eImmune, ALIGNMENT_ALL, ALIGNMENT_GOOD);
    eEvil = VersusAlignmentEffect(eEvil,ALIGNMENT_ALL, ALIGNMENT_GOOD);

    //Link effects
    effect eLink = EffectLinkEffects(eDur, eDur2);
    eLink = EffectLinkEffects(eLink, eAC);
    eLink = EffectLinkEffects(eLink, eSave);
    eLink = EffectLinkEffects(eLink, eSR);
    eLink = EffectLinkEffects(eLink, eImmune);
    eLink = EffectLinkEffects(eLink, eEvil);

    //--------------------------------------------------------------------------
    // GZ: Make sure this aura is only active once
    //--------------------------------------------------------------------------
    RemoveEffectsFromSpell(OBJECT_SELF, SPELL_HOLY_AURA);
    RemoveEffectsFromSpell(OBJECT_SELF, SPELL_UNHOLY_AURA);

    //Get the first target in the radius around the caster
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 20.0, GetSpellTargetLocation());
    while(GetIsObjectValid(oTarget) && nTargets != 0)
    {
        if(GetIsFriend(oTarget) && OBJECT_SELF != oTarget)
        {
            //--------------------------------------------------------------------------
            // GZ: Make sure this aura is only active once
            //--------------------------------------------------------------------------
            RemoveEffectsFromSpell(oTarget, SPELL_HOLY_AURA);
            RemoveEffectsFromSpell(oTarget, SPELL_UNHOLY_AURA);

            fDelay = GetRandomDelay();

            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_UNHOLY_AURA, FALSE));

            //Apply the VFX impact and effects a los companyeros
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration)));

            nTargets--;
        }
        //Get the next target in the specified area around the caster
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 20.0, GetSpellTargetLocation());
    }

    //Apply the VFX impact and effects al lanzador
    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF));
    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(nDuration)));
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
