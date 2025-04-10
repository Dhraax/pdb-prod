//::///////////////////////////////////////////////
//:: tk_zomb_inc
//:://////////////////////////////////////////////
/*
    Constants and utility functions for use with
    The Krit's version of zombies spawning from
    placeable corpses.
    (NOTE: Spawning from a placeable is the player's
    perspective. Builders will be placing creatures
    who will self-despawn into placeables.)
*/
//:://////////////////////////////////////////////
//:: Created by: The Krit
//:: Created on: October 24, 2007
//:://////////////////////////////////////////////


/***********************************************************
 * To use these zombies, all you have to do is place a zombie
 * and use tk_zomb_hb as that zombie's heartbeat event handler.
 ***********************************************************
 * If you make the above change only to a placed zombie, the
 * zombie will despawn into a corpse, then respawn into a
 * normal zombie when approached by an enemy.
 *
 * On the other hand, if you make the above change to a
 * zombie blueprint, then the respawned zombie will despawn
 * back into its placeable when there are no PC's in the
 * current area. (Side effect: the zombie is cured of all
 * ailments.)
 ***********************************************************
 * Respawning:
 *
 * If you, in addition to setting the heartbeat, change a
 * zombie's blueprint to use tk_zombie_onspawn as the spawn
 * script and tk_zombie_ondeath as the death script, then
 * a set time after a zombie is killed, the zombie will
 * respawn at its original location. This could be handy
 * for persistent worlds.
 ***********************************************************
 * Ready for advanced stuff?
 *
 * Zombies might decide to move around before despawning into
 * placeables. If this is a problem, execute the heartbeat
 * script (tk_zomb_hb) from the OnSpawn event.
 *
 * By default, the corpse placeables are not usable. To change
 * this, set a local integer named TK_ZOMBIE_CorpseUsable on
 * the zombie to 1 (or any true value).
 *
 * By default, the respawned zombie is created from the same
 * blueprint that the original zombie came from. You can
 * override this by setting a local string named
 * TK_ZOMBIE_CreatureResRef to the desired ResRef. This local
 * can be set on either the zombie or the placeable.
 * (This might be handy if you want to randomize the zombies
 * somewhat.)
 *
 * The range at which enemies are detected is somewhat
 * customizable. To specify the range, set a local string
 * named TK_ZOMBIE_DetectRange on the zombie. Valid values
 * for this string are "Small" and "Large". Any other value
 * will result in the default (medium) range.
 * ("Small" = 2.5m, "Medium" = 5m, and "Large" = 10m.)
 ***********************************************************
 * Want more variety in the corpses?
 *
 * You can specify which placeable the zombies despawn into
 * via a local string named TK_ZOMBIE_CorpseResRef on the
 * zombie. Set this to the ResRef of the placeable you want.
 *
 * If you specify a placeable that's face-up (the default is
 * face-down), you can make the zombie's entrance look better
 * if you set a local integer named TK_ZOMBIE_FaceUp on the
 * zombie to 1 (or any true value).
 *
 * Some placeables might not be oriented properly for the
 * zombie's entrance animation. You can adjust this with a
 * local float named TK_ZOMBIE_SpawnFacing on the zombie.
 * The value of this variable will be added to the placeable's
 * facing to get the facing of the respawning zombie. (Most
 * likely, the corpse needs to be rotated 180 degrees.)
 *
 * If you want the creature to stick around as a corpse
 * instead of a placeable, set the local string
 * TK_ZOMBIE_CorpseResRef to "Myself" (no quotes). You can
 * use this in conjunction with TK_ZOMBIE_CorpseUsable,
 * but not with TK_ZOMBIE_FaceUp. (NWN isn't letting me
 * keep a dead creature face-up.)
 ***********************************************************
 * For a cool effect, configure a non-zombie with the
 * zombie heartbeat script, set a local string named
 * TK_ZOMBIE_CorpseResRef to "Myself" (no quotes), then set
 * a local string named TK_ZOMBIE_CreatureResRef to the
 * ResRef of a zombie. (The local variables are on the
 * creature.)
 *
 * This creature will quickly fall down dead, and when
 * approached by an enemy, will rise as a zombie.
 *
 * If you combine this with respawning a fixed time after
 * death, be aware that the non-zombie blueprint needs the
 * special spawn script, and the zombie blueprint needs the
 * special death script.
 ***********************************************************
 * Known limitations:
 *
 * These zombies cannot be used in an area where a PC will be
 * right after the module is loaded. (They won't despawn to
 * placeables.) This should not be an issue for modules run
 * with the dedicated server, and in single-player you can
 * probably get away with BioWare's zombie corpses in the
 * starting area.
 *
 * Zombies might behave unexpectedly if they come from a
 * blueprint named Myself. I'm hoping this name is not used.
 * If this is a problem, the flag for "self-corpses" can be
 * changed by redefining the constant TK_ZOMBIE_MYSELF below.
 ***********************************************************/


//------------------------------------------------------------------------------
// CONSTANTS
//------------------------------------------------------------------------------


// The blueprint of the default placeable corpse.
const string TK_ZOMBIE_DEFAULT_PLACEABLE = "plc_corpse3";
// The placeable ResRef that means do not use a placeable. Must be in ALL CAPS.
const string TK_ZOMBIE_MYSELF = "MYSELF";

