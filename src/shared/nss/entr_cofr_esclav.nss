void main()
{
  object oTarget = GetWaypointByTag("Entr_cofr_esclav");
  location lTarget = GetLocation(oTarget);
  object oPC = GetLastUsedBy();

  if(!GetIsPC(oPC)) return;

  if(GetLocalInt(OBJECT_SELF, "ABRIR_PUER_ESCLAV") == 1)
  {
      AssignCommand(oPC, ClearAllActions());
      AssignCommand(oPC, ActionJumpToLocation(lTarget));
      SendMessageToPC(oPC, "<c´þd>Entras en la cofradía de los esclavistas, un silencio sepulcral invade la sala.</c>");
      return;
  }

  if(GetItemPossessedBy(oPC, "qt_tabacoi2") != OBJECT_INVALID)
  {
      PlayAnimation(ANIMATION_PLACEABLE_OPEN);
      DelayCommand(25.0, PlayAnimation(ANIMATION_PLACEABLE_CLOSE));
      SetLocalInt(OBJECT_SELF, "ABRIR_PUER_ESCLAV", 1);
      DelayCommand(25.0, DeleteLocalInt(OBJECT_SELF, "ABRIR_PUER_ESCLAV"));
      AssignCommand(oPC, ClearAllActions());
      AssignCommand(oPC, ActionJumpToLocation(lTarget));
      SendMessageToPC(oPC, "<c´þd>Entras en la cofradía de los esclavistas, un silencio sepulcral invade la sala.</c>");
  }
  else
  {
      FloatingTextStringOnCreature("<cþ<<>No estoy autorizado a entrar en este lugar.</c>", oPC);
  }
}
