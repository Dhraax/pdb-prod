void main()
{
//::////////////////////////////////////////////////////////////////////////:://
//Modifica el danyo de frio que se aplicara al pj al entrar en el desncadenant
int iDanyo = d2(5);

//¿Cada cuantos segundos quieres que se aplike de nuevo el danyo de frio?
float fSegundos = 4.0;
//::////////////////////////////////////////////////////////////////////////:://

// Definimos los efectos
effect eEfecto1 = EffectDamage(iDanyo, DAMAGE_TYPE_COLD, DAMAGE_POWER_NORMAL);
effect eEfecto2 = EffectVisualEffect(VFX_IMP_FROST_S);

// Si la variable se encuentra a 1...
if(GetLocalInt(OBJECT_SELF,"TME_TRAMPAFRIO") == 1)
    {
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto1, OBJECT_SELF);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto2, OBJECT_SELF);

      //Ejecutamos este mismo script
      DelayCommand(fSegundos, ExecuteScript("tme_frio_exe", OBJECT_SELF));
    }
}

