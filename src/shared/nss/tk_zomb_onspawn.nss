//::///////////////////////////////////////////////
//:: Name: tk_zomb_onspawn
//:://////////////////////////////////////////////
/*
    OnSpawn script for The Krit's zombies, if
    you want the zombies to respawn after death.

    Only works in combination with tk_zomb_ondeath.


    Chains through the Hordes spawn script, so the
    following applies:

    If you set an integer on the creature named
    "X2_USERDEFINED_ONSPAWN_EVENTS"
    The creature will fire a pre and a post-spawn
    event on itself, depending on the value of that
    variable
    1 - Fire Userdefined Event 1510 (pre spawn)
    2 - Fire Userdefined Event 1511 (post spawn)
    3 - Fire both events

*/
//:://////////////////////////////////////////////
//:: Created By: The Krit
//:: Created On: October 24, 2007
//:://////////////////////////////////////////////


#include "tk_zomb_inc"


void main()
{
    // Execute default OnSpawn script.
    ExecuteScript("x2_def_spawn", OBJECT_SELF);

    // Make sure we don't somehow overwrite info.
    if ( !GetLocalInt(OBJECT_SELF, TK_ZOMBIE_SPAWN_FLAG) )
    {
        SetLocalInt(OBJECT_SELF, TK_ZOMBIE_SPAWN_FLAG, TRUE);
        // Save our spawn location.
        SetLocalLocation(OBJECT_SELF, TK_ZOMBIE_SPAWN_LOC, GetLocation(OBJECT_SELF));
        // Save our ResRef.
        SetLocalString(OBJECT_SELF, TK_ZOMBIE_ORIGINAL, GetResRef(OBJECT_SELF));
    }
}

