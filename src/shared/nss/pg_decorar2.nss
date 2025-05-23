void main()
{
  if(GetIsPC(GetEnteringObject()) == FALSE) return;

  int iUnaVez = GetLocalInt(OBJECT_SELF, "DECORAR_PLANO_FUGA");
  if(iUnaVez == TRUE) return;

  object oKelemvor = GetNearestObjectByTag("pg_kelemvor");
  if(IsInConversation(oKelemvor) == TRUE) return;

  SetLocalInt(OBJECT_SELF, "DECORAR_PLANO_FUGA", TRUE);
  DelayCommand(15.0, DeleteLocalInt(OBJECT_SELF, "DECORAR_PLANO_FUGA"));

  object oYergal   = GetNearestObjectByTag("pg_yergal");

  int iDado3 = d3();
  string sMensajeKelemvor;

  if(iDado3 == 1) sMensajeKelemvor = "¡Eres un Infiel! ¡Te condeno a fomar parte del Muro de los Infieles el resto de la eternidad!";
  else if(iDado3 == 2) sMensajeKelemvor = "¡Eres un Falso! ¡Te condeno a trabajar en la Ciudad del Juicio el resto de la eternidad!";
  else sMensajeKelemvor = "Tu deidad te reclama Alma en pena, pronto acudirá a por ti.";

  AssignCommand(oKelemvor, SpeakString(sMensajeKelemvor));
  AssignCommand(oKelemvor, PlayAnimation(ANIMATION_LOOPING_CUSTOM4, 1.0, 10.0));
  DelayCommand(3.0, AssignCommand(oYergal, SpeakString("*Anota la muerte y el destino del alma con una gran pluma de hueso*")));

  object oAlma = GetNearestObjectByTag("pg_alma" + IntToString(d4()));
  object oPRAlma1 = GetWaypointByTag("pg_posicion_alma");
  SetLocalLocation(oAlma, "LUGAR_ALMA", GetLocation(oAlma));
  DelayCommand(0.1, AssignCommand(oAlma, JumpToLocation(GetLocation(oPRAlma1))));
  DelayCommand(0.2, AssignCommand(oAlma, SetFacing(GetFacing(oPRAlma1))));
  DelayCommand(0.3, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oAlma, 6.6));
  DelayCommand(1.0, AssignCommand(oAlma, PlayAnimation(ANIMATION_LOOPING_MEDITATE, 2.0, 5.9)));
  DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH), oAlma));
  DelayCommand(7.0, AssignCommand(oAlma, JumpToLocation(GetLocalLocation(oAlma, "LUGAR_ALMA"))));
}
