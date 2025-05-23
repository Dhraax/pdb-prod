#include "x2_inc_spellhook"
#include "pb_nivellanzador"

void main()
{

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nDuration = GetTotalCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
    //Do metamagic extend check
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
       nDuration *= 2;  //Duration is +100%
    }

    effect eAC = EffectACIncrease(4, AC_DODGE_BONUS);
    effect eInmu = EffectSpellImmunity(SPELL_MAGIC_MISSILE);
    effect eConceal = EffectConcealment(20);
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH_WARD);
    effect eShadow = EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);


    //Link major effects
    effect eLink = EffectLinkEffects(eInmu, eAC);
    eLink = EffectLinkEffects(eLink, eVis);
    eLink = EffectLinkEffects(eLink, eConceal);
    eLink = EffectLinkEffects(eLink, eShadow);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
    //Apply linked effect
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, (TurnsToSeconds(nDuration)/2));
}
