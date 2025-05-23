//Desencadenante de fuego

void Quema(object oTarget)
{
effect eFuego = EffectDamage(2, DAMAGE_TYPE_FIRE);
effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
effect eLink = EffectLinkEffects(eFuego,eVis);
if (GetIsObjectValid(oTarget) && !GetIsDM(oTarget)) ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
if(GetLocalInt(oTarget, "QUEMA") == 1 ) DelayCommand(12.0, Quema(oTarget));
}

void main()
{
 object oTarget = GetEnteringObject();
 if(!GetIsPC(oTarget) || GetIsDM(oTarget)) return;

 SetLocalInt(oTarget, "QUEMA", 1);
 Quema(oTarget);
}
