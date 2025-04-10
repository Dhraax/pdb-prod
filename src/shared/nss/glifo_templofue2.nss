void main()
{
    object oEnt = GetEnteringObject();
    object oGlifo = GetNearestObjectByTag("glifofuego2");

    if(GetIsPC(oEnt))
        {
        location loc = GetLocation(oEnt);
        int iDados = d20(9);
        effect eDamage = EffectDamage(iDados,DAMAGE_TYPE_FIRE);
        DelayCommand(1.0,AssignCommand(oGlifo,ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oEnt)));
        AssignCommand(oGlifo,ActionCastSpellAtObject(SPELL_DELAYED_BLAST_FIREBALL,oEnt,METAMAGIC_EMPOWER,TRUE,20,PROJECTILE_PATH_TYPE_DEFAULT,TRUE));
        AssignCommand(oGlifo,ActionCastSpellAtObject(SPELL_INCENDIARY_CLOUD,oEnt,METAMAGIC_EMPOWER,TRUE,20,PROJECTILE_PATH_TYPE_DEFAULT,TRUE));
        }
    else
        {
        return;
        }
}
