void main()
{
  // No saturar
  if(GetLocalInt(OBJECT_SELF, "NOSATURAR") == 1) return;
  SetLocalInt(OBJECT_SELF, "NOSATURAR", 1);

  // Animaciones del PJ
  object oPC = GetLastUsedBy();
  AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 2.0));

  // Obtener variables
  string sNombreCadaver  = GetLocalString(OBJECT_SELF, "CAD_NOMBRE");
  string sResrefCadaver  = GetLocalString(OBJECT_SELF, "CAD_RESREF");
  object oJugadorMuerto  = GetLocalObject(OBJECT_SELF, "CAD_JUGADOR");
  object oCadaverJugador = GetLocalObject(GetModule(), "CAD_" + sNombreCadaver);

  // Funciones principales
  object oObjetoCadaver = CreateItemOnObject(sResrefCadaver, oPC);
  SetName(oObjetoCadaver, "Cadáver de " + sNombreCadaver);

  // Fijar variables
  SetLocalString(oObjetoCadaver, "CAD_NOMBRE", sNombreCadaver);
  SetLocalString(oObjetoCadaver, "CAD_RESREF", sResrefCadaver);
  SetLocalObject(oObjetoCadaver, "CAD_JUGADOR", oJugadorMuerto);
  SetLocalObject(GetModule(), "CAD_" + sNombreCadaver, oObjetoCadaver);

  // Destruir cadaveres
  DestroyObject(OBJECT_SELF, 2.0);
}
