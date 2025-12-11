#include "mti_libreria"
#include "x3_inc_string"

void main()
{
  object oDM = GetPCSpeaker();
  object oJugadorSeleccionadoSeg = GetLocalObject(oDM, "SEG_JUGADOR");
  string sCDKeyNueva = GetPCPublicCDKey(oJugadorSeleccionadoSeg);

  // Verificar si el personaje esta bloqueado por el sistema de seguridad
  if(GetLocalInt(oJugadorSeleccionadoSeg, "SEG_BLOQUEADO") == TRUE)
  {
        // DESBLOQUEAR PERSONAJE
        WriteTimestampedLogEntry("[SEGURIDAD] DM " + GetName(oDM) + " ha desbloqueado al PJ: " + GetName(oJugadorSeleccionadoSeg, TRUE) + " | Nueva CDKey: " + sCDKeyNueva);

        // Actualizar CDKey y eliminar bloqueo
        GuardarStringPersistente(oJugadorSeleccionadoSeg, "CDKEY", sCDKeyNueva);
        DeleteLocalInt(oJugadorSeleccionadoSeg, "SEG_BLOQUEADO");
        // Quitar parálisis
        effect e = GetFirstEffect(oJugadorSeleccionadoSeg);
        while (GetIsEffectValid(e))
        {
            if (GetEffectType(e) == EFFECT_TYPE_CUTSCENE_PARALYZE)
                RemoveEffect(oJugadorSeleccionadoSeg, e);
            e = GetNextEffect(oJugadorSeleccionadoSeg);
        }

        // Restaurar control
        SetCommandable(TRUE, oJugadorSeleccionadoSeg);

        // Restaurar paneles
        SetGuiPanelDisabled(oJugadorSeleccionadoSeg, GUI_PANEL_INVENTORY, FALSE);

        // Mensajes al DM
        SendMessageToPC(oDM, StringToRGBString("------------------------------", "070"));
        SendMessageToPC(oDM, StringToRGBString("El personaje " + GetName(oJugadorSeleccionadoSeg) + " ha sido DESBLOQUEADO correctamente.", "070"));
        SendMessageToPC(oDM, StringToRGBString("------------------------------", "070"));

        // Mensaje al jugador
        SendMessageToPC(oJugadorSeleccionadoSeg, StringToRGBString("------------------------------", "070"));
        SendMessageToPC(oJugadorSeleccionadoSeg, StringToRGBString("Tu personaje ha sido DESBLOQUEADO por un DM.", "070"));
        SendMessageToPC(oJugadorSeleccionadoSeg, StringToRGBString("Ya puedes jugar con normalidad.", "070"));
        SendMessageToPC(oJugadorSeleccionadoSeg, StringToRGBString("------------------------------", "070"));
  }
  else
  {
    // El personaje NO esta bloqueado

    SendMessageToPC(oDM, StringToRGBString("Este personaje no está bloqueado por el sistema de seguridad.", "770"));
  }
}
