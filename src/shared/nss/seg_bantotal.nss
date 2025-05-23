void main()
{
  object oDM = GetPCSpeaker();
  object oMod = GetModule();
  object oJugadorSeleccionado = GetLocalObject(oDM, "SEG_JUGADOR");
  string sNombre = GetName(oJugadorSeleccionado, TRUE);
  string sCuenta = GetPCPlayerName(oJugadorSeleccionado);
  string sCdKey = GetPCPublicCDKey(oJugadorSeleccionado);
  string sIP = GetPCIPAddress(oJugadorSeleccionado);

  WriteTimestampedLogEntry("[BANEO HASTA EL PROXIMO REINICIO] La cdkey "+sCdKey+" y la IP "+sIP+" han sido baneadas hasta el próximo reinicio. PJ: "+sNombre+" ("+sCuenta+").");
  SendMessageToAllDMs("[BANEO HASTA EL PROXIMO REINICIO] La cdkey "+sCdKey+" y la IP "+sIP+" han sido baneadas hasta el próximo reinicio. PJ: "+sNombre+" ("+sCuenta+").");
  FloatingTextStringOnCreature("¡Serás baneado hasta el próximo reinicio!", oJugadorSeleccionado, FALSE);
  SetLocalInt(oMod, "SEG_BANCDKEY_" + sCdKey, TRUE);
  SetLocalInt(oMod, "SEG_BANIP_" + sIP, TRUE);
  DelayCommand(2.5, BootPC(oJugadorSeleccionado));
}
