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
    object oPC = OBJECT_SELF;
    int nDuration = GetTotalCasterLevel(oPC);
    int nDG = 0;
	int ShadowArc = GetLevelByClass(46, oPC);
	int ShadowDiv = GetLevelByClass(55, oPC);
    int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;

    //Do metamagic extend check
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
       nDuration *= 2;  //Duration is +100%
    }

	//La RC solo suma nivel de adepto
	if(ShadowArc > 0){ nDG += ShadowArc; }
	if(ShadowDiv > 0){ nDG += ShadowDiv; }

    effect eAC = EffectACIncrease(4, AC_DODGE_BONUS);
    effect eInmu = EffectSpellImmunity(SPELL_MAGIC_MISSILE);
    effect eRes = EffectSpellResistanceIncrease(12+nDG);
    effect eConceal = EffectConcealment(20);
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH_WARD);
    effect eShadow = EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);


    //Link major effects
    effect eLink = EffectLinkEffects(eInmu, eAC);
    eLink = EffectLinkEffects(eLink, eVis);
    eLink = EffectLinkEffects(eLink, eConceal);
    eLink = EffectLinkEffects(eLink, eShadow);
    eLink = EffectLinkEffects(eLink, eRes);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
    //Apply linked effect
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, (TurnsToSeconds(nDuration)/2));
}

