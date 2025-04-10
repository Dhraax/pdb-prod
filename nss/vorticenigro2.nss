void main()
{

object oPC = GetLastUsedBy();
object oPortal = GetNearestObjectByTag("ko_caminoempedrado_salidavortice");
DelayCommand(2.0,AssignCommand(oPC,ActionJumpToObject(oPortal)));
effect eDamage = EffectDamage(d10(2),DAMAGE_TYPE_NEGATIVE);
effect eSummon = EffectVisualEffect(VFX_FNF_SUMMON_EPIC_UNDEAD);
DelayCommand(1.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oPC));
ApplyEffectToObject(DURATION_TYPE_INSTANT,eSummon,oPC);
}


