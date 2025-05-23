//::///////////////////////////////////////////////
//:: Haste
//:: NW_S0_Haste.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Gives the targeted creature one extra partial
    action per round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 29, 2001
//:://////////////////////////////////////////////
// Modified March 2003: Remove Expeditious Retreat effects

//#include "x0_i0_spells"
#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "pb_nivellanzador"
#include "inc_spells"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);
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
    object oTarget;

  /*if (GetHasSpellEffect(SPELL_EXPEDITIOUS_RETREAT, oTarget) == TRUE)
    {
        RemoveSpellEffects(SPELL_EXPEDITIOUS_RETREAT, OBJECT_SELF, oTarget);
    }

    if (GetHasSpellEffect(647, oTarget) == TRUE)
    {
        RemoveSpellEffects(647, OBJECT_SELF, oTarget);
    }   */

    effect eAC = EffectACIncrease(1, AC_DODGE_BONUS);
    effect eVis2 = EffectVisualEffect(VFX_DUR_SMOKE);
    eVis2 = TagEffect(eVis2, "SPELL_ACELERARVISUAL");
    effect eRef = EffectSavingThrowIncrease(SAVING_THROW_REFLEX ,1);
    effect eAttack = EffectAttackIncrease(1);
    effect eAtk = EffectModifyAttacks(1);
    effect eMov = EffectMovementSpeedIncrease(50);
    effect eVis = EffectVisualEffect(VFX_IMP_HASTE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eAC, eAttack);
           eLink = EffectLinkEffects(eLink, eAtk);
           eLink = EffectLinkEffects(eLink, eMov);
           eLink = EffectLinkEffects(eLink, eDur);
           eLink = EffectLinkEffects(eLink, eVis2);
           eLink = EffectLinkEffects(eLink, eRef);
           eLink = TagEffect(eLink, "SPELL_ACELERAR");

    int nDuration = GetTotalCasterLevel(OBJECT_SELF);
    int nMasa = GetTotalCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
    location lSpell = GetSpellTargetLocation();
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    float fDelay;
    int nCount;

    //Check for metamagic extension
        if (nMetaMagic == METAMAGIC_EXTEND)
        {
           nDuration = nDuration * 2;  //Duration is +100%
        }

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lSpell);
    //Cycle through the targets within the spell shape until an invalid object is captured or the number of
    //targets affected is equal to the caster level.
    while(GetIsObjectValid(oTarget) && nCount != nMasa)
    {

    //Make faction check on the target
        if(GetIsFriend(oTarget))
        {
            if (GetHasSpellEffect(SPELL_EXPEDITIOUS_RETREAT, oTarget) == TRUE)
            {
                gsSPRemoveEffect(oTarget,456);
            }
            if (GetHasSpellEffect(647, oTarget) == TRUE)
            {
                gsSPRemoveEffect(oTarget,647);
            }
            if (GetHasSpellEffect(78, oTarget) == TRUE)
            {
                gsSPRemoveEffect(oTarget,78);
            }
            if (GetHasSpellEffect(113, oTarget) == TRUE)
            {
                gsSPRemoveEffect(oTarget,113);
            }
            PJ_EfectoQuitarTag(oTarget, "POCION_SIDRAPERA");
            PJ_EfectoQuitarTag(oTarget, "SPELL_ACELERAR");
            PJ_EfectoQuitarTag(oTarget, "SPELL_ACELERARVISUAL");

            fDelay = GetRandomDelay(0.0, 1.0);
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HASTE, FALSE));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration)));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            nCount++;
        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lSpell);

    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
