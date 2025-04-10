void AbrirCerrarUbicados()
{
DelayCommand(0.1, PlayAnimation(ANIMATION_PLACEABLE_OPEN));
DelayCommand(5.0, PlayAnimation(ANIMATION_PLACEABLE_CLOSE));
}

void main()
{
object oPC = GetLastUsedBy();

AbrirCerrarUbicados();
DelayCommand(1.5, AssignCommand(oPC, JumpToLocation(GetLocation(GetObjectByTag ("salidakossut")))));
{
DelayCommand(3.0, AssignCommand(OBJECT_SELF, ActionCloseDoor(OBJECT_SELF)));
}
}
