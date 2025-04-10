void AbrirCerrarUbicados()
{
DelayCommand(0.1, PlayAnimation(ANIMATION_PLACEABLE_OPEN));
DelayCommand(5.0, PlayAnimation(ANIMATION_PLACEABLE_CLOSE));
}

void main()
{
object oPC = GetLastUsedBy();
object oTarget = GetWaypointByTag("cdc_22");
location lTarget = GetLocation(oTarget);

AbrirCerrarUbicados();
DelayCommand(1.4, AssignCommand(oPC, ClearAllActions()));
DelayCommand(1.5, AssignCommand(oPC, ActionJumpToLocation(lTarget)));
}
