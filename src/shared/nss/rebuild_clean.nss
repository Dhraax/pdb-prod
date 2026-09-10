/// ----------------------------------------------------------------------------
/// @system  Character Rebuild
/// @file    rebuild_clean
/// @author  Dhraax
/// @brief   Remove the replacement character tree and its new variable container.
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
            "Limpieza cancelada: el personaje debe tener exactamente un contenedor nuevo."
        );
        return;
    }

    int iCharacterId = GetLocalInt(oContainer, PWDB_VAR_CHARACTER_ID);
    if (!PWDB_CleanRebuildCharacter(oTarget))
    {
        SendMessageToPC(
            oDM,
            "ERROR: la base de datos no confirmo la limpieza. El contenedor se conserva."
        );
        SendMessageToPC(
            oTarget,
            "El proceso de rehecho se ha detenido por un error de base de datos."
        );
        WriteTimestampedLogEntry(
            "[PWDB:REBUILD] Cleanup refused or failed for character_id="
            + IntToString(iCharacterId) + "."
        );
        return;
    }

    DestroyObject(oContainer);
    DeleteLocalObject(oDM, "REBUILD_TARGET");
    SendMessageToPC(
        oDM,
        "Limpieza completada. Copia ahora el contenedor antiguo y usa Migrar personaje antes de que el jugador salga."
    );
    SendMessageToPC(
        oTarget,
        "Tu registro provisional ha sido limpiado. No salgas hasta que el DM complete la migracion."
    );
    WriteTimestampedLogEntry(
        "[PWDB:REBUILD] Cleaned provisional character_id="
        + IntToString(iCharacterId) + "."
    );
}
