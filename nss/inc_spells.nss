//::///////////////////////////////////////////////
//:: Spells Library
//:: inc_spells
//:://////////////////////////////////////////////
/*
    Contains functions for handling spells
    and spell-like effects.
*/

#include "pb_nivellanzador"
//#include "x2_inc_spellhook"

/**********************************************************************
 * CONFIG PARAMETERS
 **********************************************************************/

// Controls the amount of overlap allowed for persistent AOEs. Effective values range
// from 0.0 (no overlap) to 100.0 (complete overlap).
const float AOE_OVERLAP_PERCENTAGE = 50.0;

// Allows NPCs to overlap persistent AoEs when set to TRUE.
const int ALLOW_NPC_AOE_OVERLAP = FALSE;

// Blueprint created as a source for static VFX (e.g. vfx on glyph of warding).
const string BLUEPRINT_STATIC_VFX = "gs_null";
// Heartbeat script for static VFX. Responsible for destroying the object when
// the source AoE is removed (e.g. by dispels).
const string STATIC_VFX_ON_HEARTBEAT = "hrt_staticvfx";

/**********************************************************************
 * CONSTANT DEFINITIONS
 **********************************************************************/

// Prefix to separate spells variables from other libraries.
const string LIB_SPELLS_PREFIX = "Lib_Spells_";

const int EFFECT_TAG_DURATION_MARKER             = 0x00000004;
// Generic spell focus feat references.
const int FEAT_SPELL_FOCUS = 0;
const int FEAT_GREATER_SPELL_FOCUS = 1;
const int FEAT_EPIC_SPELL_FOCUS = 2;

// Undefined ID values.
const int ABILITY_INVALID = -1;
const int FEAT_INVALID = -1;
const int SPELL_ID_UNDEFINED = 0;
const int SHAPE_UNDEFINED = -1;
const int SPELL_INVALID = -1;
const int SPELL_SLOT_INDEX_INVALID = -1;
const int SPECIAL_ABILITY_INDEX_UNDEFINED = -1;
const int SPONTANEOUS_SPELL_LEVEL_INVALID = -1;

// Function default parameters.
const int CLASS_TYPE_ANY = -1;
const int DETERMINE_SPELL_LEVEL_BY_CLASS = -1;
const int DETERMINE_CASTER_LEVEL_BY_CLASS = -1;
const int GET_LAST_SPELL_CAST_CLASS = -1;
const int LAST_SPELL_CAST_CLASS = -2;

// An undefined effect tag.
const int EFFECT_TAG_UNDEFINED = -1;

// Additionals
const float GS_SP_DURATION_INSTANT        = -1.0;
const float GS_SP_DURATION_PERMANENT      = -2.0;
const int GS_SP_TYPE_BENEFICIAL           =  1;
const int GS_SP_TYPE_BENEFICIAL_SELECTIVE =  2;
const int GS_SP_TYPE_HARMFUL              =  3;
const int GS_SP_TYPE_HARMFUL_SELECTIVE    =  4;
const string GS_C2_SPELL_EFFECTIVENESS        = "GS_C2_SE_";
/**********************************************************************
 * PUBLIC FUNCTION PROTOTYPES
 **********************************************************************/

