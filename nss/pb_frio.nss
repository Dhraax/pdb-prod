//Desencadenante de fuego

void Frio(object oTarget)
{
effect eFrio = EffectDamage(2, DAMAGE_TYPE_COLD);
effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
effect eLink = EffectLinkEffects(eFrio,eVis);
if (GetIsObjectValid(oTarget) && !GetIsDM(oTarget)) ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
if(GetLocalInt(oTarget, "FRIO") == 1 ) DelayCommand(12.0, Frio(oTarget));
}

void main()
{
 object oTarget = GetEnteringObject();
 if(!GetIsPC(oTarget) || GetIsDM(oTarget)) return;

 SetLocalInt(oTarget, "FRIO", 1);
 Frio(oTarget);
}
