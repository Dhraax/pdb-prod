//::///////////////////////////////////////////////
//:: Magic Convalescence (on enter)
//:: NW_S0_MgcConvla.nss
//:: Created By: Mimiqp (mimiqp100@gmail.com)
//:: Created On: Jun 03, 2024
//:://////////////////////////////////////////////
/*
    You alter the flow of magic about your body so that spells heal you.
    Whenever a creature, including you, casts a spell within the area of this spell, you heal 1 hit point per level of the spell cast.
    The effect of each spell cast is resolved prior to your receiving the healing.
    Material Component: A specially prepared, scented ointment.
*/


#include "nw_s0_mgcconvlf"


void main()
{
    object oTarget = GetEnteringObject();
    object oCreator = GetAreaOfEffectCreator();

    effect eEffect = EffectMovementSpeedIncrease(0);
    eEffect = EffectLinkEffects(eEffect,EffectIcon(VFX_MAGIC_CONVALESCENCE_ICON));

    eEffect = SetEffectCreator(eEffect, oCreator);
    eEffect = SetEffectSpellId(eEffect, SPELL_MAGIC_CONVAL_ID);
    effect eAOE;
    string sEffectID = "";
    float fDurationRemaining = 0.0;

    effect eExistingEffect;

    //No need to check that the entering object is a creature, the OnEnter function only applies to creatures
    //Check that target and creator are different, otherwise do not apply the effect as the creator already has it
    if(oCreator != oTarget)
    {
        //Find the event on the entering object
        eExistingEffect = gsSPfindEffect(SPELL_MAGIC_CONVAL_ID, oTarget, oCreator);

        //First check that this creature does not have the effect already applied by the same caster so it does not stack
        //If it does, then remove it so that it can be reapplied
        if(GetEffectSpellId(eExistingEffect) == SPELL_MAGIC_CONVAL_ID && GetEffectCreator(eExistingEffect) == oCreator)
        {
            RemoveEffect(oTarget, eExistingEffect);
        }

        //Attempting to find the AOE effect from the creator in order to extract the duration later on
        eAOE = gsSPfindEffect(SPELL_MAGIC_CONVAL_ID, oCreator, oCreator);

        //Get the unique identifier of the effect
        sEffectID = GetEffectLinkId(eAOE);

        //Tag the effect. This will be used in the onExit script to make sure we don't remove an effect of a new
        //instance of the AOE if the spell was recast
        //This is prone to happen since when the spell is recast and the effect is reapplied on the caster, before
        //reapplying the effect we remove the existing AOE.
        //Removing the existing AOE will fire the OnExit function, but unfortunately it is executed too late, that is
        //after the OnEnter function of the new AOE that is applied on the target. If we then don't identify the effect
        //uniquely, the OnExit function that runs last could remove the effect applied by the OnEnter function that run before.
        eEffect = TagEffect(eEffect, sEffectID);

        //Duration remaining on the AOE effect
        fDurationRemaining = IntToFloat(GetEffectDurationRemaining(eAOE));

        //Apply the VFX impact and effects
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, fDurationRemaining);

        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELL_MAGIC_CONVAL_ID, FALSE));
    }
}

