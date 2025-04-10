void main()
{

object oPC = GetEnteringObject();

if (!GetIsPC(oPC)) return;

effect eEffect = EffectDamage(d20(1), DAMAGE_TYPE_FIRE, DAMAGE_POWER_NORMAL);

ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, oPC);

}

