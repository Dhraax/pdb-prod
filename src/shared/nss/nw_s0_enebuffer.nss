//::///////////////////////////////////////////////
//:: Energy Buffer
//:: NW_S0_EneBuffer
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The caster is protected from all five energy
    types for up to 3 per caster level. When
    one element type is spent all five are
    removed.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 12, 2001
//:://////////////////////////////////////////////

#include "nw_i0_spells"
#include "pb_nivellanzador"
#include "x2_inc_spellhook"
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


    object oTarget = GetSpellTargetObject();
    //Declare major variables
    //Ukichapu
    int iExtra = 0;
    object oItm = GetSpellCastItem();
    if(oItm == OBJECT_INVALID && GetItemPossessedBy(OBJECT_SELF, "arenillaresi")!= OBJECT_INVALID)
        {
        iExtra = 15;
        SendMessageToPC(OBJECT_SELF,ColorToken(33,33,180) + "!El conjuro parece haberse potenciado con la arenilla resinosa!</c>");
        object oIngrediente = GetItemPossessedBy(OBJECT_SELF,"arenillaresi");
        DestroyObject(oIngrediente);

        effect eUki = EffectVisualEffect(137);//escarbar en el suelo
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eUki, oTarget);
        }
    int nDuration = GetTotalCasterLevel(OBJECT_SELF);
    int nAmount = 60 + iExtra;      /*extra ukichapu*/
    int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
    effect eCold = EffectDamageResistance(DAMAGE_TYPE_COLD, 40, nAmount);
    effect eFire = EffectDamageResistance(DAMAGE_TYPE_FIRE, 40, nAmount);
    effect eAcid = EffectDamageResistance(DAMAGE_TYPE_ACID, 40, nAmount);
    effect eSonic = EffectDamageResistance(DAMAGE_TYPE_SONIC, 40, nAmount);
    effect eElec = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 40, nAmount);
    effect eDur = EffectVisualEffect(VFX_DUR_PROTECTION_ELEMENTS);
    effect eVis = EffectVisualEffect(VFX_IMP_ELEMENTAL_PROTECTION);
    effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ENERGY_BUFFER, FALSE));

    //Link Effects
    effect eLink = EffectLinkEffects(eCold, eFire);
    eLink = EffectLinkEffects(eLink, eAcid);
    eLink = EffectLinkEffects(eLink, eSonic);
    eLink = EffectLinkEffects(eLink, eElec);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eDur2);

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }

     RemoveEffectsFromSpell(oTarget, GetSpellId());

    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
