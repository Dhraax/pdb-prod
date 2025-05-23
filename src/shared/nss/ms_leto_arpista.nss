//DOTES PASIVAS DEL ARPISTA

void main()
{

object oPC = OBJECT_SELF;

effect eSave = SupernaturalEffect(EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_SPELL));
ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSave, oPC);


}




