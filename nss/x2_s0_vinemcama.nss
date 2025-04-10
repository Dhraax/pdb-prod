//::///////////////////////////////////////////////
//:: Vine Mine, Camouflage: On Enter
//:: X2_S0_VineMCamA
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Friendly creatures entering the zone of Vine Mine,
    Camouflage have a +4 added to hide checks.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 25, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs, 02/06/2003

#include "NW_I0_SPELLS"
#include "x0_i0_spells"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);
    //Declare major variables
    object oTarget = GetEnteringObject();

    if(spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, GetAreaOfEffectCreator()))
    {
        if(!GetHasSpellEffect(GetSpellId(), oTarget))
        {
            //Fire cast spell at event for the target
            SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), GetSpellId(), FALSE));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEAD_NATURE), oTarget);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), oTarget);
            DoNoStackSkillBonus(OBJECT_SELF, oTarget, 4, SKILL_HIDE, 999999.9, GetSpellId());
            DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        }
    }
}
