// Green Slime OnTrapTriggered event script
//:://////////////////////////////////////////////
void main()
{

    object oPC = GetEnteringObject();
    location lTarget = GetLocation(oPC);

    //trap impact - just for show
    effect eImpact = EffectVisualEffect(VFX_IMP_BIGBYS_FORCEFUL_HAND);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oPC);

    //spawn the slime
    CreateObject(OBJECT_TYPE_CREATURE, "qc_greenslime", lTarget, TRUE);
}

