/// ----------------------------------------------------------------------------
/// @system  Character Rebuild
/// @file    pwdb_mod_act
/// @author  Dhraax
/// @brief   Route the rebuild wand and delegate every other item activation.
/// ----------------------------------------------------------------------------

void main()
{
    object oDM = GetItemActivator();
    object oItem = GetItemActivated();
    object oTarget = GetItemActivatedTarget();
    string sItemTag = GetTag(oItem);

    if (sItemTag == "dmfi_rebuild")
    {
        if ((!GetIsDM(oDM) && !GetIsDMPossessed(oDM))
            || !GetIsObjectValid(oTarget) || !GetIsPC(oTarget)
            || GetIsDM(oTarget) || GetIsDMPossessed(oTarget))
        {
            SendMessageToPC(
                oDM,
                "La varita de rehechos solo puede usarla un DM sobre un jugador."
            );
            return;
        }

        SetLocalObject(oDM, "REBUILD_TARGET", oTarget);
        AssignCommand(oDM, ClearAllActions(TRUE));
        AssignCommand(
            oDM,
            ActionStartConversation(oDM, "rebuild_tool", TRUE, FALSE)
        );
        return;
    }

    ExecuteScript("pb_mod_activate", OBJECT_SELF);

    // The legacy DMFI generator creates the established tool set. Add this
    // independent rebuild wand after that generator completes.
    if (sItemTag == "dmfi_exploder"
        && (GetIsDM(oDM) || GetIsDMPossessed(oDM))
        && !GetIsObjectValid(GetItemPossessedBy(oDM, "dmfi_rebuild")))
    {
        CreateItemOnObject("dmfi_rebuild", oDM);
    }
}
