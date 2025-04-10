void main()
{
  object oPC = GetLastUsedBy();
  string corsario_golpedequilla = GetLockKeyTag(OBJECT_SELF);
  object oDestino = GetWaypointByTag("entrada_corsario");

  if(GetLocked(OBJECT_SELF) == TRUE)
  {
      if(GetItemPossessedBy(oPC, corsario_golpedequilla) == OBJECT_INVALID)
      {
          SendMessageToPC(oPC, "<cþ<<>*Deberías alquilar una habitación para poder pasar.*</c>");
          return;
      }

      SendMessageToPC(oPC, "<c´þd>*Abres con la llave previamente alquilada*</c>");
  }

  // Teleport
  DelayCommand(0.1, AssignCommand(oPC, ClearAllActions()));
  DelayCommand(0.2, AssignCommand(oPC, JumpToObject(oDestino)));
}

