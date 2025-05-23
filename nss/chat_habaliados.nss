void main()
{
  object oPC = GetPCChatSpeaker();
  string sTexto = GetPCChatMessage();

  int iTipoAyudante = ASSOCIATE_TYPE_NONE;

  if(GetStringLeft(GetStringLowerCase(sTexto), 10) == "aliado_ca:") iTipoAyudante = ASSOCIATE_TYPE_ANIMALCOMPANION;
  else if(GetStringLeft(GetStringLowerCase(sTexto), 10) == "aliado_do:") iTipoAyudante = ASSOCIATE_TYPE_DOMINATED;
  else if(GetStringLeft(GetStringLowerCase(sTexto), 10) == "aliado_fa:") iTipoAyudante = ASSOCIATE_TYPE_FAMILIAR;
  else if(GetStringLeft(GetStringLowerCase(sTexto), 10) == "aliado_ay:") iTipoAyudante = ASSOCIATE_TYPE_HENCHMAN;
  else if(GetStringLeft(GetStringLowerCase(sTexto), 10) == "aliado_co:") iTipoAyudante = ASSOCIATE_TYPE_SUMMONED;

  object oAliado = GetAssociate(iTipoAyudante, oPC);

  if(iTipoAyudante = ASSOCIATE_TYPE_NONE || GetIsObjectValid(oAliado) == FALSE)
  {
      FloatingTextStringOnCreature("<c´þd>* Hablar por aliados: Comando inválido o tipo de criatura escogida inválida *</c>", oPC, FALSE);
      return;
  }

  string sMensajeAliado = "<cþz+>" + GetStringRight(sTexto, GetStringLength(sTexto)-10) + "</c>";
  AssignCommand(oAliado, SpeakString(sMensajeAliado));
}
