string FraseAleatoria()
{
  string sFrase;
  switch(d4())
  {
      case 1: sFrase = "¡Moveros holgazanes u os daré con el látigo!"; break;
      case 2: sFrase = "¡Vida o muerte, lucharéis hasta el final por el honor de vuestro ludus!"; break;
      case 3: sFrase = "¡Más rápido, moviéndote tan lento no durarás ni dos minutos en la arena!"; break;
      case 4: sFrase = "¡Juntos, más juntos!"; break;
  }

  return sFrase;
}

void main()
{
  if(GetLocalInt(OBJECT_SELF, "ATKMDAFRASE") == 1) return;
  SetLocalInt(OBJECT_SELF, "ATKMDAFRASE", 1);
  DelayCommand(30.0, DeleteLocalInt(OBJECT_SELF, "ATKMDAFRASE"));

  object oMereppi = GetNearestObjectByTag("pnj_aguLanista");//kro_lanista
  AssignCommand(oMereppi, SpeakString(FraseAleatoria()));
  DelayCommand(10.0, AssignCommand(oMereppi, SpeakString(FraseAleatoria())));
  DelayCommand(20.0, AssignCommand(oMereppi, SpeakString(FraseAleatoria())));
}
