void main()
{
object oPC = GetPCSpeaker();
effect eDmg = EffectDamageIncrease(31,DAMAGE_TYPE_MAGICAL);
ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDmg, oPC);
}
