void main()
{

int iDano = d20()+20;
float fSegundos = 3.0;
effect eEfecto1 = EffectDamage(iDano, DAMAGE_TYPE_DIVINE, DAMAGE_POWER_ENERGY);
effect eEfecto2 = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY);

if(GetLocalInt(OBJECT_SELF,"ko_pupa_divina") == 1)
    {
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto1, OBJECT_SELF);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto2, OBJECT_SELF);
      DelayCommand(fSegundos, ExecuteScript("ko_danodivino", OBJECT_SELF));
    }
}

