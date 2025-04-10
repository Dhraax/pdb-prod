//------------------------------------------------------------------------------
//   q_inc_switches::   Interface for switching subsystem functionality
//------------------------------------------------------------------------------
/*
    Added functionality for Project Q propriety subsystems.

    Note this library includes x2_inc_switches.
*/
//------------------------------------------------------------------------------
// Created By: Pstemarie
// Created On: 3 April 2011
//------------------------------------------------------------------------------
/*

    Updated 5/19/13 by pstemarie Q v1.7  - added a module switch that enables Builders to limit the unarmed styles to monks. Default is OFF.
    Updated 8/20/15 by pstemarie Q v2.1  - added a module switch to disbale the crafting of armor, weapons, and shields via the Craft Ckills Menu
                                           if Mil's Tailor is enabled. Default is OFF.
                                         - added a module switch that allows the Builder to flag the module as using Mil's Tailor. If not enabled,
                                           Body Tailor models will not be able to switch between body and clothes tailoring routines.
    Updated 11/23/15 by pstemarie Q v2.1 - added the NwnE Creature AI Override switches
*/


#include "x2_inc_switches"

//------------------------------------------------------------------------------
//                         M O D U L E  SWITCHES
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// * Force Use DLA Dynamic Quivers, Default = FALSE
// * If switched to TRUE, whenever a character equips arrows or bolts, a quiver
// * appears on the character's back.
//------------------------------------------------------------------------------
const string MODULE_SWITCH_ENABLE_DLA_DYNAMIC_QUIVERS = "Q_SWITCH_ENABLE_DLA_DYNAMIC_QUIVERS";

//------------------------------------------------------------------------------
// * Item Crafting - Lock Out Heraldic Robes, Default = FALSE
// * If switched to TRUE, a character will not be able to add a heraldic robe
// * when using the craft skills dialog.
//------------------------------------------------------------------------------
const string MODULE_SWITCH_ENABLE_LOCK_HERALDIC_ROBE_CRAFTING = "Q_SWITCH_ENABLE_LOCK_HERALDIC_ROBE_CRAFTING";

//------------------------------------------------------------------------------
// * Animations - Require two equipped weapons to use ACP Demonblade Style
// * If switched to TRUE, a character will not be able to use the demonblade
// * fighting style unless they have two melee weapons equipped. This switch is
// * enabled by default.
// *
// * This switch is included as a work-around for the known animation issue
// * when robes are equipped on a model using the ACP Demonblade phenotype.
// * When in melee combat and the secondary weapon is unequipped, the robe
// * appears to "swallow" the head. The animation remains "broken" until the
// * model is reset to the Normal phenotype.
// *
// * A variable has been included so that Builders can override the behavior
// * for individual creatures by setting the local variable
// * Q_FLAG_DEMONBLADE_MULTIWEAPON_OVERRIDE to TRUE (or "1") on the creature.
//------------------------------------------------------------------------------
const string MODULE_SWITCH_ENABLE_REQUIRE_DEMONBLADE_MULTIWEAPON = "Q_SWITCH_ENABLE_REQUIRE_DEMONBLADE_MULTIWEAPON";
const string CREATURE_FLAG_DEMONBLADE_MULTIWEAPON_OVERRIDE = "Q_FLAG_DEMONBLADE_MULTIWEAPON_OVERRIDE";

//------------------------------------------------------------------------------
// * Animations - Enabling this switch will only make the Hung, Muay, Shao, and
// * Shoto ACP Fighting Styles available to characters that have one or more
// * levels in the Monk class. This switch is disabled by default.
//------------------------------------------------------------------------------
const string MODULE_SWITCH_ENABLE_UNARMED_STYLES_LIMITATION = "Q_SWITCH_ENABLE_UNARMED_STYLES_LIMITATION";

//------------------------------------------------------------------------------
// * Mil's Tailor - Enable this switch if using Mil's Tailor in your module.
// * Enabling this switch will allow Body Tailor models to switch freely between
// * Body Tailor and Clothes Tailor routines as necessary. This switch is
// * disabled by default.
const string MODULE_SWITCH_MILS_TAILOR_ENABLED = "Q_SWITCH_MILS_TAILOR_ENABLED";

//------------------------------------------------------------------------------
// * Crafting - Enable this switch to remove the menu options for altering
// * armor, weapons, and shields from the Craft Skils Menu when using Mil's
// * Tailor
//------------------------------------------------------------------------------
const string MODULE_SWITCH_DISABLE_CRAFT_SKILLS_MENU = "Q_SWITCH_DISABLE_CRAFT_SKILLS_MENU";