//return TRUE if oTarget is affected by a nType (GS_SP_TYPE_*) spell of oCaster
int gsSPGetIsAffected(int nType, object oCaster, object oTarget);
//return TRUE if oTarget resists nSpell of oCaster, show visual effect after fDelay
int gsSPResistSpell(object oCaster, object oTarget, int nSpell, float fDelay = 0.0);
//adjust if nSpell is nEffective on oCreature
void gsC2AdjustSpellEffectiveness(int nSpell, object oCreature, int nEffective = TRUE);
//apply eEffect of nSpell to oTarget for fDuration
void gsSPApplyEffect(object oTarget, effect eEffect, int nSpell, float fDuration = GS_SP_DURATION_INSTANT);
//remove all effects of nSpell applied by oCaster from oTarget
int gsSPRemoveEffect(object oTarget, int nSpell = -1, object oCaster = OBJECT_INVALID, string sTag = "", int bForceRemove = FALSE);
//execute gs_spellscript and return TRUE if spell is overridden
//int gsSPGetOverrideSpell();
//------------------------------------------------------------------------------
//Since rounding does not exist in nwn, only truncation, this is a way
//to emulate rounding
//------------------------------------------------------------------------------
int IntDivisionRounding(int iDividend, int iDivisor, float fThreshold = 0.5);
//------------------------------------------------------------------------------
//Function to find an effect
//Returns: a valid effect or effect invalid
//------------------------------------------------------------------------------
effect gsSPfindEffect(int nSpellID, object oSource = OBJECT_SELF, object oCreator = OBJECT_SELF, string sTag = "");
//----------------------------------------------------------------
// Returns the Id of the nonstacking AoE. The Id corresponds to the spell or ability
// used to create it.
int GetAoEId(object oAoE);
// Returns the radius of the AoE associated with nAreaEffectId.
float GetAoERadius(int nAreaEffectId);
// Returns the shape of the AoE associated with nAreaEffectId. Rectangular AoEs
// will return SHAPE_CUBE.
int GetAoEShape(int nAreaEffectId);
// Returns the static VFX partner for the AoE, if one exists.
object GetAoEPartner(object oAoE);
// Overrides the cast class used for the existing AoE.
void SetAoECastClass(object oAoE, int nClass);
// Overrides the caster level used for the existing AoE.
void SetAoECasterLevel(object oAoE, int nCasterLevel);
// Sets an Id variable on the nonstacking AoE.
void SetAoEId(object oAoE, int nId);
// Overrides the metamagic feat used for the existing AoE.
void SetAoEMetaMagic(object oAoE, int nMetaMagic);
// Creates a persistent AoE at the target location. AoEs of the same type will not stack if cast by the same caster.
// If scripts for the AoE are not specified, default ones will be used.
// If nSpellId is not set, then the value of GetSpellId() will be used.
void CreateNonStackingPersistentAoE(int nDurationType, int nAreaEffectId, location lLocation, float fDuration = 0.0,
    string sOnEnterScript = "", string sHeartbeatScript = "", string sOnExitScript = "", int nSpellId = SPELL_ID_UNDEFINED, object oCreator = OBJECT_SELF,
    int nCasterClass = GET_LAST_SPELL_CAST_CLASS, string sStaticVFXTemplate = BLUEPRINT_STATIC_VFX, string sSpellName = "", int nStaticVFX1 = VFX_NONE, int nStaticVFX2 = VFX_NONE);
// Applies a tagged effect to an object. A tagged effect has a unique retrievable Id.
// Note that this should not be called from spell scripts, since tagged effects do
// not contain spell Id parameters and always apply as extraordinary effects.
void ApplyTaggedEffectToObject(int nDurationType, effect eEffect, object oTarget, float fDuration = 0.0f, int nEffectTag = EFFECT_TAG_UNDEFINED);

/**********************************************************************
 * PRIVATE FUNCTION PROTOTYPES
 **********************************************************************/

/* Creates a static VFX object, coupled with an AoE. This allows an AoE to appear to hold
   VFX that it naturally could not (e.g. glyph of warding). */
object _CreateStaticVFX(string sName, int nId, location lLocation, float fDuration, string sStaticSourceTemplate, int nVFX1, int nVFX2);
/* Sets a unique Id on the AoE at the specified location. */
void _UpdateAoEDataAtLocation(location lLocation, int nId, object oStaticVFX, int nCasterLevel, int nCastClass, float fDuration, int nMetaMagic);
/* Stores a reference to the coupled AoE on the static VFX. */
void _SetStaticVFXPartner(object oVFX, object oPartner);
/* Stores a reference to the coupled static VFX on the AoE. */
void _SetAoEPartner(object oAoE, object oPartner);

/**********************************************************************
 * PUBLIC ADDITIONALS FUNCTION DEFINITIONS
 **********************************************************************/
 //----------------------------------------------------------------
