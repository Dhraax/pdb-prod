void main()
{
object oPC = GetLastUsedBy();
string sTagWP = GetTag(OBJECT_SELF);
object theWaypoint = GetWaypointByTag(sTagWP);
//ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), oPC);
DelayCommand(1.0, AssignCommand(oPC, JumpToLocation(GetLocation(theWaypoint))));
}
