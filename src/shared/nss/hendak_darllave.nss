void AbrirCerrarUbicados()
{
DelayCommand(0.1, PlayAnimation(ANIMATION_PLACEABLE_OPEN));
DelayCommand(5.0, PlayAnimation(ANIMATION_PLACEABLE_CLOSE));
}

void main()
{
object oPC = GetLastUsedBy();
location lPuntoderuta = GetLocation(GetWaypointByTag("alcant_masabajo"));

AbrirCerrarUbicados();

if (GetAreaFromLocation(lPuntoderuta) == OBJECT_INVALID) return;

AssignCommand(oPC, ClearAllActions());
DelayCommand(1.5, AssignCommand(oPC, ActionJumpToLocation(lPuntoderuta)));
}
