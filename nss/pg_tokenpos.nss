int StartingConditional()
{
  object oPC = GetPCSpeaker();
  object oCadaverObjetoInventario = GetLocalObject(oPC, "CAD_USADO");
  object oCadaverJugadorMuerto  = GetLocalObject(oCadaverObjetoInventario, "CAD_JUGADOR");
  object oAreaCadaverJugadorMuerto = GetArea(oCadaverJugadorMuerto);
  string sAreaCadaverJugadorMuerto = GetTag(oAreaCadaverJugadorMuerto);
  int iAnimacionesPlanoFuga = GetLocalInt(oCadaverJugadorMuerto, "ANIMACIONES_PLANO_FUGA");

  // Mensajes de error
  if(sAreaCadaverJugadorMuerto != "plano_fuga" || oAreaCadaverJugadorMuerto == OBJECT_INVALID)
  {
      SendMessageToPC(oPC, "<cþ>El jugador al que intentas resucitar no se encuentra en el Plano de la Fuga (está desconectado del servidor o cargando área). No puedes resucitarlo.</c>");
      return FALSE;
  }

  if(iAnimacionesPlanoFuga == TRUE)
  {
      SendMessageToPC(oPC, "<cþ>El jugador al que intentas resucitar se encuentra reproduciendo la secuencia cinematográfica de entrada al Plano de la Fuga (la cual dura 50 segundos). Por favor, intenta resucitarlo unos segundos más tarde.</c>");
      return FALSE;
  }

  // Calculo tokens
  int iNivel = GetHitDice(oCadaverJugadorMuerto);
  int iOroRevivir = 250 * iNivel;
  int iOroResurreccion = 500 * iNivel;
  string sRevivir = IntToString(iOroRevivir);
  string sResurreccion = IntToString(iOroResurreccion);

  SetCustomToken(667, sRevivir);
  SetCustomToken(668, sResurreccion);

  return TRUE;
}
