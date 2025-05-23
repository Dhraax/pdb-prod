//::///////////////////////////////////////////////
//:: Destruction
//:: NW_S0_Destruc
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The target creature is destroyed if it fails a
    Fort save, otherwise it takes 10d6 damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 13, 2001
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);
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
    int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
    int nDamage;
    effect eDeath = EffectDeath();
    effect eDam;
    effect eVis = EffectVisualEffect(234);
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DESTRUCTION));
        //Make SR check
        if(!MyResistSpell(OBJECT_SELF, oTarget))
        {
            //Make a saving throw check
            if(!/*Fort Save*/ MySavingThrow(SAVING_THROW_FORT, oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(OBJECT_SELF))))
            {
                //Apply the VFX impact and effects
                if(GetHasSpellEffect(1329,oTarget))
                     {
                     SetImmortal(oTarget, FALSE);
                     }
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
            }
            else
            {
                nDamage = d6(10);
                //Enter Metamagic conditions
                if (nMetaMagic == METAMAGIC_MAXIMIZE)
                {
                    nDamage = 60;//Damage is at max
                }
                else if (nMetaMagic == METAMAGIC_EMPOWER)
                {
                    nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
                }
                //Set damage effect
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_DIVINE);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
            }
            //Apply VFX impact
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        }
    }
}
