/// ----------------------------------------------------------------------------
/// @system NWNX_ON_CAST_SPELL_BEFORE
/// @file event_castbefore.nss
/// @author Dhraax
/// @brief Checks for IMMUNE_MAGIC before a spell is cast, cancels the effect if needed.
/// ----------------------------------------------------------------------------

#include "nwnx_events"
#include "nwnx"

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

/// @brief Checks if the target has IMMUNE_MAGIC and cancels the spell if so.
/// @param oCaster The creature casting the spell
/// @param oTarget The intended target of the spell
void HandleImmuneMagicCheck(object oCaster, object oTarget);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

void HandleImmuneMagicCheck(object oCaster, object oTarget)
{
    string sTargetTag = GetTag(oTarget);
    string sCasterName = GetName(oCaster);

    int iImmune = GetLocalInt(oTarget, "IMMUNE_MAGIC");

    if (iImmune == TRUE)
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_GLOBE_USE), oTarget);

        if (GetIsPC(oCaster))
        {
            SendMessageToPC(oCaster, "<c´$$>El hechizo no surte efecto. La criatura parece inmune a la magia.</c>");
        }

        NWNX_Events_SkipEvent();
    }
}

void main()
{
    
    string sCurrentEvent = NWNX_Events_GetCurrentEvent();
    object oCaster = OBJECT_SELF;
    object oTarget = StringToObject(NWNX_Events_GetEventData("TARGET_OBJECT_ID"));
    object oItem = StringToObject(NWNX_Events_GetEventData("ITEM_OBJECT_ID"));
    int iSpell = StringToInt(NWNX_Events_GetEventData("SPELL_ID"));


    HandleImmuneMagicCheck(oCaster, oTarget);

}