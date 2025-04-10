#include "x0_i0_petrify"

void main()
{
  object oMod = GetModule();
  object oVisualizador = GetNearestObjectByTag("visualizador");
  int iVisual = GetLocalInt(oMod, "IDVISUAL");

  if(iVisual == -1) iVisual = 6079;
  else if(iVisual == 5999) iVisual = 4892;
  else if(iVisual == 4759) iVisual = 4716;
  else if(iVisual == 4299) iVisual = 4257;
  else if(iVisual == 4199) iVisual = 2159;
  else if(iVisual == 2051) iVisual = 1997;
  else if(iVisual == 1499) iVisual = 1326;
  else if(iVisual == 999) iVisual = 950;
  else if(iVisual == 850) iVisual = 838;
  else if(iVisual == 750) iVisual = 672;
  else if(iVisual == 120) iVisual--; // Apariencia unload model

  RemoveEffectOfType(oVisualizador, EFFECT_TYPE_VISUALEFFECT);
  DelayCommand(0.1, PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
  DelayCommand(5.0, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(iVisual), oVisualizador);
  FloatingTextStringOnCreature("Reproduciendo efecto visual número: " + IntToString(iVisual), GetLastUsedBy());
  SetLocalInt(oMod, "IDVISUAL", iVisual - 1);
}
