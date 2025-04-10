#include "x2_inc_spellhook"
#include "nw_i0_spells"
#include "inc_spells"

void main()
{
    object oTarget = GetExitingObject();
    object oCaster = GetAreaOfEffectCreator();
    int iSpell = GetSpellId();

    if(GetHasSpellEffect(1102, oCaster))
    {
        gsSPRemoveEffect(oTarget, iSpell);

        if(gsSPGetIsAffected(GS_SP_TYPE_HARMFUL_SELECTIVE, oCaster, oTarget))
        {
            gsSPApplyEffect(oTarget, EffectSavingThrowDecrease(SAVING_THROW_ALL, 2), 1102, RoundsToSeconds(5));
        }
    }
}



