void main()
{
  object oPC = GetEnteringObject();

  if(GetIsPC(oPC) != TRUE) return;
  if(GetIsNight()) return;

  object oMod = GetModule();
  int iVariable = GetLocalInt(oMod, "ESMMERCADO");
  if(iVariable == 1) return;

  object oAnuncio_1 = GetNearestObjectByTag("comerciante_merc_esmel_1");
  object oAnuncio_3 = GetNearestObjectByTag("comerciante_merc_esmel_3");

  SetLocalInt(oMod, "ESMMERCADO", 1);
  DelayCommand(10.0, DeleteLocalInt(oMod, "ESMMERCADO"));
  DelayCommand(0.5, AssignCommand(oAnuncio_1, SpeakString("¡Tengo los mejores objetos de todo Amn, vengan y vean, vengan y veaaan!")));
  DelayCommand(3.5, AssignCommand(oAnuncio_3, SpeakString("¡La mejor carne de vaca que hayáis probado, y leche de la mejor calidad!")));
}
