void CreateObjectVoid(int nObjectType, string sTemplate, location lLoc, int bUseAppearAnimation = FALSE)
{
CreateObject(nObjectType, sTemplate, lLoc, bUseAppearAnimation);
}

void main()
{
//definimos objectos y constantes
object oPJ = GetLastSpeaker();
object oChico = GetObjectByTag("nino_planar_agua");
object oRey_agua = GetObjectByTag("rey_plan_agua");
object oSitio = GetObjectByTag("WP_nino_planar_agua_01");
location lSitio = GetLocation(GetObjectByTag("WP_nino_planar_agua_01"));

//definimos efectos
effect eTerremoto = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);
effect eCongelado = EffectVisualEffect(VFX_IMP_FROST_L);
effect eBrust = EffectVisualEffect(VFX_FNF_SOUND_BURST);
effect eImplos = EffectVisualEffect(VFX_FNF_IMPLOSION);
effect eAparece = EffectVisualEffect(VFX_FNF_SUMMON_GATE);

//el chico se convierte el monstruo...
ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eTerremoto, lSitio);
ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAparece, lSitio);
DestroyObject(oChico);
CreateObject(OBJECT_TYPE_CREATURE,"rey_plan_agua", lSitio);
ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eBrust, lSitio);
ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eImplos, lSitio);
DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eCongelado, oRey_agua));
DelayCommand(20.0, AssignCommand(oRey_agua, SpeakString("¡¡NO SALDRÁS DE ESTE SANTUARIO MORTAL!!")));
DelayCommand(40.0, AssignCommand(oRey_agua, SpeakString("¡¡MUEREEEEEEEEEE!!")));
DelayCommand(50.0, AssignCommand(oRey_agua, SpeakString("¡¡EL PLANO AQUAR SERA TU HOGAR JAJAJJAJA!!")));
DelayCommand(100.0, AssignCommand(oRey_agua, SpeakString("¡¡UOOOOOO NOOOO AAAAAJJJJJJ!!")));
}
