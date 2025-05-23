//::///////////////////////////////////////////////
//:: Example XP2 OnItemEquipped
//:: x2_mod_def_unequ
//:: (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Put into: OnUnEquip Event
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-16
//:://////////////////////////////////////////////
//:: Modified By: Deva Winblood
//:: Modified On: April 15th, 2008
//:: Added Support for Mounted Archery Feat penalties
//:://////////////////////////////////////////////
/*
    Updated 7/2/12 by pstemarie Q v1.5  - added a work around for the demonblade robe issue, if using demonblade style and oPC
                                          unequips their secondary weapon the phenotype will revert to the "normal" phenotype

    Updated 8/29/15 by pstemarie Q v2.1 - added a fix for the weapon swap exploit, disabled by default. Enable in q_mod_def_load.nss
*/

#include "q_inc_switches"
#include "x2_inc_intweapon"
#include "x3_inc_horse"
#include "q_inc_acp"
#include "q_inc_curseprops"

void main()
{
     object oItem = GetPCItemLastUnequipped();
     object oPC   = GetPCItemLastUnequippedBy();

    // -------------------------------------------------------------------------
    // Project Q - Weapon Swap Expolit Fix
    // -------------------------------------------------------------------------
    if (GetModuleSwitchValue(MODULE_SWITCH_WEAPON_SWAP_EXPOIT_FIX) == TRUE)
    {
        if (GetIsInCombat(oPC) && (IPGetIsMeleeWeapon(oItem) || IPGetIsRangedWeapon(oItem)))
        {
            FloatingTextStringOnCreature("No weapon swap exploit for you!", oPC, FALSE);
            SetBaseAttackBonus(1, oPC);
            DelayCommand(6.0, RestoreBaseAttackBonus(oPC));
        }
    }

    // -------------------------------------------------------------------------
    //  Intelligent Weapon System
    // -------------------------------------------------------------------------
    if (IPGetIsIntelligentWeapon(oItem))
    {
            IWSetIntelligentWeaponEquipped(oPC,OBJECT_INVALID);
            IWPlayRandomUnequipComment(oPC,oItem);
    }

    // -------------------------------------------------------------------------
    // Mounted benefits control
    // -------------------------------------------------------------------------
    if (GetWeaponRanged(oItem))
    {
        DeleteLocalInt(oPC,"bX3_M_ARCHERY");
        HORSE_SupportAdjustMountedArcheryPenalty(oPC);
    }

    // -------------------------------------------------------------------------
    // Generic Item Script Execution Code
    // If MODULE_SWITCH_EXECUTE_TAGBASED_SCRIPTS is set to TRUE on the module,
    // it will execute a script that has the same name as the item's tag
    // inside this script you can manage scripts for all events by checking against
    // GetUserDefinedItemEventNumber(). See x2_it_example.nss
    // -------------------------------------------------------------------------
    if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS) == TRUE)
    {
        SetUserDefinedItemEventNumber(X2_ITEM_EVENT_UNEQUIP);
        int nRet =   ExecuteScriptAndReturnInt(GetUserDefinedItemEventScriptName(oItem),OBJECT_SELF);
        if (nRet == X2_EXECUTE_SCRIPT_END)
        {
           return;
        }
    }

