//::///////////////////////////////////////////////
//:: Magic Convalescence (on exit)
//:: NW_S0_MgcConvlb.nss
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
    //Declare major variables
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
    object oCreator = GetAreaOfEffectCreator();
    string sAOELinkId = "";
    string sEffectTag = "";
    effect eAOE;

    effect eExistingEffect;

    //No need to check that the exiting object is a creature, the OnExit function only applies to creatures
    //Check that target and creator are different, otherwise this function can interfere with the reappliance of the effect in the main script function
    if(oCreator != oTarget)
    {
        //Find the AOE effect on the creator
        eAOE = gsSPfindEffect(SPELL_MAGIC_CONVAL_ID, oCreator, oCreator);

        //Get the Effect Link Id
        sEffectTag = GetEffectLinkId(eAOE);

        eExistingEffect = gsSPfindEffect(SPELL_MAGIC_CONVAL_ID, oTarget, oCreator);

        //First check that this creature has the effect already applied by the same creator so it does not stack
        if(GetEffectSpellId(eExistingEffect) == SPELL_MAGIC_CONVAL_ID && GetEffectCreator(eExistingEffect) == oCreator && GetEffectTag(eExistingEffect) == sEffectTag)
        {
            if(GetDistanceBetween(oTarget, oCreator) > SPELL_MAGIC_CONVAL_RADIUS)
            {
                RemoveEffect(oTarget,eExistingEffect);
            }
        }
    }
}
