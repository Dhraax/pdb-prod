void main()
{
object oPC = GetEnteringObject ();
int iAli = GetAlignmentGoodEvil(oPC);

if(iAli == ALIGNMENT_EVIL && GetIsPC (oPC) == TRUE)

{

effect emalo  = EffectVisualEffect (57 );
effect ecurse = EffectCurse ( 4, 4, 4, 4, 4, 4);

SendMessageToPC (oPC, "*Sientes un tremendo malestar al adentrarte en estas aguas feericas*");
DelayCommand (2.0, ApplyEffectToObject (DURATION_TYPE_INSTANT, emalo, oPC));
DelayCommand (2.5, ApplyEffectToObject (DURATION_TYPE_PERMANENT, ecurse , oPC));

}

if (
(iAli == ALIGNMENT_GOOD || iAli == ALIGNMENT_NEUTRAL) &&
(GetIsPC (oPC) == TRUE))

{

effect eRegenerate = SupernaturalEffect(EffectRegenerate (1, 1.0));
SendMessageToPC (oPC, "*Sientes gran bienestar al adentrarte en estas aguas feericas*");
DelayCommand (2.5, ApplyEffectToObject (DURATION_TYPE_PERMANENT, eRegenerate, oPC));

}

}
