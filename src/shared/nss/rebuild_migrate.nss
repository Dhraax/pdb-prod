/// ----------------------------------------------------------------------------
/// @system  Character Rebuild
/// @file    rebuild_migrate
/// @author  Dhraax
/// @brief   Rebind a replacement BIC to the identity in the restored container.
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

    int iContainerCount = ContarItemsInventario(oTarget, CONTENEDOR_VARIABLES);
    object oContainer = GetItemPossessedBy(oTarget, CONTENEDOR_VARIABLES);
    if (iContainerCount != 1 || !GetIsObjectValid(oContainer))
    {
        SendMessageToPC(
            oDM,
            "Migracion cancelada: copia primero exactamente un contenedor antiguo."
        );
        return;
    }

    int iCharacterId = GetLocalInt(oContainer, PWDB_VAR_CHARACTER_ID);
    if (!PWDB_MigrateRebuiltCharacter(oTarget))
    {
        SendMessageToPC(
            oDM,
            "ERROR: no se pudo migrar. Comprueba la limpieza previa, el contenedor y la cuenta/CD key."
        );
        SendMessageToPC(
            oTarget,
            "La migracion del personaje no se ha completado. No salgas del servidor."
        );
        WriteTimestampedLogEntry(
            "[PWDB:REBUILD] Migration refused or failed for character_id="
            + IntToString(iCharacterId) + "."
        );
        return;
    }

    PWDB_SyncRegisteredCharacter(oTarget, iCharacterId);
    DeleteLocalObject(oDM, "REBUILD_TARGET");

    SendMessageToPC(oDM, "Migracion completada correctamente.");
    SendMessageToPC(oTarget, "El rehecho ha sido migrado correctamente.");
    WriteTimestampedLogEntry(
        "[PWDB:REBUILD] Migrated replacement UUID to character_id="
        + IntToString(iCharacterId) + "."
    );
}
