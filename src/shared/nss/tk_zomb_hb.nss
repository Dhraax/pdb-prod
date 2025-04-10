//::///////////////////////////////////////////////
//:: tk_zomb_hb
//:://////////////////////////////////////////////
/*
    Heartbeat event handler for The Krit's
    version of zombies spawning from placeable
    corpses.

    If there are no PC's in the current area, the
    zombie will despawn into a placeable.
*/
//:://////////////////////////////////////////////
//:: Created by: The Krit
//:: Created on: October 24, 2007
//:://////////////////////////////////////////////


#include "tk_zomb_inc"
#include "tk_detector_inc"


// Creates the placeable corpse (when despawning).
object CreateCorpse(location lHere);


void main()
{
    // Check for PC's in our area.
    if ( GetArea(OBJECT_SELF) ==
         GetArea(GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC)) )
        // Execute the default heartbeat script.
        // (The Hordes script is just a wrapper for this, so we'll save time.)
        ExecuteScript("nw_c2_default1", OBJECT_SELF);

    else
    {
        // Time to despawn into a corpse placeable.
        // Flag this so the death script doesn't think we really died and
        // need to be respawned on delay.
        SetLocalInt(OBJECT_SELF, TK_ZOMBIE_DESPAWNING, TRUE);

        location lHere = TK_GetRotatedLocation(-GetLocalFloat(OBJECT_SELF, TK_ZOMBIE_ROTATION));
        string sSize = GetStringLowerCase(GetLocalString(OBJECT_SELF, TK_ZOMBIE_SIZE));

        // Immediately fall down (and don't allow other actions).
        SetCommandable(TRUE);
        ClearAllActions();
        if ( GetLocalInt(OBJECT_SELF, TK_ZOMBIE_FACEUP) )
            PlayAnimation(ANIMATION_LOOPING_DEAD_BACK,  1.0, 6.0);
        else
            PlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0, 6.0);
        SetCommandable(FALSE);

        // Create the placeable (hidden until the zombie finishes lying down).
        object oCorpse = CreateCorpse(lHere);
        if ( oCorpse != OBJECT_SELF )
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                                EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY),
                                oCorpse, TK_ZOMBIE_FALLDOWNTIME);

            // Destroy self.
            SetIsDestroyable(TRUE, FALSE);
            DestroyObject(OBJECT_SELF, TK_ZOMBIE_FALLDOWNTIME);
        }

        // Determine the size of the detector.
        int nRadius = 5;
        if ( "small" == sSize )
            nRadius = 3;
        else if ( "large" == sSize )
            nRadius = 10;

        // Create a detector.
        TK_CreateDetector(lHere, "tk_zomb_rise", oCorpse, FALSE, nRadius);
    }
}


object CreateCorpse(location lHere)
{
    object oCorpse;

    // See if a local variable overrides the default placeable.
    string sResRef = GetLocalString(OBJECT_SELF, TK_ZOMBIE_PLACEABLE);
    if ( sResRef == "" )
        sResRef = TK_ZOMBIE_DEFAULT_PLACEABLE;

    if ( GetStringUpperCase(sResRef) != TK_ZOMBIE_MYSELF )
    {
        // Create and initialize the placeable.
        oCorpse = CreateObject(OBJECT_TYPE_PLACEABLE, sResRef, lHere);
        SetLocalString(oCorpse, TK_ZOMBIE_CREATURE, GetResRef(OBJECT_SELF));
        TK_CopyZombieLocals(oCorpse, OBJECT_SELF);
        SetUseableFlag(oCorpse, GetLocalInt(OBJECT_SELF, TK_ZOMBIE_SELECTABLE));
    }
    else
    {
        // Our own non-fading corpse shall serve in lieu of a placeable.
        oCorpse = OBJECT_SELF;
        if ( GetLocalString(OBJECT_SELF, TK_ZOMBIE_CREATURE) == "" )
            SetLocalString(OBJECT_SELF, TK_ZOMBIE_CREATURE, GetResRef(OBJECT_SELF));
        SetIsDestroyable(FALSE, FALSE, GetLocalInt(OBJECT_SELF, TK_ZOMBIE_SELECTABLE));
        DelayCommand(TK_ZOMBIE_FALLDOWNTIME,
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), OBJECT_SELF));
        // Force face-down for this option (because NWN does).
        SetLocalInt(OBJECT_SELF, TK_ZOMBIE_FACEUP, FALSE);
    }

    // Done.
    return oCorpse;
}

