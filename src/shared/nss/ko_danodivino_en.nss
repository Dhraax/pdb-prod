//En el OnEnter del desencadenante
void main()
{
//Pupa que se hace
int iDano = d20()+20;
//Tiempo entre pupa y pupa
float fSegundos = 1.0;
// Definimos al jugador y los efectos
object oPC = GetEnteringObject();
effect eEfecto1 = EffectDamage(iDano, DAMAGE_TYPE_DIVINE, DAMAGE_POWER_ENERGY);
effect eEfecto2 = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY);

if(GetIsPC(oPC) != TRUE) return;

// Si la variable se encuentra a 0...
if(GetLocalInt(oPC,"ko_pupa_divina") == 0)
     {
       // Fijar la variable a 1
       SetLocalInt(oPC,"ko_pupa_divina",1);

       // Aplicamos el danyo de frio y el fecto visual
       ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto1, oPC);
       ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto2, oPC);
       PlayVoiceChat(VOICE_CHAT_PAIN1, oPC);

       // Ejecutamos el script de seguir haciendo dao
       DelayCommand(fSegundos, ExecuteScript("ko_danodivino",oPC));
     }
}
