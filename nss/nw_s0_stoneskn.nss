//::///////////////////////////////////////////////
//:: Stoneskin
//:: NW_S0_Stoneskin
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Gives the creature touched 10/+5
    damage reduction.  This lasts for 1 hour per
    caster level or until 10 * Caster Level (100 Max)
    is dealt to the person.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: March 16 , 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001

#include "nw_i0_spells"
#include "x2_inc_spellhook"
#include "pb_nivellanzador"
#include "colors_inc"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);
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
    effect eStone;
    effect eVis = EffectVisualEffect(VFX_DUR_PROT_STONESKIN);
    effect eVis2 = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect eLink;
    object oTarget = GetSpellTargetObject();
/////////////////////////////
int iExtra = 0;
    object oItm = GetSpellCastItem();
    if(oItm == OBJECT_INVALID && GetItemPossessedBy(OBJECT_SELF, "raizmolida")!= OBJECT_INVALID)
        {
        iExtra = 10;
        SendMessageToPC(OBJECT_SELF,ColorToken(33,33,180) + "!El conjuro parece haberse potenciado con la raíz molida!</c>");
        object oIngrediente = GetItemPossessedBy(OBJECT_SELF,"raizmolida");
        DestroyObject(oIngrediente);

        effect eUki = EffectVisualEffect(353);//escarbar en el suelo
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eUki, oTarget);
        }
//////////////////////////////
    int nDuration = GetTotalCasterLevel(OBJECT_SELF);
    int nAmount = nDuration * 10;
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_STONESKIN, FALSE));
    //Limit the amount protection to 100 points of damage
    if (nAmount > 100)
    {
        nAmount = 100;
    }
///////////////////////

    nAmount = nAmount +iExtra;
//////////////////////
    //Meta Magic
    if((GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE) == METAMAGIC_EXTEND)
    {
        nDuration *= 2;
    }

    //Define the damage reduction effect
    eStone = EffectDamageReduction(10, DAMAGE_POWER_PLUS_FIVE, nAmount);
    //Link the effects
    eLink = EffectLinkEffects(eStone, eVis);
    eLink = EffectLinkEffects(eLink, eDur);

    RemoveEffectsFromSpell(oTarget, SPELL_STONESKIN);

    //Apply the linked effects.
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration));
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
