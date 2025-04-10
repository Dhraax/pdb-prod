void main()
{
object oMirar = GetWaypointByTag("nask_temlp_mirar_mano_2");
DelayCommand(1.0, AssignCommand(OBJECT_SELF, SetFacingPoint(GetPosition(oMirar))));
DelayCommand(6.0, AssignCommand(OBJECT_SELF, PlayAnimation(ANIMATION_LOOPING_TALK_PLEADING,1.0,7.0)));
}