int gsSPGetIsAffected(int nType, object oCaster, object oTarget)
{
    if (GetObjectType(oTarget) == OBJECT_TYPE_ITEM)           return TRUE;
    if (GetPlotFlag(oTarget))                                 return FALSE;
    if (GetIsDM(oCaster))                                     return TRUE;
    // Edit by Mithreas - allow healing spells to heal dying PCs.
    if (GetIsDead(oTarget) && nType != GS_SP_TYPE_BENEFICIAL) return FALSE;

    // NPCs never hurt allies.
    if(!GetIsPC(oCaster) && nType == GS_SP_TYPE_HARMFUL)
        nType = GS_SP_TYPE_HARMFUL_SELECTIVE;

    switch (nType)
    {
    case GS_SP_TYPE_BENEFICIAL:
        return TRUE;

    case GS_SP_TYPE_BENEFICIAL_SELECTIVE:
        if (GetIsReactionTypeFriendly(oTarget, oCaster) ||
            (GetFactionEqual(oTarget, oCaster) &&
             ! GetIsReactionTypeHostile(oTarget, oCaster)))
        {
            return TRUE;
        }
        break;

    case GS_SP_TYPE_HARMFUL:
        if (GetIsPC(oCaster))                           return TRUE;
        if (GetIsReactionTypeHostile(oTarget, oCaster)) return TRUE;
        break;

    case GS_SP_TYPE_HARMFUL_SELECTIVE:
        if (oTarget == oCaster)                         return FALSE;
        if (GetIsReactionTypeHostile(oTarget, oCaster)) return TRUE;
        break;
    }

    return FALSE;
}
//----------------------------------------------------------------
int gsSPResistSpell(object oCaster, object oTarget, int nSpell, float fDelay = 0.0)
{
    if(GetIsObjectValid(GetSpellCastItem())) return FALSE;

    int nEffect = FALSE;

    switch (ResistSpell(oCaster, oTarget))
    {
    case 1: //resistance
        nEffect = VFX_IMP_MAGIC_RESISTANCE_USE;
        break;

    case 2: //imunity
        nEffect = VFX_IMP_GLOBE_USE;
        break;

    case 3: //absorption
        nEffect = VFX_IMP_SPELL_MANTLE_USE;
        break;
    }

    if (nEffect)
    {
        DelayCommand(
            fDelay,
            ApplyEffectToObject(
                DURATION_TYPE_INSTANT,
                EffectVisualEffect(nEffect),
                oTarget));

        gsC2AdjustSpellEffectiveness(nSpell, oTarget, FALSE);
        return TRUE;
    }

    return FALSE;
}
//----------------------------------------------------------------
void gsC2AdjustSpellEffectiveness(int nSpell, object oCreature, int nEffective = TRUE)
{
    string sString      = GS_C2_SPELL_EFFECTIVENESS + IntToString(nSpell);
    int nEffectiveness  = GetLocalInt(oCreature, sString);

    nEffectiveness     += nEffective ? -3 : 1;
    if (nEffectiveness > 9)      nEffectiveness = 9;
    else if (nEffectiveness < 0) nEffectiveness = 0;

    SetLocalInt(oCreature, sString, nEffectiveness);

    //debug
    //AssignCommand(oCreature, SpeakString(nEffective ? "spell effective" : "spell ineffective"));
}
//----------------------------------------------------------------
void gsSPApplyEffect(object oTarget, effect eEffect, int nSpell, float fDuration = GS_SP_DURATION_INSTANT)
{
    effect eCurrentEffect = GetFirstEffect(oTarget);
    int nHitPoints        = GetCurrentHitPoints(oTarget);
    int nCount1           = 0;
    int nEffective        = FALSE;

    //effect count before
    while (GetIsEffectValid(eCurrentEffect))
    {
        nCount1        += 1;
        eCurrentEffect  = GetNextEffect(oTarget);
    }

    //apply effect
    if (fDuration == GS_SP_DURATION_INSTANT)
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, oTarget);
    }
    else
    {
        if (fDuration == GS_SP_DURATION_PERMANENT)
        {
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oTarget);
        }
        else
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, fDuration);
        }

        //check applied effect
        nEffective = GetHasSpellEffect(nSpell, oTarget);
    }

    //check spell effectiveness
    if (! nEffective)
    {
        //check hit point count
        if (nHitPoints == GetCurrentHitPoints(oTarget))
        {
            //effect count after
            int nCount2    = 0;
            eCurrentEffect = GetFirstEffect(oTarget);

            while (GetIsEffectValid(eCurrentEffect))
            {
                nCount2        += 1;
                eCurrentEffect  = GetNextEffect(oTarget);
            }

            //check effect count
            if (nCount1 == nCount2)
            {
                //the spell is considered ineffective
                gsC2AdjustSpellEffectiveness(nSpell, oTarget, FALSE);
                return;
            }
        }
    }

    //the spell is considered effective
    gsC2AdjustSpellEffectiveness(nSpell, oTarget);
}
//----------------------------------------------------------------------------
// Removes magical effects from a target creature.
//
// If nSpell >= 0, removes only effects from that spell ID.
// If nSpell < 0 (default), removes all effects with valid spell IDs
// created by the given oCaster (if provided).
//
// If sTag is not empty, only effects with that tag will be considered.
//
// By default, Supernatural and Unyielding effects are NOT removed.
// Pass bForceRemove = TRUE to override this behavior.
//
// Returns the number of effects removed.
//----------------------------------------------------------------------------
int gsSPRemoveEffect(object oTarget, int nSpell = -1, object oCaster = OBJECT_INVALID, string sTag = "", int bForceRemove = FALSE)
{
    if (!GetIsObjectValid(oTarget))
        return 0;

    int iRemoved = 0;

    effect eEffect = GetFirstEffect(oTarget);
    int bAnyCaster = !GetIsObjectValid(oCaster);
    int bMatchAnySpell = (nSpell < 0);
    int bUseTagFilter = (sTag != "");

    while (GetIsEffectValid(eEffect))
    {
        int iSpellId = GetEffectSpellId(eEffect);
        object oCreator = GetEffectCreator(eEffect);
        string sEffectTag = GetEffectTag(eEffect);
        int iSubType = GetEffectSubType(eEffect);

        // Skip Supernatural and Unyielding effects unless forced
        if (!bForceRemove &&
            (iSubType == SUBTYPE_SUPERNATURAL || iSubType == SUBTYPE_UNYIELDING))
        {
            eEffect = GetNextEffect(oTarget);
            continue;
        }

        if ((bMatchAnySpell || iSpellId == nSpell) &&
            (bAnyCaster || oCreator == oCaster) &&
            (!bUseTagFilter || sEffectTag == sTag))
        {
            RemoveEffect(oTarget, eEffect);
            iRemoved++;
        }

        eEffect = GetNextEffect(oTarget);
    }

    return iRemoved;
}

