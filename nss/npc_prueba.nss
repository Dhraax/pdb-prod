void main()
{
object oNPC = OBJECT_SELF;
effect oQuietoparao = EffectParalyze();
effect oInfinita = EffectTemporaryHitpoints(999999999999999999999);
ApplyEffectToObject(DURATION_TYPE_PERMANENT,oInfinita,oNPC);
ApplyEffectToObject(DURATION_TYPE_PERMANENT,oQuietoparao,oNPC);

}
