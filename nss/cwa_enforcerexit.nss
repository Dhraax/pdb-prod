#include "mti_libreria"

void main()
{
  object oPC = GetPCSpeaker();

  // El Mago Encapuchado se va
  DestroyObject(OBJECT_SELF, 2.0);
  DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), OBJECT_SELF));

  // Dar el Aviso
  int iAvisosTotales = ObtenerIntPersistente(oPC, "AVISOSMAGOS");
  GuardarIntPersistente(oPC, "AVISOSMAGOS", iAvisosTotales + 1);
}
