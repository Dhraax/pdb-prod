void main()
{
//::////////////////////////////////////////////////////////////////////////:://
//XAVI, LO DE SIEMPRE
//Modifica el danyo de acido que se aplicara al pj al entrar en el desncadenant
int iDanyo = 1;

//¿Cada cuantos segundos quieres que se aplike de nuevo el danyo de acido?
float fSegundos = 1.0;
//::////////////////////////////////////////////////////////////////////////:://

// Definimos los efectos
effect eEfecto1 = EffectDamage(iDanyo, DAMAGE_TYPE_ACID, DAMAGE_POWER_NORMAL);
effect eEfecto2 = EffectVisualEffect(VFX_IMP_POISON_L);

// Si la variable TRAMPACIDO se encuentra a 1...
if(GetLocalInt(OBJECT_SELF,"TRAMPACIDO") == 1)
    {
      // Se aplica el danyo de acido y el efecto visual
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto1, OBJECT_SELF);
      //ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto2, OBJECT_SELF);

      // Ejecutamos este mismo script
      DelayCommand(fSegundos, ExecuteScript("trmpa_acd_exe", OBJECT_SELF));
    }
}
