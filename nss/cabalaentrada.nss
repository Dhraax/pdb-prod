void main()
{
  object oPC = GetLastUsedBy();
  string cabala_llave = GetLockKeyTag(OBJECT_SELF);
  object oDestino = GetWaypointByTag("entrada_cabala");

  if(GetLocked(OBJECT_SELF) == TRUE)
  {
      if(GetItemPossessedBy(oPC, cabala_llave) == OBJECT_INVALID)
      {
          FloatingTextStringOnCreature("*Parece que el faro esta cerrado.*", oPC);
          return;
      }

      SendMessageToPC(oPC, "<c´þd>*La puerta emite un sonido estridente y se abre ante ti.*</c>");
  }

  // Teleport
  PlayAnimation(ANIMATION_PLACEABLE_OPEN);
  DelayCommand(1.0, PlayAnimation(ANIMATION_PLACEABLE_CLOSE));
  DelayCommand(0.1, AssignCommand(oPC, ClearAllActions()));
  DelayCommand(0.3, AssignCommand(oPC, JumpToObject(oDestino)));
}
