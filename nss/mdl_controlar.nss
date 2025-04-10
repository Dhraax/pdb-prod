//::///////////////////////////////////////////////
//:: Maestro de la Lividez
//:: Controlar Muerto Viviente
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
#include "pb_nivellanzador"

void main()
{
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nCasterLvl = GetTotalCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    int nId = GetSpellId();

    //Declare effects
    effect ePara = EffectCutsceneDominated();
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    eDur = EffectLinkEffects(eVis,eDur);
    int nDC = GetLevelByClass(CLASS_TYPE_PALEMASTER);

if (PB_Race_GetIsUndead(oTarget) && GetHitDice(oTarget) <= nCasterLvl)
    {
        if (TouchAttackMelee(oTarget,TRUE)>0)
        {

        //Signal spell cast at event
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

            //Apply effects to target and caster
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDur, oTarget);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePara, oTarget, RoundsToSeconds(nDC));

        }
    }
else { IncrementRemainingFeatUses(OBJECT_SELF, 1562); SendMessageToPC(OBJECT_SELF, "No puedes controlar a esta criatura"); }


}
