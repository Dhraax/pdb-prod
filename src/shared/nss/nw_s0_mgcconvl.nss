//::///////////////////////////////////////////////
//:: Magic Convalescence
//:: NW_S0_MgcConvl.nss
//:: Created By: Mimiqp (mimiqp100@gmail.com)
//:: Created On: Jun 03, 2024
//:://////////////////////////////////////////////
/*
    You alter the flow of magic about your body so that spells heal you.
    Whenever a creature, including you, casts a spell within the area of this spell, you heal 1 hit point per level of the spell cast.
    The effect of each spell cast is resolved prior to your receiving the healing.
    Material Component: A specially prepared, scented ointment.
*/

#include "x2_inc_spellhook"
#include "nw_s0_mgcconvlf"


//------------------------------------------------------------------------------
//Function to remove an existing spell effect
//Returns:
//        0 if no effect was removed
//        1 if an effect was removed
//------------------------------------------------------------------------------
int removeExistingEffect(int nSpellID, float fDuration, object oTarget=OBJECT_SELF);

//------------------------------------------------------------------------------
//Function to remove an existing spell effects at location
//Returns: the amount of effects removed
//------------------------------------------------------------------------------
int removeExistingEffectsAtLocation(int nSpellID, float fDuration, location lLocation);

//------------------------------------------------------------------------------
//Function to apply the effect
//------------------------------------------------------------------------------
void applyEffect(float fDuration);


void main()
{

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
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
    float fDuration = GetCasterLevel(OBJECT_SELF) * SPELL_MAGIC_CONVAL_DUR_MULT;
    int nMetaMagic = GetMetaMagicFeat();
    int nWasSpellRemoved = 0;
    int nSpellID = GetSpellId();
    int nAlreadyHasEffect = GetHasSpellEffect(nSpellID, OBJECT_SELF);
    effect eExistingEffect;
    int nEffectRemoved = FALSE;
    int nEffectsRemoved = 0;

    if (nMetaMagic == METAMAGIC_EXTEND)
    {
       fDuration = fDuration * 2;    //Duration is +100%
    }


    //If the caster already has this effect
    if (nAlreadyHasEffect>0)
    {
        //Let's first try to remove an existing effect if it exists and its duration is lower than the new attempted effect
        nEffectRemoved = removeExistingEffect(nSpellID, fDuration);

        //If an effect was removed, then look in the area for any creatures having this effect and remove it
        //This is done here and not left to the OnExit function because it was observed that after applying the new effect later on
        //The OnEnter of the new effect was executed before the OnExit of the old effect
        //This caused that the OnExit removed the effect and there was no effect left on the creature
        //Therefore, we enforce the removal here to prevent that from happening
        if(nEffectRemoved)
        {
            removeExistingEffectsAtLocation(nSpellID, fDuration, GetLocation(OBJECT_SELF));
        }
    }

    //Try to find an effect after the removal
    eExistingEffect = gsSPfindEffect(nSpellID);

    //Check that the target does not have the effect before applying it
    //This is a safeguard in case it had the effect and the removal function did not manage to remove the effect
    //The function GetHasSpellEffect is bugged because it returns 1 even after removing the effect, probably it takes time
    //for that to refresh. Therefore, we look for the event to try to find it and check that it is valid
    if(GetHasSpellEffect(nSpellID, OBJECT_SELF)<=0 || GetIsEffectValid(eExistingEffect)<=0)
    {
        applyEffect(fDuration);
    }

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

//------------------------------------------------------------------------------
//Function to apply the effect
//------------------------------------------------------------------------------
void applyEffect(float fDuration)
{
    //Area of effect
    effect eAOE = EffectAreaOfEffect(47);

    //Visual effect
    effect eVis;

    int nEffect;
    eVis = EffectVisualEffect(VFX_MAGIC_CONVALESCENCE_AURA, FALSE, 2.0);

    //Icon
    effect eIcon = EffectIcon(VFX_MAGIC_CONVALESCENCE_ICON);

    //Linking both AOE and VFX
    effect eLink = EffectLinkEffects(eAOE,eVis);
    eLink = EffectLinkEffects(eLink,eIcon);

    //Apply the effect
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, fDuration);

    object oExistingObject = GetNearestObjectByTag("VFX_MOB_MAGIC_CONV");


    SetLocalString(oExistingObject,"EFFECT_LINK_ID",GetEffectLinkId(eLink));


    //Fire cast spell at event for the specified eEffectt OBJECT_SELF
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_MAGIC_CONVAL_ID, FALSE));
}

//------------------------------------------------------------------------------
//Function to remove an existing spell effect
//Returns:
//        0 if no effect was removed
//        1 if an effect was removed
//------------------------------------------------------------------------------
int removeExistingEffect(int nSpellID, float fDuration, object oTarget=OBJECT_SELF)
{
    int nReturn = 0;

    //If the caster already has this effect
    if (GetHasSpellEffect(nSpellID, oTarget))
    {
        //Let's find the effect that the target already has
        effect eExistingEffect = gsSPfindEffect(nSpellID, oTarget, OBJECT_SELF);

        //If the duration of the existing effect is lower than the duration of the attempted new effect
        //then remove the existing effect
        if(GetIsEffectValid(eExistingEffect) && GetEffectSpellId(eExistingEffect) == nSpellID && IntToFloat(GetEffectDurationRemaining(eExistingEffect)) < fDuration)
        {

            RemoveEffect(oTarget,eExistingEffect);
            nReturn = TRUE;
        }
    }

    return nReturn;
}

//------------------------------------------------------------------------------
//Function to remove an existing spell effects at location
//Returns: the amount of effects removed
//------------------------------------------------------------------------------
int removeExistingEffectsAtLocation(int nSpellID, float fDuration, location lLocation)
{
    int nReturn = 0;
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, SPELL_MAGIC_CONVAL_RADIUS, lLocation);

    while(GetIsObjectValid(oTarget))
    {
        //A negative number is passed so that it is removed regardless of the remaining duration (which is normally > 0)
        removeExistingEffect(nSpellID, -1.0, oTarget);

        oTarget = GetNextObjectInShape(SHAPE_SPHERE, SPELL_MAGIC_CONVAL_RADIUS, lLocation);
        nReturn++;
    }

    return nReturn;
}



