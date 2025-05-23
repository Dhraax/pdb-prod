void main()
{
  object oMod = GetModule();

  // Animaciones de la palanca
  if(GetLocalInt(OBJECT_SELF, "ANIMACION_PALANCA") == FALSE)
  {
      SetLocalInt(OBJECT_SELF, "ANIMACION_PALANCA", TRUE);
      ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE);
  }
  else
  {
      DeleteLocalInt(OBJECT_SELF, "ANIMACION_PALANCA");
      ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);
  }

  // Cambio de ajuste horario
  if(GetCampaignInt("AJUSTEHORARIO", "AJUSTEHORARIO", oMod) == FALSE)
  {
      AssignCommand(OBJECT_SELF, ActionSpeakString("Ajuste horario cambiado a: +1 Horas"));
      SetCampaignInt("AJUSTEHORARIO", "AJUSTEHORARIO", TRUE, oMod);
  }
  else
  {
      AssignCommand(OBJECT_SELF, ActionSpeakString("Ajuste horario cambiado a: +2 Hora"));
      SetCampaignInt("AJUSTEHORARIO", "AJUSTEHORARIO", FALSE, oMod);
  }
}
