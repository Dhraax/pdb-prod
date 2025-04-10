void main()
{
//definimos objectos y constantes
string sTexto ="*el cuerpo se te paraliza*";
string sCreature = "rey_plan_agua";
object oPJ = GetLastSpeaker();
object oChico = GetObjectByTag("nino_planar_agua");
object oSitio = GetObjectByTag("WP_nino_planar_agua_01");
location lSitio = GetLocation(GetObjectByTag("WP_nino_planar_agua_01"));
object oRey_agua = GetObjectByTag("rey_plan_agua");
//declaro efectos
effect eMuerte = EffectDeath();
effect eParaliza = EffectCutsceneParalyze();
effect eParalizado = EffectVisualEffect(VFX_DUR_PARALYZED);
effect eMiedo = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
effect eFx_Rojo = EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MAJOR);
//empieza lo bueno...
DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eParaliza, oPJ, 10.0));
DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eParalizado, oPJ, 10.0));
DelayCommand(3.0, FloatingTextStringOnCreature(sTexto, oPJ));
DelayCommand(4.0, AssignCommand(oChico, SpeakString("¡¡¡Dame la mano, tengo miedoooo!!!")));
DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMiedo, oPJ));
DelayCommand(8.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFx_Rojo, oPJ));
DelayCommand(10.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMuerte, oPJ));
//el chico te avisa...
DelayCommand(11.0, AssignCommand(oChico, SpeakString("¡¡¡Qué ocurre se encuentra bien!!!")));
}
