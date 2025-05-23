//::///////////////////////////////////////////////
//:: OnHit Cast Spell: Rust Metal (Rust Monster)
//:: q_s3_RustMetal.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Cycles through target's inventory - starting with armor, shields, and
    weapons - destroying the first metal item hit.

    Leeched from X2_S3_RuinArmor.nss by Georg Zoeller
*/
//:://////////////////////////////////////////////
//:: Created By: Pstemarie
//:: Created On: 1/30/10
//:://////////////////////////////////////////////

#include "x0_i0_spells"
#include "x2_inc_switches"
#include "q_inc_rustmnstr"

void main()
{
    object oTarget = GetSpellTargetObject();
    object oItem = GetSpellCastItem();
    object oTargetItem, oDestroy;
    int nType, nSlot;
    int bFound = FALSE;

    if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_BEBILITH_RUIN_ARMOR))
    {
        if (GetIsObjectValid(oItem))
        {
            // Gauntlets of Rust - touch attack
            if (GetTag(oItem) == "Q_IT_MBRACER001")
            {
                if (TouchAttackMelee(oTarget,oItem == OBJECT_INVALID) == 0) //first touch, then ask
                {
                    return;
                }
            }

            // Search through inventory for potential targets
            oTargetItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);

            // Start with armor
            if (GetIsObjectValid(oTargetItem) && rm_GetIsItemMetal(oTargetItem) > 0)
            {
                oDestroy = oTargetItem;
                bFound = TRUE;
            }
            // else Shield
            else if (bFound == FALSE)
            {
                oTargetItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
                if (GetIsObjectValid(oTargetItem) && rm_GetIsItemMetal(oTargetItem) > 0)
                {
                    nType = GetBaseItemType(oTargetItem);
                    if (nType == BASE_ITEM_LARGESHIELD || nType == BASE_ITEM_SMALLSHIELD || nType == BASE_ITEM_TOWERSHIELD)
                    {
                        oDestroy = oTargetItem;
                        bFound = TRUE;
                    }
                }
            }
            // else Primary Weapon
            else if (bFound == FALSE)
            {
                oTargetItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
                if (GetIsObjectValid(oTargetItem) && rm_GetIsItemMetal(oTargetItem) > 0)
                {
                    oDestroy = oTargetItem;
                    bFound = TRUE;
                }
            }
            // else Secondary Weapon
            else if (bFound == FALSE)
            {
                oTargetItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
                if (GetIsObjectValid(oTargetItem) && rm_GetIsItemMetal(oTargetItem) > 0)
                {
                    oDestroy = oTargetItem;
                    bFound = TRUE;
                }
            }
            // else Remaining Inventory
            else if (bFound == FALSE)
            {
                while (bFound == FALSE)
                {
                    for (nSlot=0; nSlot<NUM_INVENTORY_SLOTS; nSlot++)
                    {
                        oTargetItem = GetItemInSlot(nSlot, oTarget);

                        if (GetIsObjectValid(oTargetItem) && rm_GetIsItemMetal(oTargetItem) > 0)
                        {
                            oDestroy = oTargetItem;
                            bFound = TRUE;
                        }
                    }
                }
            }

            if (GetIsObjectValid(oDestroy) && GetPlotFlag(oDestroy) == FALSE)
            {
                //Set the save DC and adjust if oDestroy is a magic item
                int nDC = 17;
                if (Q_IPGetIsMagicItem(oDestroy))
                {
                    int nMod = 2 + Q_IPGetItemLevel(oItem)/2;
                    nDC = nDC - nMod;
                }

                //Make a Reflex Save check
                if (!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_NONE))
                {
                    string sName = GetName(oDestroy);
                    DestroyObject(oDestroy);
                    FloatingTextStringOnCreature("Your " +sName+ " is destroyed!", oTarget,FALSE);
                }
                else
                {
                    /*debug*/
                    FloatingTextStringOnCreature("Reflex save made!", oTarget,FALSE);
                }
            }
        }
    }
}