//----------------------------------------------------------------
// int gsSPGetOverrideSpell()
// {
//     return ! X2PreSpellCastCode(); //temporary override

//     //ExecuteScript("gs_spellscript", OBJECT_SELF);

//     int nOverrideSpell = GetLocalInt(OBJECT_SELF, "GS_SP_OVERRIDE_SPELL");
//     DeleteLocalInt(OBJECT_SELF, "GS_SP_OVERRIDE_SPELL");
//     return nOverrideSpell;
// }
//----------------------------------------------------------------
void gsSPSetOverrideSpell()
{
    SetLocalInt(OBJECT_SELF, "GS_SP_OVERRIDE_SPELL", TRUE);
}

//------------------------------------------------------------------------------
//Since rounding does not exist in nwn, only truncation, this is a way
//to emulate rounding
//------------------------------------------------------------------------------
int IntDivisionRounding(int iDividend, int iDivisor, float fThreshold = 0.5)
{
    //Convert the dividend and divisor into float and make the division
    float fQuotient = IntToFloat(iDividend)/IntToFloat(iDivisor);

    //Calculate the integer part of the quotient
    //This can be done by casting the variable to int and then casting it back to float
    float fQuotientIntPart = IntToFloat(FloatToInt(fQuotient));

    //To check if there is a decimal part, subtract the healing truncated to the healing with the decimal part
    //If it is greater or equal than 0.5, then round up
    if(fQuotient-fQuotientIntPart >= fThreshold)
    {
        //Increase the quotient by 1 due to rounding up
        fQuotient = fQuotientIntPart + 1;
    }
    else //otherwise round down
    {
        fQuotient = fQuotientIntPart;
    }

    return FloatToInt(fQuotient);
}
//----------------------------------------------------------------------------
// Finds an effect on the target with the given Spell ID and caster.
//
// If sTag is provided, only effects with that tag are considered.
//
// Returns a valid effect if found, or EffectInvalid() otherwise.
//----------------------------------------------------------------------------
effect gsSPfindEffect(int nSpellID, object oSource = OBJECT_SELF, object oCreator = OBJECT_SELF, string sTag = "")
{
    if (!GetIsObjectValid(oSource) || nSpellID < 0)
        return GetFirstEffect(OBJECT_INVALID);

    effect eExistingEffect = GetFirstEffect(oSource);
    int bUseTagFilter = (sTag != "");

    while (GetIsEffectValid(eExistingEffect))
    {
        if (GetEffectSpellId(eExistingEffect) == nSpellID &&
            GetEffectCreator(eExistingEffect) == oCreator &&
            (!bUseTagFilter || GetEffectTag(eExistingEffect) == sTag))
        {
            return eExistingEffect;
        }

        eExistingEffect = GetNextEffect(oSource);
    }

    return GetFirstEffect(OBJECT_INVALID);
}
//----------------------------------------------------------------
/**********************************************************************
 * PUBLIC FUNCTION DEFINITIONS
 **********************************************************************/

