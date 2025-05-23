void main()
{
  int iHora = GetTimeHour();

  if((iHora >= 8 && iHora <= 13)||(iHora >= 17 && iHora <= 20))
  {
      ActionOpenDoor(OBJECT_SELF);
      DelayCommand(5.0,ActionCloseDoor(OBJECT_SELF));
  }

  else if(iHora >= 21 && iHora <= 7)
  {
      AssignCommand(OBJECT_SELF,ActionSpeakString("Tienda cerrada. Vuelva mañana."));
  }

  else if(iHora >= 14 && iHora <= 16)
  {
      AssignCommand(OBJECT_SELF,ActionSpeakString("Tienda cerrada. Vuelva más tarde."));
  }
}