// Indicates if zombies should respawn.
const int TK_ZOMBIE_RESPAWN_FLAG = TRUE;
// The time (in seconds) after death before respawning.
const float TK_ZOMBIE_DEFAULT_RESPAWN = 300.0;
// The time (in seconds) between checks for PC's in the respawn area.
// Set to 0.0 to have zombies spawn even if PC's are in the respawn area.
const float TK_ZOMBIE_RESPAWN_HEARTBEAT = 6.0;

// Local variables.
const string TK_ZOMBIE_CREATURE   = "TK_ZOMBIE_CreatureResRef"; // ResRef of the zombie.
const string TK_ZOMBIE_DESPAWNING = "TK_ZOMBIE_IsDespawning";   // TRUE when a zombie is despawning (not really killed).
const string TK_ZOMBIE_FACEUP     = "TK_ZOMBIE_FaceUp";         // TRUE if zombie should respawn face-up.
const string TK_ZOMBIE_ORIGINAL   = "TK_ZOMBIE_SpawnResRef";    // ResRef of the zombie who originally spawned.
const string TK_ZOMBIE_PLACEABLE  = "TK_ZOMBIE_CorpseResRef";   // ResRef of the placeable corpse.
const string TK_ZOMBIE_RESPAWN    = "TK_ZOMBIE_RespawnDelay";   // Creature-specific time between death and respawning. (float)
const string TK_ZOMBIE_ROTATION   = "TK_ZOMBIE_SpawnFacing";    // Amount to rotate the zombie by to make rising look good. (float)
const string TK_ZOMBIE_SELECTABLE = "TK_ZOMBIE_CorpseUsable";   // TRUE if the corpse should be usable/highlightable.
const string TK_ZOMBIE_SIZE       = "TK_ZOMBIE_DetectRange";    // "Small", "Medium", or "Large"
const string TK_ZOMBIE_SPAWN_FLAG = "TK_ZOMBIE_SpawnRecorded";  // TRUE if the spawn location has been saved.
const string TK_ZOMBIE_SPAWN_LOC  = "TK_ZOMBIE_SpawnLocation";  // Stores the place where the zombie spawned.

// The time it takes for a zombie to play the "fall down" animation.
// (Used to time events around the animation. Changing this value will not
// change the speed of the animation.)
const float TK_ZOMBIE_FALLDOWNTIME = 1.5;



//------------------------------------------------------------------------------
// PROTOTYPES
//------------------------------------------------------------------------------


// Copies the local variables used by these zombie scripts from
// oCopyFrom to oCopyTo.
void TK_CopyZombieLocals(object oCopyTo, object oCopyFrom);

// Returns the caller's current location, with the facing rotated by
// fRotate.
location TK_GetRotatedLocation(float fRotate);


//------------------------------------------------------------------------------
// FUNCTIONS
//------------------------------------------------------------------------------


//--------------------------------------------------------------------
// TK_CopyZombieLocals()
//
// Copies the local variables used by these zombie scripts from
// oCopyFrom to oCopyTo.
//
// Omitted are TK_ZOMBIE_CREATURE, because that is set as needed, and
// TK_ZOMBIE_DESPAWNING, because that indicates a state that does
// not persist from creature to creature.
//
void TK_CopyZombieLocals(object oCopyTo, object oCopyFrom)
{
    SetLocalInt(     oCopyTo, TK_ZOMBIE_FACEUP,     GetLocalInt(     oCopyFrom, TK_ZOMBIE_FACEUP));
    SetLocalString(  oCopyTo, TK_ZOMBIE_ORIGINAL,   GetLocalString(  oCopyFrom, TK_ZOMBIE_ORIGINAL));
    SetLocalString(  oCopyTo, TK_ZOMBIE_PLACEABLE,  GetLocalString(  oCopyFrom, TK_ZOMBIE_PLACEABLE));
    SetLocalFloat(   oCopyTo, TK_ZOMBIE_RESPAWN,    GetLocalFloat(   oCopyFrom, TK_ZOMBIE_RESPAWN));
    SetLocalFloat(   oCopyTo, TK_ZOMBIE_ROTATION,   GetLocalFloat(   oCopyFrom, TK_ZOMBIE_ROTATION));
    SetLocalInt(     oCopyTo, TK_ZOMBIE_SELECTABLE, GetLocalInt(     oCopyFrom, TK_ZOMBIE_SELECTABLE));
    SetLocalInt(     oCopyTo, TK_ZOMBIE_SPAWN_FLAG, GetLocalInt(     oCopyFrom, TK_ZOMBIE_SPAWN_FLAG));
    SetLocalLocation(oCopyTo, TK_ZOMBIE_SPAWN_LOC,  GetLocalLocation(oCopyFrom, TK_ZOMBIE_SPAWN_LOC));
}


//--------------------------------------------------------------------
// Returns the caller's current location, with the facing rotated by
// fRotate.
location TK_GetRotatedLocation(float fRotate)
{
    location lHere = GetLocation(OBJECT_SELF);

    return Location(GetAreaFromLocation(lHere),
                    GetPositionFromLocation(lHere),
                    GetFacingFromLocation(lHere) + fRotate);
}

