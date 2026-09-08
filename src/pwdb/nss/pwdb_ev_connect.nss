/// ----------------------------------------------------------------------------
/// @system  PWDB Identity
/// @file    pwdb_ev_connect
/// @author  Dhraax
/// @brief   Reject unauthorized clients before the server-vault character list.
/// ----------------------------------------------------------------------------

#include "nwnx_events"
#include "pwdb_i_access"

void main()
{
    string sPlayerName = NWNX_Events_GetEventData("PLAYER_NAME");
    string sCdKey = NWNX_Events_GetEventData("CDKEY");
    string sIpAddress = NWNX_Events_GetEventData("IP_ADDRESS");
    int bIsDm = StringToInt(NWNX_Events_GetEventData("IS_DM"));
    int iResult = PWDB_AccessCheckConnection(
        sPlayerName,
        sCdKey,
        sIpAddress,
        bIsDm
    );

    if (iResult == PWDB_ACCESS_ALLOWED)
    {
        return;
    }

    PrintString("[PWDB:ACCESS] Pre-vault connection denied for key="
        + GetStringLeft(sCdKey, 4) + "*"
        + " result=" + IntToString(iResult));
    NWNX_Events_SkipEvent();
    NWNX_Events_SetEventResult(PWDB_AccessDenialMessage(iResult));
}
