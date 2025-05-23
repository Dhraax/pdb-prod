//::///////////////////////////////////////////////
//:: tk_detector_inc
//:://////////////////////////////////////////////
/*
    This file defines functions that can be used
    to create a detector -- an area of effect that
    will respond to approaching enemies.

    These detectors are by default one-shot things
    that self-destruct upon detecting an enemy.

    NOTE: "Enemies" would be with respect to whatever
    object is calling the function.
*/
//:://////////////////////////////////////////////
//:: Created by: The Krit
//:: Created on: October 24, 2007
//:://////////////////////////////////////////////



//------------------------------------------------------------------------------
// CONSTANTS
//------------------------------------------------------------------------------


// The local variable that will be used to help find the area of effect.
// This should be set to true on all custom areas of effect that are created.
const string TK_AOE_INITIALIZE_FLAG = "CustomAOE_Initialized";

// Local string set on the detector that names the script to be run when an
// intruder is detected.
const string TK_DETECTOR_SCRIPT = "TK_DETECTOR_Script";

// Local object set on the detector that will run the above named script.
const string TK_DETECTOR_EXECUTER = "TK_DETECTOR_Executer";


//------------------------------------------------------------------------------
// PROTOTYPES
//------------------------------------------------------------------------------


// Creates and returns an area of effect that will serve to detect any nearby
// intruders.
//
// lTarget is where the effect will be centered.
// sEnterScript is the name of the script that will be executed when an intruder
// enters the detector.
// oExecuter is the object that will execute the script. If OBJECT_INVALID, then
// the detector itself will execute the script.
// if bOverrideScript is set to TRUE, the detector will execute sEnterScript
// whenever any creature enters it. oExecuter will be ignored, and the detector
// will not automatically self-destruct.
// nDesiredRadius will be used to select the size of the detector. The size used
// will be the largest available that is not larger than nDesiredRadius (or the
// smallest available if none are not larger).
// Currently, the three available sizes are 2.5, 5, and 10 m radii.
object TK_CreateDetector(location lTarget, string sEnterScript, object oExecuter = OBJECT_INVALID, int bOverrideScript = FALSE, int nDesiredRadius = 5);



//------------------------------------------------------------------------------
// PRIVATE DECLARATIONS
//------------------------------------------------------------------------------

// Used by RadiusToEffect() to return two values.
struct TagAndId
{
    int ID;
    string Tag;
};

// Returns the ID and tag of the "best-fit" area of effect.
// "Best-fit" means largest available that is not larger than nRadius.
// (Or smallest available if none are not larger.)
// Currently, the three available sizes are 2.5, 5, and 10 m radii.
struct TagAndId RadiusToEffect(int nRadius)
{
    struct TagAndId EffectDesc;

    // Choose the largest effect that is not larger than nRadius.
    if ( nRadius >= 10 )
    {
        EffectDesc.ID = AOE_MOB_INVISIBILITY_PURGE;
        EffectDesc.Tag = "VFX_MOB_INVISIBILITY_PURGE";
    }
    else if ( nRadius >= 5 )
    {
        EffectDesc.ID = AOE_PER_CUSTOM_AOE;
        EffectDesc.Tag = "VFX_CUSTOM";
    }
    else // Smallest possible. (2.5m radius)
    {
        EffectDesc.ID = AOE_PER_GLYPH_OF_WARDING;
        EffectDesc.Tag = "VFX_PER_GLYPH";
    }

    // Done.
    return EffectDesc;
}



//------------------------------------------------------------------------------
// PUBLIC FUNCTIONS
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// TK_CreateDetector()
//
// Creates and returns an area of effect that will serve to detect any nearby
// intruders.
//
// lTarget is where the effect will be centered.
// sEnterScript is the name of the script that will be executed when an intruder
// enters the detector.
// oExecuter is the object that will execute the script. If OBJECT_INVALID, then
// the detector itself will execute the script.
// if bOverrideScript is set to TRUE, the detector will execute sEnterScript
// whenever any creature enters it. oExecuter will be ignored, and the detector
// will not automatically self-destruct.
// nDesiredRadius will be used to select the size of the detector. The size used
// will be the largest available that is not larger than nDesiredRadius (or the
// smallest available if none are not larger).
// Currently, the three available sizes are 2.5, 5, and 10 m radii.
//
object TK_CreateDetector(location lTarget, string sEnterScript, object oExecuter = OBJECT_INVALID, int bOverrideScript = FALSE, int nDesiredRadius = 5)
{
    // Determine the invisible area of effect to use.
    struct TagAndId EffectDesc = RadiusToEffect(nDesiredRadius);

    // Create an invisible area of effect to detect intruders.
    effect eDetector;
    if ( bOverrideScript )
        eDetector = EffectAreaOfEffect(EffectDesc.ID, sEnterScript);
    else
        eDetector = EffectAreaOfEffect(EffectDesc.ID, "tk_detector_ent");
    ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eDetector, lTarget);

    // Look for the area of effect object we just created.
    object oDetector = GetFirstObjectInShape(SHAPE_CUBE, 0.0, lTarget, FALSE,
                                             OBJECT_TYPE_AREA_OF_EFFECT);
    while( GetIsObjectValid(oDetector) )
    {
        // Match creator, tag, and not initialized yet.
        if( GetAreaOfEffectCreator(oDetector) == OBJECT_SELF  &&
            GetTag(oDetector) == EffectDesc.Tag  &&
            !GetLocalInt(oDetector, TK_AOE_INITIALIZE_FLAG) )
        {
            // Flag this detector as initialized.
            SetLocalInt(oDetector, TK_AOE_INITIALIZE_FLAG, TRUE);
            // Set the local variables used by the OnEnter script.
            SetLocalString(oDetector, TK_DETECTOR_SCRIPT, sEnterScript);
            if ( oExecuter != OBJECT_INVALID )
                SetLocalObject(oDetector, TK_DETECTOR_EXECUTER, oExecuter);
            else
                SetLocalObject(oDetector, TK_DETECTOR_EXECUTER, oDetector);

            // Return this object.
            return oDetector;
        }

        // Get the next candidate AOE object.
        oDetector = GetNextObjectInShape(SHAPE_CUBE, 0.0, lTarget, FALSE,
                                         OBJECT_TYPE_AREA_OF_EFFECT);
    }

    // This should never happen, but there still needs to be a default return value.
    return OBJECT_INVALID;
}

