#include "mti_libreria"
void main()
{
//definimos objectos y efectos
object oPC = GetEnteringObject();
object oMaga = GetObjectByTag("ZaraanaHyrrshas");
object oFuera = GetWaypointByTag("salida_maga_zs");
effect eParalizar1 = EffectVisualEffect(VFX_DUR_PARALYZED);
effect eParalizar2 = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);
effect eEfectoFinal = EffectVisualEffect(VFX_IMP_SPELL_MANTLE_USE);
effect eHand1 = EffectVisualEffect(VFX_DUR_BIGBYS_CRUSHING_HAND);
object oArmario = GetObjectByTag("armario_entrada_zs");
//paralizamos al PJ y ponemos los efectos y iniciamos la conversacion

if(ObtenerIntPersistente(oPC, "MAGA_ENTRADA_YA") != 1)
{
   DelayCommand(0.0, SetCommandable(FALSE, oPC));
   DelayCommand(0.5, GuardarIntPersistente(oPC, "MAGA_ENTRADA_YA", 1));
   DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eParalizar1, oPC, 30.0));
   DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eParalizar2, oPC, 32.0));
   DelayCommand(2.5, AssignCommand(oMaga, PlayAnimation(ANIMATION_LOOPING_CONJURE2, 2.0, 3.0)));
   DelayCommand(3.5, AssignCommand(oMaga, PlaySound("vs_chant_illu_lf")));
   DelayCommand(4.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHand1, oPC, 34.0));
   DelayCommand(5.5, AssignCommand(oMaga, SpeakString("¡¡¡Como te atreves a entrar en mis aposentos!!!")));
   DelayCommand(7.5, AssignCommand(oMaga, SpeakString("¡¡¡Pero tú sabes quién soy yo!!!")));
   DelayCommand(13.5, AssignCommand(oMaga, SpeakString("¡¡¡Maldito portero no se porqué lo contraté, no sirve para nada!!!")));
   DelayCommand(18.5, AssignCommand(oMaga, SpeakString("¡¡¡Estás en mi casa y bajo mi control... Ahora te desataré de los hechizos, pero si intentas algo peligroso te mataré sin dudarlo...")));
   DelayCommand(26.5, AssignCommand(oMaga, SpeakString("Tendrás que darme una buena explicación de porqué te has molestado en llegar hasta aquí...")));
   DelayCommand(27.5, AssignCommand(oMaga, PlayAnimation(ANIMATION_LOOPING_CONJURE2, 2.0, 15.0)));
   DelayCommand(28.5, AssignCommand(oMaga, PlaySound("vs_chant_illu_hm")));
   DelayCommand(30.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfectoFinal, oPC));
   DelayCommand(37.5, AssignCommand(oMaga, PlayAnimation(ANIMATION_LOOPING_CONJURE2, 2.0, 5.0)));
   DelayCommand(32.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfectoFinal, oPC));
   DelayCommand(38.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfectoFinal, oPC));
   DelayCommand(39.0, SetCommandable(TRUE,oPC));
   }
}