//------------------------------------------------------------------------------
//                           PROJECT Q CUSTOMIZATIONS
//------------------------------------------------------------------------------

    if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_DLA_DYNAMIC_QUIVERS) == TRUE)
    {
        int nBaseItemType = GetBaseItemType(oItem);
        int nNeckPartId = GetLocalInt(oPC, "Q_NECK_PART_ID");

        if (nBaseItemType == BASE_ITEM_ARROW ||
            nBaseItemType == BASE_ITEM_BOLT)
        {
            if (GetCreatureBodyPart(CREATURE_PART_NECK, oPC) == 7)
            {
                //Delete the stored neck value
                DeleteLocalInt(oPC, "Q_NECK_PART_ID");

                SetCreatureBodyPart(CREATURE_PART_NECK, nNeckPartId, oPC);
            }
        }
        else if ((nBaseItemType == BASE_ITEM_HEAVYCROSSBOW ||
                  nBaseItemType == BASE_ITEM_LIGHTCROSSBOW ||
                  nBaseItemType == BASE_ITEM_LONGBOW ||
                  nBaseItemType == BASE_ITEM_SHORTBOW)
                 &&
                 (GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC) == OBJECT_INVALID &&
                  GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC) == OBJECT_INVALID))
        {
            if (GetCreatureBodyPart(CREATURE_PART_NECK, oPC) == 7)
            {
                //Delete the stored neck value
                DeleteLocalInt(oPC, "Q_NECK_PART_ID");

                SetCreatureBodyPart(CREATURE_PART_NECK, nNeckPartId, oPC);
            }
        }
    }
    //hack for demonblade robe issue
    if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_REQUIRE_DEMONBLADE_MULTIWEAPON) == TRUE)
    {
        if (GetPhenoType(oPC) == 20)
        {
            if (GetCreatureFlag(oPC, CREATURE_FLAG_DEMONBLADE_MULTIWEAPON_OVERRIDE) == FALSE)
            {
                if (GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) != OBJECT_INVALID)
                {
                    int nBaseItemType = GetBaseItemType(oItem);
                    if (nBaseItemType == BASE_ITEM_BASTARDSWORD ||
                        nBaseItemType == BASE_ITEM_BATTLEAXE ||
                        nBaseItemType == BASE_ITEM_CLUB ||
                        nBaseItemType == BASE_ITEM_DAGGER ||
                        nBaseItemType == BASE_ITEM_DART ||
                        nBaseItemType == BASE_ITEM_DWARVENWARAXE ||
                        nBaseItemType == BASE_ITEM_HANDAXE ||
                        nBaseItemType == BASE_ITEM_HEAVYFLAIL ||
                        nBaseItemType == BASE_ITEM_KAMA ||
                        nBaseItemType == BASE_ITEM_KATANA ||
                        nBaseItemType == BASE_ITEM_KUKRI ||
                        nBaseItemType == BASE_ITEM_LIGHTFLAIL ||
                        nBaseItemType == BASE_ITEM_LIGHTHAMMER ||
                        nBaseItemType == BASE_ITEM_LIGHTMACE ||
                        nBaseItemType == BASE_ITEM_LONGSWORD ||
                        nBaseItemType == BASE_ITEM_MORNINGSTAR ||
                        nBaseItemType == BASE_ITEM_RAPIER ||
                        nBaseItemType == BASE_ITEM_SCIMITAR ||
                        nBaseItemType == BASE_ITEM_SHORTSWORD ||
                        nBaseItemType == BASE_ITEM_SICKLE ||
                        nBaseItemType == BASE_ITEM_THROWINGAXE ||
                        nBaseItemType == BASE_ITEM_WARHAMMER ||
                        nBaseItemType == BASE_ITEM_WHIP ||
                        nBaseItemType == BASE_ITEM_TORCH)
                    {
                        SendMessageToPC(oPC, "Secondary weapon unequipped, reverting to normal style...");
                        Q_ACPCheckChat(oPC, "style normal");
                    }
                }
            }
        }
    }

    //--------------------------------------------------------------------------
    // Cursed Items
    //--------------------------------------------------------------------------
    if (GetModuleSwitchValue(MODULE_SWITCH_CURSED_ITEMS_ENABLED) == TRUE)
    {
        if (GetItemCursedFlag(oItem) == TRUE)
        {
            int nSlot = ci_GetInventorySlotFromItem(oItem);

            //Checks if a ring was unequipped from the right or left hand
            if (nSlot == INVENTORY_SLOT_RIGHTRING)
            {
                if (GetIsObjectValid(GetItemInSlot(nSlot, oPC)))
                    nSlot = INVENTORY_SLOT_LEFTRING;
            }

            //Checks if a melee weapon was unequipped from the right or left hand
            else if (nSlot == INVENTORY_SLOT_RIGHTHAND)
            {
                if (GetIsObjectValid(GetItemInSlot(nSlot, oPC)))
                    nSlot = INVENTORY_SLOT_LEFTHAND;
            }
            AssignCommand(oPC, ClearAllActions());
            AssignCommand(oPC, ActionEquipItem(oItem, nSlot));
            FloatingTextStringOnCreature("You cannot unequip cursed items!", oPC, FALSE);
        } else if (GetLocalInt(oItem, "IS_CURSED") == 1 || GetStringRight(GetTag(oItem), 7) == "_CURSED") {
		//DeleteLocalInt(oItem, "EFFECT_FIRED");
	}
    }
}
