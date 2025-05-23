// Script para la zancada forestal del druida

void main()
{
  object oPC = GetPCSpeaker();

  string sTagDestino = GetScriptParam("DESTINO");

  // Efectos
  effect eEfectoVisual = EffectVisualEffect(VFX_DUR_ENTANGLE);
  ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfectoVisual, oPC);
  eEfectoVisual = EffectVisualEffect(VFX_IMP_POLYMORPH);
  ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfectoVisual, oPC);

  //Le hacemos saltar en 1.3 segundos.
  object oArbolDestino = GetObjectByTag(sTagDestino);
  DelayCommand(1.3, AssignCommand(oPC, ActionJumpToObject(oArbolDestino, FALSE)));
}
