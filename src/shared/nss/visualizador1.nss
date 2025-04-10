#include "x0_i0_petrify"

void main()
{
  object oMod = GetModule();
  object oVisualizador = GetNearestObjectByTag("visualizador");
  int iVisual = GetLocalInt(oMod, "IDVISUAL");

  if(iVisual == 120) iVisual++; // Apariencia unload model
  else if(iVisual == 673) iVisual = 751;
  else if(iVisual == 839) iVisual = 851;
  else if(iVisual == 951) iVisual = 1000;
  else if(iVisual == 1327) iVisual = 1500;
  else if(iVisual == 1998) iVisual = 2052;
  else if(iVisual == 2160) iVisual = 4200;
  else if(iVisual == 4258) iVisual = 4300;
  else if(iVisual == 4717) iVisual = 4760;
  else if(iVisual == 4893) iVisual = 6000;
  else if(iVisual == 6080) iVisual = 0;

  RemoveEffectOfType(oVisualizador, EFFECT_TYPE_VISUALEFFECT);
  DelayCommand(0.1, PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
  DelayCommand(5.0, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(iVisual), oVisualizador);
  FloatingTextStringOnCreature("Reproduciendo efecto visual número: " + IntToString(iVisual), GetLastUsedBy());
  SetLocalInt(oMod, "IDVISUAL", iVisual + 1);
}
