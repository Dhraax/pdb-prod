void main()
{
  object oPC = GetPCSpeaker();
  object oSecretaria = GetNearestObjectByTag("atk_ae_secretaria", oPC);
  int oOro = GetGold(oPC);

  if(oOro < 500)
  {
      AssignCommand(oSecretaria, SpeakString("¡No tienes suficiente dinero, vuelve cuando lo tengas!"));
      return;
  }

  TakeGoldFromCreature(500, oPC, TRUE);
  AssignCommand(oSecretaria, SpeakString("¡Perfecto! Toma, todo esto es tuyo. ¡Acuérdate de leer bien tu libro eh!"));
  CreateItemOnObject("libro_ae", oPC);
  CreateItemOnObject("arcanum_1", oPC);
  CreateItemOnObject("NW_CLOTH007", oPC);
  CreateItemOnObject("bstn_ae_aprendiz", oPC);
}
