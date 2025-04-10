void main()
{
    object oEnt = GetEnteringObject();
    object oGlifo = GetNearestObjectByTag("glifofuego1");

    if(GetIsPC(oEnt))
        {
        int iDados = d20(7);
        effect eDamage = EffectDamage(iDados,DAMAGE_TYPE_FIRE);
        effect eVisual = EffectVisualEffect(54);
        DelayCommand(1.0,AssignCommand(oGlifo,ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oEnt)));
        DelayCommand(0.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,eVisual,oGlifo));
        }
    else
        {
        return;
        }
}
