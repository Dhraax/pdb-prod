/// ----------------------------------------------------------------------------
/// @system  Character Rebuild
/// @file    pwdb_mod_act
/// @author  Dhraax
/// @brief   Route the rebuild wand and delegate every other item activation.
/// ----------------------------------------------------------------------------

#include "pwdb_i_user"

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

        // Say it at the first touch rather than only when the deletion is
        // requested. Only a stored zero is announced: a replacement character
        // between cleanup and migration has no row to read, and the steps
        // that follow still refuse or allow on their own.
        if (PWDB_GetRebuildsAvailable(oTarget) == 0)
        {
            SendMessageToPC(oDM, GetName(oTarget)
                + " no tiene rehechos disponibles.");
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