//::///////////////////////////////////////////////
//:: CreateNonStackingPersistentAoE
//:://////////////////////////////////////////////
/*
    Creates a persistent AoE at the target
    location. AoEs of the same type will not
    stack if cast by the same caster.

    If scripts for the AoE are not specified,
    default ones will be used.

    If nSpellId is not set, then the value of
    GetSpellId() will be used.
*/
void CreateNonStackingPersistentAoE(int nDurationType, int nAreaEffectId, location lLocation, float fDuration = 0.0,
    string sOnEnterScript = "", string sHeartbeatScript = "", string sOnExitScript = "", int nSpellId = SPELL_ID_UNDEFINED, object oCreator = OBJECT_SELF,
    int nCasterClass = GET_LAST_SPELL_CAST_CLASS, string sStaticVFXTemplate = BLUEPRINT_STATIC_VFX, string sSpellName = "", int nStaticVFX1 = VFX_NONE, int nStaticVFX2 = VFX_NONE)
{
    float fAoERadius = GetAoERadius(nAreaEffectId) * (1 - AOE_OVERLAP_PERCENTAGE / 100.0) * 2.0;
    object oStaticVFX;
    object oNearestAoE;
    int nCasterLevel = GetCasterLevel(oCreator);
    int nMetaMagic = GetMetaMagicFeat();
    int i = 1;

    nSpellId = (nSpellId == SPELL_ID_UNDEFINED) ? GetSpellId() : nSpellId;
    if(nCasterClass == GET_LAST_SPELL_CAST_CLASS)
    {
        nCasterClass = GetLastSpellCastClass();
    }

    switch(GetAoEShape(nAreaEffectId))
    {
        case SHAPE_SPHERE:
            if(GetObjectType(oCreator) == OBJECT_TYPE_CREATURE && (GetIsPC(oCreator) || !ALLOW_NPC_AOE_OVERLAP))
            {
                oNearestAoE = GetNearestObjectToLocation(OBJECT_TYPE_AREA_OF_EFFECT, lLocation, 1);
                while(GetIsObjectValid(oNearestAoE) && GetDistanceBetweenLocations(lLocation, GetLocation(oNearestAoE)) <= fAoERadius)
                {
                    if(GetAreaOfEffectCreator(oNearestAoE) == oCreator && GetAoEId(oNearestAoE) == nSpellId)
                    {
                        DestroyObject(oNearestAoE);
                        DestroyObject(GetAoEPartner(oNearestAoE));
                    }
                    i++;
                    oNearestAoE = GetNearestObjectToLocation(OBJECT_TYPE_AREA_OF_EFFECT, lLocation, i);
                }
            }
            break;
        case SHAPE_CUBE:
            // Logic for blade barrier and wall of fire would go here.
            break;
    }

    ApplyEffectAtLocation(nDurationType, EffectAreaOfEffect(nAreaEffectId, sOnEnterScript, sHeartbeatScript, sOnExitScript), lLocation, fDuration);
    if(!(nStaticVFX1 == VFX_NONE && nStaticVFX2 == VFX_NONE) || sStaticVFXTemplate != BLUEPRINT_STATIC_VFX)
    {
        oStaticVFX = _CreateStaticVFX(sSpellName, nSpellId, lLocation, fDuration, sStaticVFXTemplate, nStaticVFX1, nStaticVFX2);
    }
    DelayCommand(0.01, _UpdateAoEDataAtLocation(lLocation, nSpellId, oStaticVFX, nCasterLevel, nCasterClass, fDuration - 0.01, nMetaMagic));
}
//::///////////////////////////////////////////////
//:: GetAoEId
//:://////////////////////////////////////////////
/*
    Returns the AoE of the nonstacking AoE. The
    Id corresponds to the spell or ability
    used to create it.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On: February 1, 2016
//:://////////////////////////////////////////////
int GetAoEId(object oAoE)
{
    int nAoEId = GetLocalInt(oAoE, LIB_SPELLS_PREFIX + "NonStackingAoEId");

    // Value shift of one because we're moving the whole index upward, so as not to confuse
    // unassigned Ids with the Id of the 0th entry of spells.2da (i.e. acid fog).
    // If no Id is found, then the AoE was just created (i.e. this is being called from an
    // on enter script). Returning the value of GetEffectSpellId(EffectDazed()) tricks the
    // engine into assigning the AoE an Id we can use.
    return (nAoEId > 0) ? nAoEId - 1 : GetEffectSpellId(EffectDazed());
}
//::///////////////////////////////////////////////
//:: GetAoEPartner
//:://////////////////////////////////////////////
/*
    Returns the static VFX partner for the
    AoE, if one exists.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On: June 15, 2016
//:://////////////////////////////////////////////
object GetAoEPartner(object oAoE)
{
    return GetLocalObject(oAoE, LIB_SPELLS_PREFIX + "AoEPartner");
}
//::///////////////////////////////////////////////
//:: GetAoERadius
//:://////////////////////////////////////////////
/*
    Returns the radius of the AoE associated
    with nAreaEffectId.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On: January 30, 2016
//:://////////////////////////////////////////////
float GetAoERadius(int nAreaEffectId)
{
    return StringToFloat(Get2DAString("vfx_persistent", "RADIUS", nAreaEffectId));
}

//::///////////////////////////////////////////////
//:: GetAoEShape
//:://////////////////////////////////////////////
/*
    Returns the shape of the AoE associated with
    nAreaEffectId. Rectangular AoEs will return
    SHAPE_CUBE.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On: February 5, 2016
//:://////////////////////////////////////////////
int GetAoEShape(int nAreaEffectId)
{
    string sShape = Get2DAString("vfx_persistent", "SHAPE", nAreaEffectId);

    if(sShape == "C")
        return SHAPE_SPHERE;
    else if(sShape == "R")
        return SHAPE_CUBE;
    return SHAPE_UNDEFINED;
}


//::///////////////////////////////////////////////
//:: SetAoECastClass
//:://////////////////////////////////////////////
/*
    Overrides the cast class used for the
    existing AoE.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On: June 15, 2016
//:://////////////////////////////////////////////
void SetAoECastClass(object oAoE, int nClass)
{
    SetLocalInt(oAoE, LIB_SPELLS_PREFIX + "AoECastClass", nClass);
}

//::///////////////////////////////////////////////
//:: SetAoECasterLevel
//:://////////////////////////////////////////////
/*
    Overrides the caster level used for the
    existing AoE.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On: June 15, 2016
//:://////////////////////////////////////////////
void SetAoECasterLevel(object oAoE, int nCasterLevel)
{
    SetLocalInt(oAoE, LIB_SPELLS_PREFIX + "AoECasterLevel", nCasterLevel);
}

//::///////////////////////////////////////////////
//:: SetAoEId
//:://////////////////////////////////////////////
/*
    Sets an Id variable on the nonstacking AoE.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On: February 1, 2016
//:://////////////////////////////////////////////
void SetAoEId(object oAoE, int nId)
{
    // Value shift of one because we're moving the whole index upward, so as not to confuse
    // unassigned Ids with the Id of the 0th entry of spells.2da (i.e. acid fog).
    SetLocalInt(oAoE, LIB_SPELLS_PREFIX + "NonStackingAoEId", nId + 1);
}

//::///////////////////////////////////////////////
//:: SetAoEMetaMagic
//:://////////////////////////////////////////////
/*
    Overrides the metamagic feat used for the
    existing AoE.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On: July 21, 2016
//:://////////////////////////////////////////////
void SetAoEMetaMagic(object oAoE, int nMetaMagic)
{
    SetLocalInt(oAoE, LIB_SPELLS_PREFIX + "AoEMetaMagic", nMetaMagic);
}
//::///////////////////////////////////////////////
//:: ApplyTaggedEffectToObject
//:://////////////////////////////////////////////
/*
    Applies a tagged effect to the object.
    A tagged effect has a unique retrievable Id.
    Note that this should not be called from
    spell scripts, since tagged effects do not
    contain spell Id parameters and always apply
    as extraordinary effects.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On: February 22, 2016
//:://////////////////////////////////////////////
void ApplyTaggedEffectToObject(int nDurationType, effect eEffect, object oTarget, float fDuration = 0.0f, int nEffectTag = EFFECT_TAG_UNDEFINED)
{
    if(nEffectTag != EFFECT_TAG_UNDEFINED)
    {
      string sEffectTag = GetEffectTag(eEffect);

      // All effect tags are ints.  But stored as strings.
      // Use bitwise flags to allow us to apply multiple tags.
      int nCurrentTag = StringToInt(sEffectTag);

      // apply updated tag string
      eEffect = TagEffect(eEffect, IntToString(nCurrentTag | nEffectTag));
    }

    if(GetEffectSubType(eEffect) != SUBTYPE_SUPERNATURAL)
    {
        eEffect = ExtraordinaryEffect(eEffect);
    }

    ApplyEffectToObject(nDurationType, eEffect, oTarget, fDuration);
}

/**********************************************************************
 * PRIVATE FUNCTION DEFINITIONS
 **********************************************************************/

