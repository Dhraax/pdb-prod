//::///////////////////////////////////////////////
//:: Project Q OnPlayerRest script
//:: q_playerrest.nss
//:: (c) copyright 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Culled from NwNE

    Put into: Module's OnPlayerRest Event

    This is a fully functional sample rest system that includes the
    following:

        - Resting advances game clock 8 hours

        - Spells and castable feats can only be regained once every
          24 hours

        - Wizards must have a spellbook to regain spells

        - Priests must have a holy symbol to regain spells

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: June 9/03
//:://////////////////////////////////////////////
//:: 08-15-2008, Deva Winblood: added horse system support

#include "x2_inc_switches"
#include "x2_inc_itemprop"
#include "x3_inc_horse"
#include "q_inc_restsystem"


void main()
{
    object oPC = GetLastPCRested();
    object oItem;
    int bDoNot = FALSE;
    //int bNoRegain = FALSE;
    int nFirstRest, nDay, nTimeHour, nRestDay, nRestHour;
    int nHour, nMinute, nSecond, nMillisecond;
    int nHeal, nCurrentHP, nDamTaken, nMaxHP, nIndex, nCharges;

    //--------------------------------------------------------------------------
    // XP2 Rest System (initialize wandering monsters)

    if (GetModuleSwitchValue(MODULE_SWITCH_USE_XP2_RESTSYSTEM))
    {
        //  Georg, August 11, 2003
        //  Added this code to allow the designer to specify a variable on the module
        //  Instead of using a OnAreaEnter script. Nice new toolset feature!
        //  Basically, the first time a player rests, the area is scanned for the
        //  encounter table string and will set it up.
        object oArea = GetArea(oPC);

        string sTable = GetLocalString(oArea, "X2_WM_ENCOUNTERTABLE");
        if (sTable != "")
        {
            // Initialize the encounter table.
            int nDoors = GetLocalInt(oArea, "X2_WM_AREA_USEDOORS");
            int nDC = GetLocalInt(oArea, "X2_WM_AREA_LISTENCHECK");
            WMSetAreaTable(oArea, sTable, nDoors, nDC);

            //remove string to indicate we are set up
            DeleteLocalString(oArea, "X2_WM_ENCOUNTERTABLE");
        }
    }

    //--------------------------------------------------------------------------
    // REST EVENTS -- START, CANCELLED, FINISHED

    switch ( GetLastRestEventType() )
    {
        case REST_EVENTTYPE_REST_STARTED:

            //------------------------------------------------------------------
            // Horse System (check if resting is permitted)

            // Dismount to rest?
            if ( !GetLocalInt(GetModule(),"X3_MOUNT_NO_REST_DISMOUNT") )
            { //* Bugfix - Pstemarie: added missing code block delimiters for this if statement
                if ( HorseGetIsMounted(oPC) )
                {
                    // Abort rest
                    FloatingTextStrRefOnCreature(112006, oPC, FALSE); // "You cannot rest while mounted!"
                    AssignCommand(oPC, ClearAllActions());
                    return;
                }
            } //* Bugfix

            //------------------------------------------------------------------
            // XP2 Rest System (wandering monsters)

            if ( GetModuleSwitchValue(MODULE_SWITCH_USE_XP2_RESTSYSTEM) )
            {
                if ( !WMStartPlayerRest(oPC) )
                {
                    // The resting system has objections against resting here and now.
                    // Probably because there is an ambush already in progress.
                    // Abort rest.
                    FloatingTextStrRefOnCreature(84142, oPC); // "You can not rest at this time."
                    AssignCommand(oPC, ClearAllActions());
                }
                if ( WMCheckForWanderingMonster(oPC) )
                {
                    //This script MUST be run or the player won't be able to rest again ...
                    ExecuteScript("x2_restsys_ambus", oPC);
                }
            }

            //------------------------------------------------------------------
            // Horse System (despawn paladin mounts?)

            if ( !GetLocalInt(GetModule(),"X3_MOUNT_NO_REST_DESPAWN") )
            {
                // Unsummon oPC's paladin mount.
                AssignCommand(oPC, HorseUnsummonPaladinMount());
                // Cycle through henchmen.
                int nHench = 1;
                object oHench = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oPC, 1);
                while ( oHench != OBJECT_INVALID )
                {
                    // Unsummon each henchman's paladin mount.
                    AssignCommand(oHench, HorseUnsummonPaladinMount());
                    oHench = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oPC, ++nHench);
                }
            }

            //------------------------------------------------------------------
            // Project Q Rest System (Wizards must have spellbook to regain spells,
            // priests myst have a divine focus)

            if (GetLevelByClass(CLASS_TYPE_WIZARD, oPC) > 0)
            {
                if (GetItemPossessedBy(oPC, "Q_IT_SPELLBOOK") == OBJECT_INVALID)
                {
                    // Store pre-rest values for all memorized spells
                    rs_StoreMemorizedSpellUsage(oPC);
                    FloatingTextStringOnCreature("You do not have a spellbook! You will not regain spells!", oPC, FALSE);
                    bDoNot = TRUE;
                }
            }
            else if (GetLevelByClass(CLASS_TYPE_CLERIC, oPC) > 0  ||
                     GetLevelByClass(CLASS_TYPE_DRUID, oPC) > 0   ||
                     GetLevelByClass(CLASS_TYPE_PALADIN, oPC) > 0 ||
                     GetLevelByClass(CLASS_TYPE_RANGER, oPC) > 0)
            {
                if (GetItemPossessedBy(oPC, "Q_IT_SYMBOL_001") == OBJECT_INVALID ||
                    GetItemPossessedBy(oPC, "Q_IT_SYMBOL_002") == OBJECT_INVALID )
                {
                    // Store pre-rest values for all memorized spells
                    rs_StoreMemorizedSpellUsage(oPC);
                    if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL)
                        FloatingTextStringOnCreature("You do not have an unholy symbol! You will not regain spells!", oPC, FALSE);
                    else
                        FloatingTextStringOnCreature("You do not have a holy symbol! You will not regain spells!", oPC, FALSE);
                    bDoNot = TRUE;
                }
            }

            //------------------------------------------------------------------
            // Project Q Rest System (feats and spells regained once every 24 hours)

            nFirstRest = GetLocalInt(oPC, "FIRST_REST");
            nDay = GetCalendarDay();
            nTimeHour = GetTimeHour();

            if (nFirstRest == 0) //First time resting in module
            {
                SetLocalInt(oPC, "FIRST_REST", 1);
                SetLocalInt(oPC, "REST_DAY", nDay);
                SetLocalInt(oPC, "REST_HOUR", nTimeHour);
            }
            else
            {
                nRestDay = GetLocalInt(oPC, "REST_DAY");
                nRestHour = GetLocalInt(oPC, "REST_HOUR");

                //* Bugfix for calendar change over
                if (nRestDay == 28 && nDay == 1)
                {
                    if (nRestHour <= nTimeHour)
                    {
                        SetLocalInt(oPC, "REST_DAY", nDay);
                        SetLocalInt(oPC, "REST_HOUR", nTimeHour);
                    }
                 }
                 else
                 {
                    if (nRestDay < nDay)
                    {
                        if (nRestHour <= nTimeHour)
                        {
                            SetLocalInt(oPC, "REST_DAY", nDay);
                            SetLocalInt(oPC, "REST_HOUR", nTimeHour);
                        }
                    }
                    else
                    {
                        //Store pre-rest values for all useable feats
                        rs_SavePCAvailableFeats(oPC);

                        //Store pre-rest values for all memorized spells
                        if (bDoNot == FALSE)
                        {
                            if (GetLevelByClass(CLASS_TYPE_BARD, oPC) > 0 ||
                                GetLevelByClass(CLASS_TYPE_CLERIC, oPC) > 0 ||
                                GetLevelByClass(CLASS_TYPE_DRUID, oPC) > 0 ||
                                GetLevelByClass(CLASS_TYPE_PALADIN, oPC) > 0 ||
                                GetLevelByClass(CLASS_TYPE_RANGER, oPC) > 0 ||
                                GetLevelByClass(CLASS_TYPE_SORCERER, oPC) > 0 ||
                                GetLevelByClass(CLASS_TYPE_WIZARD, oPC) > 0 )
                            {
                                rs_StoreMemorizedSpellUsage(oPC);
                            }
                        }
                        SendMessageToPC(oPC, "It is too soon after your last rest to regain feats or spells.");
                        SetLocalInt(oPC, "bNoRegain", TRUE);
                    }
                }
            }

        break;

        case REST_EVENTTYPE_REST_CANCELLED:

            //------------------------------------------------------------------
            // Project Q Rest System (index Game Clock d8 hours)

            nIndex = d8();
            rs_IndexGameClock(nIndex);

            //------------------------------------------------------------------
            // Project Q - Expendable Torches and Lanterns

            oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
            if (GetIsObjectValid(oItem))
            {
                if (GetTag(oItem) == "Q_IT_TORCH_001")
                {
                    SetItemCharges(oItem, 0);
                }
                else if (GetTag(oItem) == "Q_IT_LANTERN" || GetTag(oItem) == "q_it_lantern001")
                {
                    nIndex = nIndex * 20;
                    nCharges = GetItemCharges(oItem);
                    nCharges = nCharges - nIndex;
                    SetLocalInt(oItem, "NUMBER_CHARGES", nCharges);
                    IPRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_LIGHT, DURATION_TYPE_PERMANENT);
                }
                FloatingTextStringOnCreature("Your " +GetName(oItem)+ " flickers and dies!", oPC, FALSE);
            }

        break;

        case REST_EVENTTYPE_REST_FINISHED:

            //------------------------------------------------------------------
            // Project Q - Expendable Torches and Lanterns

            oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
            if (GetIsObjectValid(oItem))
            {
                if (GetTag(oItem) == "Q_IT_TORCH_001")
                {
                    SetItemCharges(oItem, 0);
                }
                else if (GetTag(oItem) == "Q_IT_LANTERN" || GetTag(oItem) == "q_it_lantern001")
                {
                    SetLocalInt(oItem, "NUMBER_CHARGES", 0);
                    IPRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_LIGHT, DURATION_TYPE_PERMANENT);
                }
                FloatingTextStringOnCreature("Your " +GetName(oItem)+ " flickers and dies!", oPC, FALSE);
            }

            //------------------------------------------------------------------
            // Project Q Rest System (Wizards must have spellbook to regain spells,
            // priests myst have a divine focus)

            if (GetLevelByClass(CLASS_TYPE_WIZARD, oPC) > 0)
            {
                if (GetItemPossessedBy(oPC, "Q_IT_SPELLBOOK") == OBJECT_INVALID)
                {
                    //Reset spells to their pre-rest values
                    rs_ResetMemorizedSpellUsage(oPC);
                    SendMessageToPC(oPC, "You did not regain any spells.");
                    bDoNot = TRUE;
                }
            }
            else if (GetLevelByClass(CLASS_TYPE_CLERIC, oPC) > 0  ||
                     GetLevelByClass(CLASS_TYPE_DRUID, oPC) > 0   ||
                     GetLevelByClass(CLASS_TYPE_PALADIN, oPC) > 0 ||
                     GetLevelByClass(CLASS_TYPE_RANGER, oPC) > 0)
            {
                if (GetItemPossessedBy(oPC, "Q_IT_SYMBOL_001") == OBJECT_INVALID ||
                    GetItemPossessedBy(oPC, "Q_IT_SYMBOL_002") == OBJECT_INVALID )
                {
                    //Reset spells to their pre-rest values
                    rs_ResetMemorizedSpellUsage(oPC);
                    SendMessageToPC(oPC, "You did not regain any spells.");
                    bDoNot = TRUE;
                }
            }

            //------------------------------------------------------------------
            // Project Q Rest System (feats and spells regained once every 24 hours)

            //Not enough time passed to regain feats and spells
            if (GetLocalInt(oPC, "bNoRegain") == TRUE)
            {
                //Reset feats to their pre-rest values
                rs_SetAvailableFeatsToSavedValues(oPC);

                //Reset spells to their pre-rest values
                if (bDoNot == FALSE)
                {
                    if (GetLevelByClass(CLASS_TYPE_BARD, oPC) > 0 ||
                        GetLevelByClass(CLASS_TYPE_CLERIC, oPC) > 0 ||
                        GetLevelByClass(CLASS_TYPE_DRUID, oPC) > 0 ||
                        GetLevelByClass(CLASS_TYPE_PALADIN, oPC) > 0 ||
                        GetLevelByClass(CLASS_TYPE_RANGER, oPC) > 0 ||
                        GetLevelByClass(CLASS_TYPE_SORCERER, oPC) > 0 ||
                        GetLevelByClass(CLASS_TYPE_WIZARD, oPC) > 0 )
                    {
                        rs_ResetMemorizedSpellUsage(oPC);
                    }
                }
                SendMessageToPC(oPC, "You did not regain any feats or spells.");
                DeleteLocalInt(oPC, "bNoRegain");
            }

            //Regain some HP (1 HP/level) - *Bugfix* but only if damaged
            nCurrentHP = GetCurrentHitPoints(oPC);
            nMaxHP = GetMaxHitPoints(oPC);
            if (nCurrentHP < nMaxHP)
            {
                // *Bugfix* if the HD of the PC is greater than the damage taken, limit the amount of HP regained to the amount of damage taken
                nDamTaken = nMaxHP - nCurrentHP;
                nHeal = GetHitDice(oPC);
                if (nHeal > nDamTaken) nHeal = nDamTaken;

                ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectHeal(nHeal), oPC);
                SendMessageToPC(oPC, "You regain " +IntToString(nHeal)+ " hit points.");
            }

            //------------------------------------------------------------------
            // Project Q Rest System (index Game Clock 8 hours)

            rs_IndexGameClock(8);

        break;

    } //switch
}
