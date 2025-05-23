//::///////////////////////////////////////////////
//:: [Control Undead]
//:: [NW_S0_ConUnd.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
    A single undead with up to 3 HD per caster level
    can be dominated.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 2, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk
//:: Last Updated On: April 6, 2001

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "pb_nivellanzador"

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
    effect eControl = EffectDominated();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_DOMINATE_S);
    effect eLink = EffectLinkEffects(eMind, eControl);
    eLink = EffectLinkEffects(eLink, eDur);

    int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
    object oItm = GetSpellCastItem();
    int iLividez = 0;
    if(oItm == OBJECT_INVALID) iLividez = GetLevelByClass(CLASS_TYPE_PALEMASTER,OBJECT_SELF);

    int nCasterLevel = GetTotalCasterLevel(OBJECT_SELF) + iLividez;
    int nDuration = nCasterLevel;
    int nHD = nCasterLevel * 2;
    //Make meta magic
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nCasterLevel * 2;
    }
    if (PB_Race_GetIsUndead(oTarget) && GetHitDice(oTarget) <= nHD)
    {
        if(!GetIsReactionTypeFriendly(oTarget))
        {
           //Fire cast spell at event for the specified target
           SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CONTROL_UNDEAD));
           if (!MyResistSpell(OBJECT_SELF, oTarget))
           {
                //Make a Will save
                if (!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(OBJECT_SELF)), SAVING_THROW_TYPE_NONE, OBJECT_SELF, 1.0))
                {
                    //Apply VFX impact and Link effect
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration)));
                    //Increment HD affected count
                   DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
                }
            }
        }
    }
}