//::///////////////////////////////////////////////
//:: _CreateStaticVFX
//:://////////////////////////////////////////////
/*
    Creates a static VFX object, coupled with
    an AoE. This allows an AoE to appear to hold
    VFX that it naturally could not (e.g.
    glyph of warding).
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On: June 15, 2016
//:://////////////////////////////////////////////
object _CreateStaticVFX(string sName, int nId, location lLocation, float fDuration, string sStaticSourceTemplate, int nVFX1, int nVFX2)
{
    object oVFX = CreateObject(OBJECT_TYPE_PLACEABLE, sStaticSourceTemplate, lLocation, FALSE, "StaticVFX" + IntToString(nId));

    SetName(oVFX, sName);
    SetEventScript(oVFX, EVENT_SCRIPT_PLACEABLE_ON_HEARTBEAT, STATIC_VFX_ON_HEARTBEAT);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(nVFX1), oVFX, fDuration);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(nVFX2), oVFX, fDuration);
    AssignCommand(oVFX, DestroyObject(oVFX, fDuration));

    return oVFX;
}

//::///////////////////////////////////////////////
//:: _LinkAoEToStaticVFX
//:://////////////////////////////////////////////
/*
    Stores references on the AoE and static
    VFX to one another.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On: June 15, 2016
//:://////////////////////////////////////////////
void _LinkAoEToStaticVFX(object oAoE, object oVFX)
{
    _SetStaticVFXPartner(oVFX, oAoE);
    _SetAoEPartner(oAoE, oVFX);
}

//::///////////////////////////////////////////////
//:: _SetAoEPartner
//:://////////////////////////////////////////////
/*
    Stores a reference to the coupled static VFX
    on the AoE.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On: June 15, 2016
//:://////////////////////////////////////////////
void _SetAoEPartner(object oAoE, object oPartner)
{
    SetLocalObject(oAoE, LIB_SPELLS_PREFIX + "AoEPartner", oPartner);
}

//::///////////////////////////////////////////////
//:: _SetStaticVFXPartner
//:://////////////////////////////////////////////
/*
    Stores a reference to the coupled AoE on
    the static VFX.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On: June 15, 2016
//:://////////////////////////////////////////////
void _SetStaticVFXPartner(object oVFX, object oPartner)
{
    SetLocalObject(oVFX, LIB_SPELLS_PREFIX + "VFXPartner", oPartner);
}

//::///////////////////////////////////////////////
//:: _UpdateAoEDataAtLocation
//:://////////////////////////////////////////////
/*
    Sets the Id for the nonstacking AoE
    within 0.1m of the location.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On: February 1, 2016
//:://////////////////////////////////////////////
void _UpdateAoEDataAtLocation(location lLocation, int nId, object oStaticVFX, int nCasterLevel, int nCasterClass, float fDuration, int nMetaMagic)
{
    object oAoE = GetNearestObjectToLocation(OBJECT_TYPE_AREA_OF_EFFECT, lLocation);
    object oStaticVFX = GetNearestObjectByTag("StaticVFX" + IntToString(nId));

    if(GetDistanceBetweenLocations(lLocation, GetLocation(oAoE)) > 0.1)
        return;

    SetAoEId(oAoE, nId);
    SetAoECasterLevel(oAoE, nCasterLevel);
    SetAoECastClass(oAoE, nCasterClass);
    SetAoEMetaMagic(oAoE, nMetaMagic);
    ApplyTaggedEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneGhost(), oAoE, fDuration, EFFECT_TAG_DURATION_MARKER);
    if(oStaticVFX != OBJECT_INVALID)
    {
        _LinkAoEToStaticVFX(oAoE, oStaticVFX);
    }
}

//Función mejorada de Daz (NWNX), para preparar conjuros en las clases que necesitan memorizar un conjuro.
void ReadySingleMemorizedSpell(object oCreature, int nClassType, int nSpellId, int nMetaMagic = METAMAGIC_NONE);
void ReadySingleMemorizedSpell(object oCreature, int nClassType, int nSpellId, int nMetaMagic = METAMAGIC_NONE)
{
    int nSpellLevel = GetSpellLevelByClass(nClassType, nSpellId), nMM2DAConstant;
    if (nSpellLevel == -1) return;
    if (nMetaMagic)
    {
        switch (nMetaMagic)
        {
            case METAMAGIC_EMPOWER: nMM2DAConstant = 2; break;
            case METAMAGIC_EXTEND: nMM2DAConstant = 3; break;
            case METAMAGIC_MAXIMIZE: nMM2DAConstant = 4; break;
            case METAMAGIC_QUICKEN: nMM2DAConstant = 1; break;
            case METAMAGIC_SILENT: nMM2DAConstant = 5; break;
            case METAMAGIC_STILL: nMM2DAConstant = 6; break;
        }
        nSpellLevel += StringToInt(Get2DAString("metamagic", "LevelAdjustment", nMM2DAConstant));
    }
    int nSlot, nNumSlots = GetMemorizedSpellCountByLevel(oCreature, nClassType, nSpellLevel);
    for (nSlot = 0; nSlot < nNumSlots; nSlot++)
    {
        if (GetMemorizedSpellId(oCreature, nClassType, nSpellLevel, nSlot) == nSpellId &&
            !GetMemorizedSpellReady(oCreature, nClassType, nSpellLevel, nSlot) &&
            (!nMetaMagic || GetMemorizedSpellMetaMagic(oCreature, nClassType, nSpellLevel, nSlot) == nMetaMagic))
        {
            SetMemorizedSpellReady(oCreature, nClassType, nSpellLevel, nSlot, TRUE);
            break;
        }
    }
}

// Devuelve TRUE si el objeto tien un efecto con este tag
// - oPJ: Criatura en la que buscar el efecto
// - sTag: Tag del efecto
int PJ_EfectoBuscarTag(object oPJ, string sTag);
int PJ_EfectoBuscarTag(object oPJ, string sTag)
{
    effect eEff = GetFirstEffect(oPJ);
    while (GetIsEffectValid(eEff))
    {
        if (GetEffectTag(eEff)==sTag) return TRUE;
        eEff = GetNextEffect(oPJ);
    }
    return FALSE;
}

// Quita todos los efectos de una criatura
void PJ_EfectoQuitar(object oPJ);
void PJ_EfectoQuitar(object oPJ)
{
    effect eEff = GetFirstEffect(oPJ);
    while (GetIsEffectValid(eEff))
    {
        RemoveEffect(oPJ, eEff);
        eEff = GetNextEffect(oPJ);
    }
}

// Quita un efecto por su tag
// - oPJ: Criatura a la que hay que quitarle el efecto
// - sTag: Tag del efecto
void PJ_EfectoQuitarTag(object oPJ, string sTag);
void PJ_EfectoQuitarTag(object oPJ, string sTag)
{
    effect eEff = GetFirstEffect(oPJ);
    while (GetIsEffectValid(eEff))
    {
        if (GetEffectTag(eEff)==sTag)
        {RemoveEffect(oPJ, eEff);}
        eEff = GetNextEffect(oPJ);
    }
}

//void main(){}
