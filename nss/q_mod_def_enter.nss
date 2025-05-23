#include "q_inc_switches"

void main()
{
    object oPC = GetEnteringObject();
    object oItem;
    int nCount, i;

    // -------------------------------------------------------------------------
    // Project Q - Weapon Swap Expolit Fix
    //--------------------------------------------------------------------------
    // Restore the BAB for players that logged off or were booted before their BAB was restored.
    if (GetModuleSwitchValue(MODULE_SWITCH_WEAPON_SWAP_EXPOIT_FIX) == TRUE)
    {
        RestoreBaseAttackBonus(oPC);
    }
    //--------------------------------------------------------------------------

    // -------------------------------------------------------------------------
    // Project Q - Phenotype Log Off Fix & ACP Functionality Support
    //
    // Do not remove or otherwise alter this block of code as the value of the variable stored
    // is used internally with the ACP chat script to determine which set of animations to use
    // based upon the PC's original phenotype.
    //--------------------------------------------------------------------------
    // Store the PC's base phenotype
    int nPheno = GetPhenoType(oPC);
    int bValid = FALSE;
    int nStorePheno;
    switch (nPheno)
    {
        case PHENOTYPE_BIG:
        case 5: // Large mounted
            bValid = TRUE;
            nStorePheno = 2;
        break;

        case PHENOTYPE_NORMAL:
        case 3: // Normal mounted
            bValid = TRUE;
            nStorePheno = 0;
        break;
    }
    if (bValid == FALSE)
    {
        SendMessageToPC(oPC, "Invalid phenotype found on character. Booting from server...");
        WriteTimestampedLogEntry("Player " +GetPCPlayerName(oPC)+ ", CD Key " +GetPCPublicCDKey(oPC, TRUE)+ ", kicked from server - invalid phenotype found on character.");
        DelayCommand(6.0, BootPC(oPC));
        return;

        // If the above seems too harsh, then comment out the code above and use the following code instead
        //nPheno = 0;
        //SetPhenoType(PHENOTYPE_NORMAL, oPC);
    }
    SetLocalInt(oPC, "Q_BASE_PHENOTYPE", nStorePheno);
    //--------------------------------------------------------------------------

    //--------------------------------------------------------------------------
    // Project Q Rest System

    if (GetModuleSwitchValue(MODULE_SWITCH_RESTSYSTEM_ENABLED) == TRUE)
    {
        int nGold = GetGold(oPC);
        string sItem;
        // Wizards get a spellbook
        if (GetLevelByClass(CLASS_TYPE_WIZARD, oPC) > 0)
        {
            if (GetItemPossessedBy(oPC, "Q_IT_SPELLBOOK") == OBJECT_INVALID)
            {
                CreateItemOnObject("q_it_spellbook", oPC);

                // take 15 gold or the PCs remaining gold
                if (nGold > 15) nGold = 15;
                TakeGoldFromCreature(nGold, oPC, TRUE);
            }
        }
        // Divine Casters get a holy symbol
        if (GetLevelByClass(CLASS_TYPE_CLERIC, oPC) > 0  ||
            GetLevelByClass(CLASS_TYPE_DRUID, oPC) > 0   ||
            GetLevelByClass(CLASS_TYPE_PALADIN, oPC) > 0 ||
            GetLevelByClass(CLASS_TYPE_RANGER, oPC) > 0)
        {
            if (GetItemPossessedBy(oPC, "Q_IT_SYMBOL_001") == OBJECT_INVALID ||
                GetItemPossessedBy(oPC, "Q_IT_SYMBOL_002") == OBJECT_INVALID )
            {
                if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL)
                    sItem = "q_it_symbol_002";
                else
                    sItem = "q_it_symbol_001";

                CreateItemOnObject(sItem, oPC);
                // take 15 gold or the PCs remaining gold
                if (nGold > 15) nGold = 15;
                TakeGoldFromCreature(nGold, oPC, TRUE);
            }
        }

        // If Expendable Torches and Lanterns is enabled, replace OC torches
        if (GetModuleSwitchValue(MODULE_SWITCH_EXPENDABLE_TORCHES_ENABLED) == TRUE)
        {
            // Cycle through PC's inventory and destroy OC torches
            oItem = GetFirstItemInInventory(oPC);
            int nCount = 0;
            while (GetIsObjectValid(oItem))
            {
                if (GetTag(oItem) == "NW_IT_TORCH001")
                {
                    DestroyObject(oItem);
                    nCount ++;
                }
                oItem = GetNextItemInInventory(oPC);
            }

            // Check left hand slot
            oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
            if (GetIsObjectValid(oItem))
            {
                if (GetTag(oItem) == "NW_IT_TORCH001")
                {
                    DestroyObject(oItem);
                    nCount ++;
                }
            }

            // *Bugfix* - Using a for loop here because CreateItemOnObject was creating an
            // infinite number of torches when used in the while loop above
            for (i = 0; i < nCount; i++)
            {
                CreateItemOnObject("q_it_torch_001", oPC);
            }
        }
    }

    //--------------------------------------------------------------------------
    // Project Q Bleed System

    if (GetModuleSwitchValue(MODULE_SWITCH_BLEEDSYSTEM_ENABLED) == TRUE)
    {
        oItem = GetFirstItemInInventory(oPC);
        nCount = 0;
        while (GetIsObjectValid(oItem))
        {
            if (GetTag(oItem) == "NW_IT_MEDKIT001" || GetTag(oItem) == "NW_IT_MEDKIT002" || GetTag(oItem) == "NW_IT_MEDKIT003" || GetTag(oItem) == "NW_IT_MEDKIT004")
            {
                DestroyObject(oItem);
                nCount ++;
            }
            oItem = GetNextItemInInventory(oPC);
        }

        for (i = 0; i < nCount; i++)
        {
            CreateItemOnObject("q_it_healerskit", oPC);
        }
    }

    //--------------------------------------------------------------------------
    // Check for XP3 Portable Camp
    oItem = GetFirstItemInInventory(oPC);
    nCount = 0;
    while (GetIsObjectValid(oItem))
    {
        if (GetTag(oItem) == "x3_it_camp")
        {
            DestroyObject(oItem);
            nCount ++;
        }
        oItem = GetNextItemInInventory(oPC);
    }

    for (i = 0; i < nCount; i++)
    {
        CreateItemOnObject("q_it_camp", oPC);
    }
    //--------------------------------------------------------------------------

    if (GetModuleSwitchValue(MODULE_SWITCH_HORSES_ENABLED) == TRUE)
    {
        ExecuteScript("x3_mod_def_enter", OBJECT_SELF); // if using a custom OnClientEnter script, change this line to point to that script
    }
    else
    {
        ExecuteScript("q_custom_oce", OBJECT_SELF); // if using a custom OnClientEnter script, change this line to point to that script
    }
}
