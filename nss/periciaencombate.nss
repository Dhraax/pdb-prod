#include "nw_i0_spells"
void main()
{
//dote_per
object oPC = OBJECT_SELF;
int iPC = GetLocalInt(oPC,"PC");
SpeakString("Pericia en combate");

if(GetLocalInt(oPC, "ATPod") == 0) {
    effect eCA = EffectACIncrease(iPC,AC_DODGE_BONUS);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,eCA,oPC);
    SetLocalInt(oPC,"ATPod",1);
} else if(GetLocalInt(oPC, "ATPod") == 1)
{
    effect eCA = EffectACIncrease(iPC,AC_DODGE_BONUS);
    SetLocalInt(oPC,"ATPod",0);
    RemoveSpecificEffect(EFFECT_TYPE_AC_INCREASE, oPC);
}

}
