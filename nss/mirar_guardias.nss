void main()
{
object oMirar = GetWaypointByTag("mirar_guardias_nask");
DelayCommand(1.0, AssignCommand(OBJECT_SELF, SetFacingPoint(GetPosition(oMirar))));
}
