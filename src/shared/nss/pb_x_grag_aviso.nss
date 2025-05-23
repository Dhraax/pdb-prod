void main()
{
  object oGrag = GetObjectByTag("Grag");
  object oPJ = GetEnteringObject();

  DelayCommand(1.0, AssignCommand(oGrag, SetFacingPoint(GetPosition(oPJ))));
  DelayCommand(2.0, AssignCommand(oGrag, ActionSpeakString("Bienvenido al los aposentos del Grano Maduro. Grag para servirle...")));
  DelayCommand(4.0, AssignCommand(oGrag, PlayAnimation(ANIMATION_FIREFORGET_BOW)));
}
