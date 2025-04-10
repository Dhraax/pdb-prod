//::///////////////////////////////////////////////
//:: Disintegrate
//:: NW_S0_Disint
//:: Created By: Mimiqp (mimiqp100@gmail.com)
//:: Created On: Jun 03, 2024
//:://////////////////////////////////////////////
/*
    Any creature struck by the ray takes 2d6 points of damage per caster level
    (to a maximum of 40d6).
    Any creature reduced to 0 or fewer hit points by this spell is entirely
    disintegrated, leaving behind only a trace of fine dust.
*/
//:://////////////////////////////////////////////


#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "pb_nivellanzador"

const int VFX_DISINT_FLAME = 7208;
const int VFX_DISINT_IMPACT = 7209;
const int SPELL_DISINTEGRATE = 1398;

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);

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
    object oTarget = GetSpellTargetObject();
    int nTouch = TouchAttackRanged(oTarget);
    int nCasterLevel = GetTotalCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();

    if(nCasterLevel > 20)
    {
        nCasterLevel = 20;
    }

    int nDice = nCasterLevel*2;
    int nDamage = d6(nDice);

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
        nDamage = 40*6;//Damage is at max
    }
    else if (nMetaMagic == METAMAGIC_EMPOWER)
    {
        nDice = (nCasterLevel + nCasterLevel/2) * 2;
        nDamage = d6(nDice); //Damage is +50%
    }

    // Create the effect to apply
    effect eDeath = EffectDeath(FALSE, TRUE);

    effect eVis = EffectVisualEffect(VFX_DISINT_FLAME);
    effect eVis2 = EffectVisualEffect(VFX_DISINT_IMPACT);
    effect eInv = EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY);
    effect eRay = EffectBeam(VFX_BEAM_DISINTEGRATE, OBJECT_SELF, BODY_NODE_HAND);
    effect ePetrify = EffectPetrify();

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DISINTEGRATE));

        if (nTouch != FALSE && !MyResistSpell(OBJECT_SELF, oTarget))
        {
            //Make a saving throw check
            if(MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE))
            {
                nDamage = d6(5);
            }

            //Check for critical hit
            if(nTouch == 2)
            {
                nDamage = nDamage * 2;
            }

            effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);

            //If health of the creature will reach 0
            if(nDamage>GetCurrentHitPoints(oTarget))
            {
                //Apply effect petrify
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePetrify, oTarget, 10.0);

                //Kill the creature if their health reaches 0
                DelayCommand(0.5, SetKilled(OBJECT_SELF, oTarget));

                DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInv, oTarget, 10.0));

                DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis2, oTarget, 10.0));
                DelayCommand(11.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
            }

            DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
        }
    }

    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7);

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
