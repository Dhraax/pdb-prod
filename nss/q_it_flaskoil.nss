// Flask of Oil Tag Based Item Script
//:://////////////////////////////////////////////

#include "x0_i0_spells"
#include "x2_inc_itemprop"

void main()
{
    int nEvent = GetUserDefinedItemEventNumber();
    object oPC, oItem, oTarget;

    if (nEvent == X2_ITEM_EVENT_ACTIVATE)
    {
        oPC = GetItemActivator();
        oItem = GetItemActivated();
        oTarget = GetItemActivatedTarget();

	int nType = GetObjectType(oTarget);
        if (nType == OBJECT_TYPE_ITEM)
        {
            if (GetTag(oTarget) == "X4_IT_LANTERN")
            {
                IPSafeAddItemProperty(oTarget, ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_BRIGHT,
                    IP_CONST_LIGHTCOLOR_GREEN), 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, TRUE);
                SetLocalInt(oTarget, "NUMBER_CHARGES", 120);
                FloatingTextStringOnCreature("You have refueled your hooded lantern.", oPC, FALSE);
            }
            else
            {
                FloatingTextStringOnCreature("You cannot use your lamp oil on that item!", oPC, FALSE);
            }
        }
        else if (nType == OBJECT_TYPE_CREATURE || nType == OBJECT_TYPE_DOOR || nType == OBJECT_TYPE_PLACEABLE)
        {
            //SetCommandable(TRUE, oPC);
            AssignCommand(oPC, ActionCastFakeSpellAtObject(SPELL_GRENADE_FIRE, oTarget));
            if (d100() < 50)
            {
                DoGrenade(d6(1),1, VFX_IMP_FLAME_M, VFX_FNF_FIREBALL, DAMAGE_TYPE_FIRE, RADIUS_SIZE_HUGE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
            }
	    // This can't be a good thing to do.
            //DelayCommand(1.0, SetCommandable(FALSE, oPC));
        }
    }
}
