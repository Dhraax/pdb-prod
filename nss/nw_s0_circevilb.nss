//::///////////////////////////////////////////////
//:: Magic Cirle Against Evil
//:: NW_S0_CircEvilB
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Remove basic protection from evil effects from
    exiting creatures.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 20, 2001
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"

#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);
    //Declare major variables
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
    int bValid = FALSE;
    //Search through the valid effects on the target.
    effect eAOE = GetFirstEffect(oTarget);
    if(GetHasSpellEffect(SPELL_MAGIC_CIRCLE_AGAINST_EVIL, oTarget))
    {
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                //If the effect was created by the AOE then remove it
                if(GetEffectSpellId(eAOE) == SPELL_MAGIC_CIRCLE_AGAINST_EVIL)
                {
                    //Protection is permanent, circle is temporay effect
                    if(GetEffectDurationType(eAOE) == DURATION_TYPE_PERMANENT)
                    {
                        RemoveEffect(oTarget, eAOE);
                    }
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
            DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        }
    }
}
