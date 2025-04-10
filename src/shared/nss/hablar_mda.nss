string FraseAleatoria()
{
  string sFrase;
  switch(d4())
  {
      case 1: sFrase = "¡Visiten el mercado del aventurero!"; break;
      case 2: sFrase = "¡Alabada sea Waukin! ¡Compre sus piedras ioun hoy!"; break;
      case 3: sFrase = "¡La mejor selección de armas en la tienda de Ribald!"; break;
      case 4: sFrase = "¡La suerte está bien, pero un buen arma está mejor!"; break;
  }

  return sFrase;
}

void main()
{
  if(GetLocalInt(OBJECT_SELF, "ATKMDAFRASE") == 1) return;
  SetLocalInt(OBJECT_SELF, "ATKMDAFRASE", 1);
  DelayCommand(30.0, DeleteLocalInt(OBJECT_SELF, "ATKMDAFRASE"));

  object oMereppi = GetNearestObjectByTag("pnj_wauPregonero");//atk_pnjmereppi
  AssignCommand(oMereppi, SpeakString(FraseAleatoria()));
  DelayCommand(10.0, AssignCommand(oMereppi, SpeakString(FraseAleatoria())));
  DelayCommand(20.0, AssignCommand(oMereppi, SpeakString(FraseAleatoria())));
}
