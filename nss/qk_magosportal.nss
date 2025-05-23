void main()
{
object oPC = GetLastUsedBy();
location lWay = GetLocalLocation(oPC,"SALIDAMAGOS");

AssignCommand(oPC,JumpToLocation(lWay));
DelayCommand(4.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_2), lWay));
}