//------------------------------------------------------------------------------
// * Horses - Enabling this switch flags the module as allowing horses and
// * directs Project Q's default OnModuleLoad event to fire the correct hook
// * script. If this switch is not enabled then the OnModuleLoad event will use
// * x2_mod_def_load as the default hook script.
// * This switch is disabled by default.
//------------------------------------------------------------------------------
const string MODULE_SWITCH_HORSES_ENABLED = "Q_SWITCH_HORSES_ENABLED";

//------------------------------------------------------------------------------
// * Trapporium - Enabling this switch flags the module as using the Project Q
// * edition of Firehazurd's Trapporium. This switch is disabled by default.
//------------------------------------------------------------------------------
const string MODULE_SWITCH_TRAPPORIUM_ENABLED = "Q_SWITCH_TRAPPORIUM_ENABLED";

//------------------------------------------------------------------------------
// * Combat - There is a bug in the combat engine that allows a character to
// * gain extra attacks by repeatedly swapping weapons during combat. Enabling
// * this switch will reduce the character's number of attacks to one for one
// * round whenever they equip or unequip a weapon, neutralizing the exploit.
// * This switch is disabled by default.
const string MODULE_SWITCH_WEAPON_SWAP_EXPOIT_FIX = "Q_SWITCH_WEAPON_SWAP_EXPOIT_FIX";

//------------------------------------------------------------------------------
// * Henchmen: Enable to switch to make henchmen level up automatically when the
// * PC advances a level. This switch is enabled by default.
// *
// * Note: This switch requires that the module's OnPlayerLevelUp Event script
// * be set to the default Project Q script - q_mod_def_oplu.nss.
const string MODULE_SWITCH_AUTO_LEVEL_HENCHMEN = "Q_AUTO_LEVEL_HENCHMEN";

//------------------------------------------------------------------------------
// * Henchmen: Enable this switch to turn off the automatic leveling of henchmen
// * to match the PC's level when they are hired or rejoin the PC.
const string MODULE_SWITCH_NO_LEVELUP_ON_HENCHMAN_HIRE = "Q_NO_LEVELUP_ON_HENCHMAN_HIRE";

//------------------------------------------------------------------------------
// * Rulesets: enable this switch to flag the module as using the Project Q
// * Rest System - for more information see q_playerrest.nss. This switch is
// * disabled by default.
const string MODULE_SWITCH_RESTSYSTEM_ENABLED = "Q_SWITCH_RESTSYSTEM_ENABLED";

//------------------------------------------------------------------------------
// * Rulesets: enable this switch to flag the module as using the Project Q
// * Bleed System - for more information see q_playerdying.nss. This switch is
// * disabled by default.
const string MODULE_SWITCH_BLEEDSYSTEM_ENABLED = "Q_SWITCH_RESTSYSTEM_ENABLED";

//------------------------------------------------------------------------------
// * Items: Enable this switch to turn on the Project Q Expendable Torches and
// * Lanterns System. Torches and lanterns will now burn for a limited duration.
// * Lanterns can be "recharged" using lamp oil.
// *
// * NOTE: If using this system, the Project Q Rest System MUST be enabled and
// * you MUST use q_mod_def_rest.nss as your module's OnPlayerRest event.
const string MODULE_SWITCH_EXPENDABLE_TORCHES_ENABLED = "Q_SWITCH_EXPENDABLE_TORCHES_ENABLED";

//------------------------------------------------------------------------------
// * Rulesets: Enable this switch to turn on the Project Q Cursed Items System.
// * This system allows for the creation of dynamic cursed items (items whose
// * true nature doesn't reveal itself until equipped). Once equipped, cursed
// * items cannot be unequipped, dropped, or sold. This switch is disabled by
// * default.
const string MODULE_SWITCH_CURSED_ITEMS_ENABLED = "Q_SWITCH_CURSED_ITEMS_ENABLED";

// * Creatures: Enable this switch to make trolls impossible to kill unless
// * damaged by fire or acid. This switch is disabled by default.
const string MODULE_SWITCH_HARDCORE_TROLLS = "Q_SWITCH_HARDCORE_TROLLS";

// * Experience: Enable this switch to use ScrewTape's Simple XP - an alternative
// * system for awarding XP, allowing the Builder more control than the BioWare
// * system. This switch is disabled by default.
const string MODULE_SWITCH_SIMPLE_XP_ENABLED = "Q_SWITCH_SIMPLE_XP_ENABLED";

// * Rulesets: Enable this switch to enforce using material spell components to
// * cast spells. The components for each spell are listed in q_spellhook.nss.
// * This switch is disabled by default.
const string MODULE_SWITCH_SPELL_COMPONENTS_ENABLED = "Q_SWITCH_SPELL_COMPONENTS_ENABLED";

// * Spells: Enable this switch to change the way that the Identify and Legend
// * Lore spells work. When enabled, Identify will identify the targeted item
// * Legend Lore will identify ALL items in the caster's inventory. This switch
// * is disabled by default.
const string MODULE_SWITCH_PNP_IDENTIFY = "Q_SWITCH_PNP_IDENTIFY";

