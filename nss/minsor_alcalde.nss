void main()
{
  object oPC = GetLastUsedBy();
  object oDestino = GetWaypointByTag("minsor_alcaldesalida");

  // Teleport
  PlayAnimation(ANIMATION_PLACEABLE_OPEN);
  DelayCommand(1.0, PlayAnimation(ANIMATION_PLACEABLE_CLOSE));
  DelayCommand(0.1, AssignCommand(oPC, ClearAllActions()));
  DelayCommand(0.3, AssignCommand(oPC, JumpToObject(oDestino)));
}
