//::///////////////////////////////////////////////
//:: Project Q v2.2 OnModuleLoad event script
//:: q_mod_def_load.nss
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Pstemarie
//:: Created On: August 2015
//:://////////////////////////////////////////////

#include "q_inc_switches"
#include "q_inc_traps"

void main()
{
    // * Trapporium - Enabling this switch flags the module as using the Project Q
    // * edition of Firehazurd's Trapporium. This switch is disabled by default.
    //SetModuleSwitch(MODULE_SWITCH_TRAPPORIUM_ENABLED, TRUE);

    if (GetModuleSwitchValue(MODULE_SWITCH_TRAPPORIUM_ENABLED) == TRUE)
    {
        LoadTrapporium();
    }

    if (GetGameDifficulty() ==  GAME_DIFFICULTY_CORE_RULES || GetGameDifficulty() ==  GAME_DIFFICULTY_DIFFICULT)
    {
        // * Creatures: enable this switch to make trolls impossible to kill unless
        // * damaged by fire or acid. This switch is disabled by default.
        //SetModuleSwitch (MODULE_SWITCH_HARDCORE_TROLLS, TRUE);
    }

    // * Module Events: If this switch is enabled, whenever a character equips arrows or bolts, a quiver
    // * will appear on the character's back.
    // *
    // * Note: This switch is disabled by default.
    SetModuleSwitch(MODULE_SWITCH_ENABLE_DLA_DYNAMIC_QUIVERS, TRUE);

    // * Module Events: If this switch is enabled, characters will not be able to craft heraldic robes
    // * when using the craft skills dialog.
    // *
    // * Note: This switch is disabled by default.
    //SetModuleSwitch(MODULE_SWITCH_ENABLE_LOCK_HERALDIC_ROBE_CRAFTING, TRUE);

    // * Module Events: If this switch is enabled, characters will not be able to use the Demonblade fighting
    // * style unless they have two melee weapons equipped.
    // *
    // * Note: This switch is enabled by default.
    SetModuleSwitch(MODULE_SWITCH_ENABLE_REQUIRE_DEMONBLADE_MULTIWEAPON, TRUE);

    // * Module Events: If this switch is enabled, characters will not be able to use the Hung, Muay, Shao,
    // * or Shoto fighting styles unless they have levels in the monk class.
    // *
    // * Note: This switch is disabled by default.
    SetModuleSwitch(MODULE_SWITCH_ENABLE_UNARMED_STYLES_LIMITATION, TRUE);

    // * Mil's Tailor - Enable this switch if using Mil's Tailor in your module. Enabling this switch will
    // * allow Body Tailor models to switch freely between Body Tailor and Clothes Tailor routines as
    // * necessary.
    // *
    // * Note: This switch has two possible settings...
    // *       0 = Disabled (the default setting)
    // *       1 = Enabled
    // *       2 = Enabled  (disable craft skills menu options for altering armor, weapons, and shields)
    // *
    // * This switch is disabled by default. To enable, uncomment the line with the correct option
    //SetModuleSwitch(MODULE_SWITCH_MILS_TAILOR_ENABLED, TRUE);
    SetModuleSwitch(MODULE_SWITCH_MILS_TAILOR_ENABLED, 2);

    if (GetModuleSwitchValue(MODULE_SWITCH_MILS_TAILOR_ENABLED) == 2)
    {
        SetModuleSwitch(MODULE_SWITCH_DISABLE_CRAFT_SKILLS_MENU, TRUE);
    }

    // * Combat - There is a bug in the combat engine that allows a character to
    // * gain extra attacks by repeatedly swapping weapons during combat. Enabling
    // * this switch will reduce the character's number of attacks to one for one
    // * round whenever they equip or unequip a weapon, neutralizing the exploit.
    // * This switch is disabled by default.
    SetModuleSwitch(MODULE_SWITCH_WEAPON_SWAP_EXPOIT_FIX, TRUE);

    // * Henchmen: Enable to switch to make henchmen level up automatically when the PC advances a
    // * level. This switch is enabled by default.
    // *
    // * Note: This switch requires that the module's OnPlayerLevelUp Event script be set to the
    // * XP4 default - q_mod_def_oplu.nss.
    SetModuleSwitch (MODULE_SWITCH_AUTO_LEVEL_HENCHMEN, TRUE);

    // * Henchmen: Enable this switch to setup a campaign database for transfering henchmen to another
    // * module in a campaign.
    //SetLocalString(GetModule(), "X0_CAMPAIGN_DB", "Q_HENCHMEN_DB");

    // * Henchmen: Enable this switch to turn off the automatic leveling of henchmen to match the PC's level
    // * when they are hired or rejoin the PC.
    //SetModuleSwitch (MODULE_SWITCH_NO_LEVELUP_ON_HENCHMAN_HIRE, TRUE);

    // * Multiple Henchmen: 
    // *
    // * The module variable Q_MAXIMUM_HENCHMEN (set to an integer value of 2 or higher) equals the
    // * maximum number of henchmen that a player may have at one time.
    // * You probably want to set this if using horses.  
    // *
    // SetLocalInt(GetModule(), "Q_MAXIMUM_HENCHMEN", 4); 
    int nMaxHenchmen = GetLocalInt(GetModule(), "Q_MAXIMUM_HENCHMEN");
    if (nMaxHenchmen > 1)
    {
        SetMaxHenchmen(nMaxHenchmen);
    }

    //------------------------------------------------------------------------------
    // * Rulesets: enable this switch to flag the module as using the Project Q
    // * Rest System - for more information see q_playerrest.nss. This switch is
    // * disabled by default.
    //SetModuleSwitch(MODULE_SWITCH_RESTSYSTEM_ENABLED, TRUE);

    if (GetModuleSwitchValue(MODULE_SWITCH_RESTSYSTEM_ENABLED) == TRUE)
    {
        // * Items: Enable this switch to turn on expendable torches and lanterns. Torches
        // * and lanterns will now burn for a limited duration. Lanterns can be "recharged"
        // * using lamp oil.
        // *
        // * NOTE: If using this system, the Project Q Rest System MUST be enabled and you
        // * MUST use q_mod_def_rest.nss as your module's OnPlayerRest event.
        SetModuleSwitch(MODULE_SWITCH_EXPENDABLE_TORCHES_ENABLED, TRUE);
    }

    //------------------------------------------------------------------------------
    // * Rulesets: enable this switch to flag the module as using the Project Q Bleed
    // * System - for more information see q_playerdying.nss. This switch is disabled by
    // * default.
    //SetModuleSwitch(MODULE_SWITCH_BLEEDSYSTEM_ENABLED, TRUE);

    // * Rulesets: Enable this switch to turn on the Project Q Cursed Items System. This
    // * system allows for the creation of dynamic cursed items (items whose true nature
    // * doesn't reveal itself until equipped). Once equipped, cursed items cannot be
    // * unequipped, dropped, or sold. This switch is disabled by default.
    // * remove curse spell extension requires q_spellhook below.
    //SetModuleSwitch(MODULE_SWITCH_CURSED_ITEMS_ENABLED, TRUE);

    // * Experience: enable this switch to use ScrewTape's Simple XP - an alternative
    // * system for awarding XP, allowing the Builder more control than the BioWare
    // * system. This switch is disabled by default.
    // *
    // * NOTE: The module's XP scale slider must be set to "0" if this system is enabled.
    //SetModuleSwitch(MODULE_SWITCH_SIMPLE_XP_ENABLED, TRUE);

    // * Horses - Enabling this switch flags the module as allowing horses and
    // * directs Project Q's default OnModuleLoad event to fire the correct hook
    // * script. If this switch is not enabled then the OnModuleLoad event will use
    // * x2_mod_def_load as the default hook script. This switch is disabled by default.
    //SetModuleSwitch(MODULE_SWITCH_HORSES_ENABLED, TRUE);
   
    // Spells
    // * Spell hook definition. Enable this to use the Q spellhook script. Required for 
    // * spell enhancements and components. If you have your own merged spell hook script 
    // * you can put its name here.
    SetLocalString(GetModule(), MODULE_VAR_OVERRIDE_SPELLSCRIPT, "q_spellhook");

    // * Spells: enable this switch to use the Q simple spell component system 
    // * requires q_spellhook. This switch is disabled by default.
    //SetModuleSwitch(MODULE_SWITCH_SPELL_COMPONENTS_ENABLED, TRUE);

    // * Spells: Enable this switch to change the way that the Identify and Legend
    // * Lore spells work. When enabled, Identify will identify a targeted item and
    // * Legend Lore will identify ALL items in the caster's inventory. This switch
    // * is disabled by default.
    // * requires q_spellhook
    //SetModuleSwitch(MODULE_SWITCH_PNP_IDENTIFY, TRUE);

    // * Spells: Enabling this switch changes the way Bane and Bless function -
    // * Bane and Bless can be used to dispel each other's effects OR cast with
    // * their normal effects. Additionally, Bane cannot be used to target bolts.
    // * This switch is disabled by default.
    // * requires q_spellhook
    //SetModuleSwitch(MODULE_SWITCH_PNP_BANE_BLESS, TRUE);

//------------------------------------------------------------------------------
// DO NOT EDIT ANYTHING BENEATH THIS LINE
//------------------------------------------------------------------------------

    // * BUGFIX - If ScrewTapes's Simple XP is enabled, check the module's XP
    // * scale and, if necessary, set it to "0"
    if (GetModuleSwitchValue(MODULE_SWITCH_SIMPLE_XP_ENABLED) == TRUE && GetModuleXPScale() > 0)
    {
        SetModuleXPScale(0);
    }

    // * If flagged as using Horses (see above switch), fire x3_mod_def_load,
    // * else fire x2_mod_def_load.
    if (GetModuleSwitchValue(MODULE_SWITCH_HORSES_ENABLED) == TRUE)
    {
        ExecuteScript("x3_mod_def_load", OBJECT_SELF);
    }
    else
    {
        ExecuteScript("x2_mod_def_load", OBJECT_SELF);
    }
}