// * Spells: Enable this switch to change the way that the Bane and Bless spells
// * work. When enabled, Bane and Bless can be used to dispel each other's effects
// * and Bane cannot be used to target bolts. This switch is disabled by default.
const string MODULE_SWITCH_PNP_BANE_BLESS = "Q_SWITCH_PNP_BANE_BLESS";


//------------------------------------------------------------------------------
// CREATURE AI OVERRIDES
//------------------------------------------------------------------------------

const string CREATURE_VAR_SPECIAL_CONVERSATION        = "Q_SPECIAL_CONVERSATION";
const string CREATURE_VAR_SPECIAL_COMBAT_CONVERSATION = "Q_SPECIAL_COMBAT_CONVERSATION";
const string CREATURE_VAR_AI_ASSIST_ALLIES            = "Q_L_ASSIST_ALLIES";
const string CREATURE_VAR_AI_SHOUT_WARNING            = "Q_L_SHOUT_WARNING";
const string CREATURE_VAR_AI_DAY_NIGHT_POST           = "Q_L_DAY_NIGHT_POST";
const string CREATURE_VAR_USE_SPAWN_APPEAR_ANIM       = "Q_L_SPAWN_USE_APPEAR_ANIM";

// AMBIENT ANIMATION CONDITIONS - can only be used with ambient animations
// The variable X2_L_SPAWN_USE_AMBIENT or X2_L_SPAWN_USE_AMBIENT_IMMOBILE must be
// defined on the creature

const string CREATURE_VAR_USE_AMBIENT_CIVILIZED       = "Q_L_USE_AMBIENT_CIVILIZED";
const string CREATURE_VAR_USE_AMBIENT_CONSTANT        = "Q_L_USE_AMBIENT_CONSTANT";
const string CREATURE_VAR_USE_AMBIENT_CHATTER         = "Q_L_USE_AMBIENT_CHATTER";
const string CREATURE_VAR_USE_AMBIENT_CLOSE           = "Q_L_USE_AMBIENT_MOBILE_CLOSE";

// SPECIAL COMBAT TACTICS - use only one at a time

const string CREATURE_VAR_AI_COMBAT_RANGED            = "Q_L_AI_COMBAT_RANGED";
const string CREATURE_VAR_AI_COMBAT_DEFENSE           = "Q_L_AI_COMBAT_DEFENSE";
const string CREATURE_VAR_AI_COMBAT_AMBUSH            = "Q_L_AI_COMBAT_AMBUSH";
const string CREATURE_VAR_AI_COMBAT_COWARD            = "Q_L_AI_COMBAT_COWARD";

// SPECIAL ESCAPE TACTICS - use only one at a time

const string CREATURE_VAR_AI_ESCAPE_RETURN            = "Q_L_AI_ESCAPE_RETURN";
const string CREATURE_VAR_AI_ESCAPE_LEAVE             = "Q_L_AI_ESCAPE_LEAVE";
const string CREATURE_VAR_AI_TELEPORT_LEAVE           = "Q_L_AI_TELEPORT_LEAVE";
const string CREATURE_VAR_AI_TELEPORT_RETURN          = "Q_L_AI_TELEPORT_RETURN";

// USER DEFINED EVENTS - fires the OnSpawn user defined event

const string CREATURE_VAR_UD_HEARTBEAT                = "Q_L_SPAWN_UD_HEARTBEAT";
const string CREATURE_VAR_UD_PERCIEVE                 = "Q_L_SPAWN_UD_PERCIEVE";
const string CREATURE_VAR_UD_END_COMBAT               = "Q_L_SPAWN_UD_END_COMBAT";
const string CREATURE_VAR_UD_DIALOG                   = "Q_L_SPAWN_UD_DIALOG";
const string CREATURE_VAR_UD_ATTACK                   = "Q_L_SPAWN_UD_ATTACK";
const string CREATURE_VAR_UD_DAMAGED                  = "Q_L_SPAWN_UD_DAMAGED";
const string CREATURE_VAR_UD_DEATH                    = "Q_L_SPAWN_UD_DEATH";
const string CREATURE_VAR_UD_DISTURBED                = "Q_L_SPAWN_UD_DISTURBED";
const string CREATURE_VAR_UD_SPELL_CAST_AT            = "Q_L_SPAWN_UD_SPELLCAST";

// SPECIAL BEHAVIOR STATES - use only one at a time

const string CREATURE_VAR_BS_CARNIVORE                = "Q_L_BS_CARNIVORE";
const string CREATURE_VAR_BS_HERBIVORE                = "Q_L_BS_HERBIVORE";
const string CREATURE_VAR_BS_OMNIVORE                 = "Q_L_BS_OMNIVORE";

