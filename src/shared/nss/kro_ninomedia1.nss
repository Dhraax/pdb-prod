string FraseAleatoria()
{
  string sFrase;
  switch(d4())
  {
      case 1: sFrase = "¡Vale ya pásame la pelota!"; break;
      case 2: sFrase = "Soy mejor que tuuu soy mejor que tuu"; break;
      case 3: sFrase = "¡A que no me pillas!"; break;
      case 4: sFrase = "¡Estás en medio!"; break;
  }

  return sFrase;
}

void main()
{
  if(GetLocalInt(OBJECT_SELF, "ATKMDAFRASE") == 1) return;
  SetLocalInt(OBJECT_SELF, "ATKMDAFRASE", 1);
  DelayCommand(30.0, DeleteLocalInt(OBJECT_SELF, "ATKMDAFRASE"));

  object oMereppi = GetNearestObjectByTag("pnj_gamMediana02"); //kro_medianacria
  AssignCommand(oMereppi, SpeakString(FraseAleatoria()));
  DelayCommand(10.0, AssignCommand(oMereppi, SpeakString(FraseAleatoria())));
  DelayCommand(20.0, AssignCommand(oMereppi, SpeakString(FraseAleatoria())));
}
