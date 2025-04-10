void main()
{
  ClearAllActions();
  DelayCommand(0.1, ActionSpeakString("*La mascota se refugia en un lugar seguro al sentirse en peligro*"));
  DelayCommand(0.2, ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDisappear(), OBJECT_SELF));
}
