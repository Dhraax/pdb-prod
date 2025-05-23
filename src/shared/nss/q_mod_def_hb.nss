#include "x2_inc_itemprop"
#include "q_inc_switches"

void RunTorchHeartbeat(object oPC)
{
    /*
        Torches and Lanterns
        Torches will burn for one hour before being destroyed. The time torches
        burn can be changed by increasing or decreasing the number of charges
        on the item. Assuming that the default time of 2 minutes = 1 hour, each
        block of 20 charges equates to 1 hour of duration.

        Lanterns will burn for six hours before needing to be refilled with lamp
        oil. The time lanterns burn can be changed by increasing or decreasing
        the value of the item's local variable "NUMBER_CHARGES".
    */

    object oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
    if (GetIsObjectValid(oItem))
    {
        if (GetTag(oItem) == "Q_IT_TORCH_001")
        {
            int nCharges = GetItemCharges(oItem);
            if (nCharges < 2)
            {
                FloatingTextStringOnCreature("Your torch flickers and dies!", oPC, FALSE);
            }
            else if (nCharges < 10)
            {
                //Warn the PC that their torch is close to expiring
                if (GetLocalInt(oItem, "SET_LIGHT_DIM") == 0)
                {
                    FloatingTextStringOnCreature("Your torch's light begins to fade!", oPC, FALSE);
                    IPSafeAddItemProperty(oItem, ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_DIM,
                        IP_CONST_LIGHTCOLOR_YELLOW), 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, TRUE);

                    SetLocalInt(oItem, "SET_LIGHT_DIM", 1);
                }
            }
            nCharges --;
            SetItemCharges(oItem, nCharges);
        }
        else if (GetTag(oItem) == "Q_IT_LANTERN" || GetTag(oItem) == "q_it_lantern001")
        {
            int nCharges = GetLocalInt(oItem, "NUMBER_CHARGES");

            if (nCharges == 0)
            {
                // do nothing - we know it's died
            }
            else
            {
                if (nCharges < 2)
                {
                    FloatingTextStringOnCreature("Your lantern flickers and dies!", oPC, FALSE);
                    IPRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_LIGHT, DURATION_TYPE_PERMANENT);
                }
                else if (nCharges < 10)
                {
                    //Warn the PC that their torch is close to expiring
                    if (GetLocalInt(oItem, "SET_LIGHT_LOW") == 0)
                    {
                        FloatingTextStringOnCreature("Your lantern's light begins to fade!", oPC, FALSE);
                        IPSafeAddItemProperty(oItem, ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_LOW,
                            IP_CONST_LIGHTCOLOR_WHITE), 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, TRUE);

                        SetLocalInt(oItem, "SET_LIGHT_LOW", 1);
                    }
                }
                nCharges --;
                SetLocalInt(oItem, "NUMBER_CHARGES", nCharges);
            }
        }
    }
}

void main()
{
    if (GetModuleSwitchValue(MODULE_SWITCH_HORSES_ENABLED) == TRUE)
    {
        ExecuteScript("x3_mod_def_hb", OBJECT_SELF);
    }

    if (GetModuleSwitchValue(MODULE_SWITCH_EXPENDABLE_TORCHES_ENABLED) == TRUE)
    {
        // Loop through PCs.
        object oPC = GetFirstPC();
        while ( oPC != OBJECT_INVALID )
        {
            // Project Q - Expendable Torches and Lanterns
            RunTorchHeartbeat( oPC);

            // Update loop.
            oPC = GetNextPC();
        }
    }
}
