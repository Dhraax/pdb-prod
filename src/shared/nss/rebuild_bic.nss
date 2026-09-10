/// ----------------------------------------------------------------------------
/// @system  Character Rebuild
/// @file    rebuild_bic
/// @author  Dhraax
/// @brief   Delete only the player BIC after DM-authorized confirmation.
/// ----------------------------------------------------------------------------

#include "nwnx_admin"

void DeleteRebuildBic(object oPC)
{
    NWNX_Administration_DeletePlayerCharacter(oPC, FALSE);
}

void main()
{
    object oPC = GetPCSpeaker();
    object oAuthorizingDM = GetLocalObject(oPC, "REBUILD_AUTHORIZING_DM");
    if (!GetIsObjectValid(oAuthorizingDM)
        || (!GetIsDM(oAuthorizingDM) && !GetIsDMPossessed(oAuthorizingDM)))
    {
        SendMessageToPC(oPC, "El borrado no ha sido autorizado por un DM.");
        WriteTimestampedLogEntry(
            "[PWDB:REBUILD] Refused an unauthorized BIC deletion."
        );
        return;
    }

    DeleteLocalObject(oPC, "REBUILD_AUTHORIZING_DM");
    FadeToBlack(oPC);
    SetCommandable(FALSE, oPC);
    AssignCommand(oPC, ClearAllActions(TRUE));

    WriteTimestampedLogEntry(
        "[PWDB:REBUILD] Deleted BIC only for PC=" + GetName(oPC, TRUE)
        + " account=" + GetPCPlayerName(oPC)
        + " cdkey=" + GetStringLeft(GetPCPublicCDKey(oPC), 4) + "*."
    );
    DelayCommand(4.0, DeleteRebuildBic(oPC));
}
