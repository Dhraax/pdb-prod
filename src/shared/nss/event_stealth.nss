/// -----------------------------------------------------------------------------
/// @system StealthControl
/// @file event_stealth.nss
/// @author Dhraax
/// @brief Controls Hide in Plain Sight feat usage, allowing rangers to use it
///        in natural areas at level 16+, and applying cooldowns and penalties.
/// -----------------------------------------------------------------------------

#include "nwnx_events"
#include "inc_timelock"
#include "mti_libreria"

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

/// @brief Main handler for NWNX stealth enter/exit events.
///        Validates Hide in Plain Sight usage and applies cooldowns/effects.
/// @returns void
void HandleStealthEvent();

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

void HandleStealthEvent()
{
    object oPC = OBJECT_SELF;
    string sCurrentEvent = NWNX_Events_GetCurrentEvent();

    int iRangerLevel = GetLevelByClass(CLASS_TYPE_RANGER, oPC);
    int bIsRanger = (iRangerLevel > 0);
    int bInNaturalArea = GetIsAreaNatural(GetArea(oPC));
    int bHasHiPSFeat = GetHasFeat(FEAT_HIDE_IN_PLAIN_SIGHT, oPC);
    int bCanUseHiPS = FALSE;

    if (sCurrentEvent == "NWNX_ON_STEALTH_ENTER_BEFORE")
    {
        // Determinar si el personaje puede usar HiPS
        if (!bIsRanger && bHasHiPSFeat)
        {
            // Personaje con dote, no es explorador ? HiPS sin restricciones
            bCanUseHiPS = TRUE;
        }
        else if (bIsRanger && iRangerLevel >= 16 && bInNaturalArea)
        {
            // Explorador 16+ en zona natural ? HiPS permitido con o sin dote
            bCanUseHiPS = TRUE;
        }

        if (bCanUseHiPS)
        {
            // Verificar cooldown
            if (GetIsTimelocked(oPC, "Ocultarse a Simple Vista"))
            {
                TimelockErrorMessage(oPC, "Ocultarse a Simple Vista");
                NWNX_Events_SkipEvent();
                return;
            }

            // Marcar HiPS activo y forzar uso (si no tiene la dote)
            SetLocalInt(oPC, "USE_HIPS", TRUE);
            NWNX_Events_SetEventResult("1");
        }
        else
        {
            // Entrar en sigilo normal sin HiPS
            NWNX_Events_SetEventResult("0");

            if (bIsRanger)
            {
                SendMessageToPC(oPC, ColorTexto("Ocultarse a simple vista del Explorador solo se aplica en zonas naturales.", TXT_COLOR_ROJO));
            }
        }
    }

    else if (sCurrentEvent == "NWNX_ON_STEALTH_EXIT_AFTER")
    {
        // Aplicar penalización si se usó HiPS
        if (GetLocalInt(oPC, "USE_HIPS"))
        {
            DeleteLocalInt(oPC, "USE_HIPS");

            SetTimelock(oPC, 6, "Ocultarse a Simple Vista", 0, 0);

            effect eSlowness = SupernaturalEffect(EffectMovementSpeedIncrease(-50));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlowness, oPC, 4.0);
        }
    }
}

void main()
{
    HandleStealthEvent();
}
