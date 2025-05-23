void main()
{
//::////////////////////////////////////////////////////////////////////////:://
//XAVI, LO DE SIEMPRE
//Modifica el danyo de acido que se aplicara al pj al entrar en el desncadenant
int iDanyo = 1;

//Modifica la frase que dira el pj al entrar en el desencadenante
string sTexto1 = "¡Argh! (¡Este aire es muy tóxico! Me cuesta respirar...)";

//¿Cada cuantos segundos quieres que se aplike de nuevo el danyo de acido?
float fSegundos = 1.0;
//::////////////////////////////////////////////////////////////////////////:://


// Definimos al jugador que entre en el desencadenante
object oPC = GetEnteringObject();
// Definimos los efectos
effect eEfecto1 = EffectDamage(iDanyo, DAMAGE_TYPE_ACID, DAMAGE_POWER_NORMAL);
effect eEfecto2 = EffectPoison(POISON_BLACK_LOTUS_EXTRACT);
effect eEfecto3 = EffectDisease(DISEASE_VERMIN_MADNESS);
effect eEfecto4 = EffectVisualEffect(VFX_IMP_POISON_L);

// Si la variable TRAMPACIDO se encuentra a 0...
if(GetLocalInt(oPC,"TRAMPACIDO") == 0)
     {
       // Fijar la variable a 1
       SetLocalInt(oPC,"TRAMPACIDO",1);

       // Aplicamos el danyo de acido
       ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto1, oPC);

       // Aplicamos la enfermedad, veneno, y efecto visual
       ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEfecto2, oPC); //CD 20
       ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEfecto3, oPC); //CD 13
       ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto4, oPC);

       // Mensajito en la cabeza del jugador
       AssignCommand(oPC, ActionSpeakString(sTexto1));

       // Ejecutamos un script
       DelayCommand(fSegundos, ExecuteScript("trmpa_acd_exe",oPC));
     }
}
