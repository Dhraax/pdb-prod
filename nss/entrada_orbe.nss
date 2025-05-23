void main()
{
  object oPC = GetLastUsedBy();
  string Orbe_llave = GetLockKeyTag(OBJECT_SELF);
  object oDestino = GetWaypointByTag("entrada_torreorbe");

  if(GetLocked(OBJECT_SELF) == TRUE)
  {
      if(GetItemPossessedBy(oPC, Orbe_llave) == OBJECT_INVALID)
      {
          SendMessageToPC(oPC, "<cþ<<>*Empujas la puerta pero esta no se abre.*</c>");
          return;
      }

      SendMessageToPC(oPC, "<c´þd>*La puerta te reconoce y se abre ante ti*</c>");
  }

  // Teleport
  PlayAnimation(ANIMATION_PLACEABLE_OPEN);
  DelayCommand(1.0, PlayAnimation(ANIMATION_PLACEABLE_CLOSE));
  DelayCommand(0.1, AssignCommand(oPC, ClearAllActions()));
  DelayCommand(0.3, AssignCommand(oPC, JumpToObject(oDestino)));
}
