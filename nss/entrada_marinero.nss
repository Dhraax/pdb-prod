void main()
{
  object oPC = GetLastUsedBy();
  string marinero_golpedequilla = GetLockKeyTag(OBJECT_SELF);
  object oDestino = GetWaypointByTag("entrada_marinero");

  if(GetLocked(OBJECT_SELF) == TRUE)
  {
      if(GetItemPossessedBy(oPC, marinero_golpedequilla) == OBJECT_INVALID)
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

