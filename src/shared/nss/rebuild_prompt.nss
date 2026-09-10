/// ----------------------------------------------------------------------------
/// @system  Character Rebuild
/// @file    rebuild_prompt
/// @author  Dhraax
/// @brief   Ask the selected player to confirm deletion of the current BIC.
/// modified by: Dhraax
/// ----------------------------------------------------------------------------

#include "pwdb_i_user"

void main()
{
    object oDM = GetPCSpeaker();
    object oTarget = GetLocalObject(oDM, "REBUILD_TARGET");

    if ((!GetIsDM(oDM) && !GetIsDMPossessed(oDM))
        || !GetIsObjectValid(oTarget) || !GetIsPC(oTarget)
        || GetIsDM(oTarget) || GetIsDMPossessed(oTarget))
    {
        SendMessageToPC(oDM, "No hay un personaje jugador valido seleccionado.");
        return;
    }

    int iRebuildsAvailable = PWDB_GetRebuildsAvailable(oTarget);
    if (iRebuildsAvailable <= 0)
    {
        SendMessageToPC(
            oDM,
            iRebuildsAvailable == 0
                ? "El personaje no tiene rehechos disponibles."
                : "No se pudo consultar el contador de rehechos. No se borrara el BIC."
        );
        return;
    }

    SetLocalObject(oTarget, "REBUILD_AUTHORIZING_DM", oDM);
    AssignCommand(oTarget, ClearAllActions(TRUE));
    AssignCommand(
        oTarget,
        ActionStartConversation(oTarget, "rebuild_confirm", TRUE, FALSE)
    );
    SendMessageToPC(oDM, "Se ha enviado la confirmacion de borrado al jugador.");
}
