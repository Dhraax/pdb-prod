#include "mti_libreria"

void main()
{
  object oPC = GetPCSpeaker();
  object oMagoEncapuchado = OBJECT_SELF;
  location lCeldaSanatorio = GetLocation(GetWaypointByTag("carcel_sanatorio"));

  // Dar el objeto de Preso en el Sanatorio
  if(GetItemPossessedBy(oPC, "encarcelado_san") == OBJECT_INVALID)
  CreateItemOnObject("encarcelado_san", oPC);

  // Dar el Aviso
  int iAvisosTotales = ObtenerIntPersistente(oPC, "AVISOSMAGOS");
  GuardarIntPersistente(oPC, "AVISOSMAGOS", iAvisosTotales + 1);

  // Enviar al jugador al sanatorio
  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), oPC);
  DelayCommand(2.9, AssignCommand(oPC, ClearAllActions(TRUE)));
  DelayCommand(3.0, AssignCommand(oPC, ActionJumpToLocation(lCeldaSanatorio)));

  // Eliminar Mago Encapuchado
  DestroyObject(oMagoEncapuchado, 6.0);
  DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), oMagoEncapuchado));
}
