string FraseAleatoria()
{
  string sFrase;
  switch(d4())
  {
      case 1: sFrase = "¡Las mejores hondas y tirachinas!"; break;
      case 2: sFrase = "¡Las mejores balas para cazar, no pase su oportunidad!"; break;
      case 3: sFrase = "¡Oferta, oferta!"; break;
      case 4: sFrase = "¡Acérquense, acérquense!"; break;
  }

  return sFrase;
}

void main()
{
  if(GetLocalInt(OBJECT_SELF, "ATKMDAFRASE") == 1) return;
  SetLocalInt(OBJECT_SELF, "ATKMDAFRASE", 1);
  DelayCommand(30.0, DeleteLocalInt(OBJECT_SELF, "ATKMDAFRASE"));

  object oMereppi = GetNearestObjectByTag("pnj_aguMerridan");//tirachinas
  AssignCommand(oMereppi, SpeakString(FraseAleatoria()));
  DelayCommand(10.0, AssignCommand(oMereppi, SpeakString(FraseAleatoria())));
  DelayCommand(20.0, AssignCommand(oMereppi, SpeakString(FraseAleatoria())));
}
