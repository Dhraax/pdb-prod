void main()
{
  object oVisualizador = GetNearestObjectByTag("visualizador");

  DelayCommand(0.1, PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
  DelayCommand(5.0, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));
  CreateObject(OBJECT_TYPE_PLACEABLE, "visualizador", GetLocation(oVisualizador));
  DestroyObject(oVisualizador, 0.1);
}
