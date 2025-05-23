void main()
{
object oUser = GetLastUsedBy();

if(!GetIsPC(oUser)) return;

ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH_WARD), oUser);
DelayCommand(1.2, AssignCommand(oUser, ClearAllActions()));
DelayCommand(1.3, AssignCommand(oUser, JumpToObject(GetWaypointByTag("salida_drowcleric"))));
DeleteLocalInt(GetModule(), "THORMALLEMOCUPAO2");
DeleteLocalInt(oUser, "ESTOYENTHORMALLEM2");
}
