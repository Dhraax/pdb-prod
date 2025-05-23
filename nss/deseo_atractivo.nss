#include "mti_libreria"
void main()
{
  object oPC = GetPCSpeaker();

  // Ifriti ya usado
  SetLocalInt(OBJECT_SELF, "IFRITIUSADO", 1);

  // Solo se pide un deseo una vez
  int iDeseoAtractivo = ObtenerIntPersistente(oPC, "DESEO_ATRACTIVO");
  if(iDeseoAtractivo == 1)
  {
      AssignCommand(OBJECT_SELF, SpeakString("¡Pero si ya te dije alguna vez que no hacía milagros, inepto!"));
      DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION), GetLocation(OBJECT_SELF)));
      DestroyObject(OBJECT_SELF, 2.2);
      return;
  }

  GuardarIntPersistente(oPC, "DESEO_ATRACTIVO", 1);

  AssignCommand(OBJECT_SELF, SpeakString("Eso es imposible, concedo deseos, no hago milagros. Si me disculpas, he de irme a mi plano. Adiós."));

  DelayCommand(4.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION), GetLocation(OBJECT_SELF)));
  DestroyObject(OBJECT_SELF, 4.2);
}
