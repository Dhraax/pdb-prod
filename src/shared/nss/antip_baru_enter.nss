void main()
{
int iProb = d10(1);
object oPC = GetEnteringObject();


if (iProb <= 3)
    {
    effect aoe1 = EffectAreaOfEffect(AOE_PER_FOGKILL);
    //effect aoe2 = EffectAreaOfEffect(AOE_PER_FOG_OF_BEWILDERMENT);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,aoe1,GetLocation(oPC),10.0);
    //ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,aoe2,GetLocation(oPC),10.0);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectPoison(POISON_IRON_GOLEM), oPC);

    }
}
