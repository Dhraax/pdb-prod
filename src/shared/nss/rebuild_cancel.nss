/// ----------------------------------------------------------------------------
/// @system  Character Rebuild
/// @file    rebuild_cancel
/// @author  Dhraax
/// @brief   Cancel a pending player-side BIC deletion confirmation.
/// ----------------------------------------------------------------------------

void main()
{
    object oPC = GetPCSpeaker();
    DeleteLocalObject(oPC, "REBUILD_AUTHORIZING_DM");
}
