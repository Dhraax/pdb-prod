string FraseAleatoria()
{
  string sFrase;
  switch(d4())
  {
      case 1: sFrase = "¡Regocijaos pues los bienes serán compartidos y las deudas solventadas!"; break;
      case 2: sFrase = "¡Los truhanes, morosos y estafadores no se pueden ocultar a la Amiga del Mercader!"; break;
      case 3: sFrase = "¡Alabada sea Waukin por su oro y buenas obras!"; break;
      case 4: sFrase = "¡Cliente, cliente y cliente! ¡Recordad esto para triunfar!"; break;
  }

  return sFrase;
}

void main()
{
  if(GetLocalInt(OBJECT_SELF, "ATKMDAFRASE") == 1) return;
  SetLocalInt(OBJECT_SELF, "ATKMDAFRASE", 1);
  DelayCommand(30.0, DeleteLocalInt(OBJECT_SELF, "ATKMDAFRASE"));

  object oMereppi = GetNearestObjectByTag("pnj_agutemOrosupremo"); //ClerigoSupremo_01
  AssignCommand(oMereppi, SpeakString(FraseAleatoria()));
  DelayCommand(10.0, AssignCommand(oMereppi, SpeakString(FraseAleatoria())));
  DelayCommand(20.0, AssignCommand(oMereppi, SpeakString(FraseAleatoria())));
}
