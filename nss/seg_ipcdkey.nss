void main()
{
  object oDM = GetPCSpeaker();
  object oJugadorSeleccionado = GetLocalObject(oDM, "SEG_JUGADOR");
  string sNombre = GetName(oJugadorSeleccionado, TRUE);
  string sCuenta = GetPCPlayerName(oJugadorSeleccionado);

  if( GetName(oDM) != "Administrador") {
    FloatingTextStringOnCreature("Esta opción está restringida al administrador del servidor.", oDM);
    return;
  }

  SendMessageToPC(oDM, "<c!}þ>La IP de "+sNombre+" ("+sCuenta+") es "+GetPCIPAddress(oJugadorSeleccionado)+"</c>");
  SendMessageToPC(oDM, "<c!}þ>La CDKEY de "+sNombre+" ("+sCuenta+") es "+GetPCPublicCDKey(oJugadorSeleccionado)+"</c>");
}
