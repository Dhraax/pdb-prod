void main()
{
//::////////////////////////////////////////////////////////////////////////:://
//Modifica el danyo de frio que se aplicara al pj al entrar en el desncadenant
int iDanyo = d2(5);

//¿Cada cuantos segundos quieres que se aplike de nuevo el danyo de frio?
float fSegundos = 4.0;
//::////////////////////////////////////////////////////////////////////////:://

// Definimos al jugador que entre en el desencadenante
object oPC = GetEnteringObject();
// Definimos los efectos
effect eEfecto1 = EffectDamage(iDanyo, DAMAGE_TYPE_COLD, DAMAGE_POWER_NORMAL);
effect eEfecto2 = EffectVisualEffect(VFX_IMP_FROST_S);

if(GetIsPC(oPC) != TRUE) return;

// Si la variable se encuentra a 0...
if(GetLocalInt(oPC,"TME_TRAMPAFRIO") == 0)
     {
       // Fijar la variable a 1
       SetLocalInt(oPC,"TME_TRAMPAFRIO",1);

       // Aplicamos el danyo de frio y el fecto visual
       ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto1, oPC);
       ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto2, oPC);

       PlayVoiceChat(VOICE_CHAT_PAIN1, oPC);

       // Ejecutamos un script
       DelayCommand(fSegundos, ExecuteScript("tme_frio_exe",oPC));
     }
}

