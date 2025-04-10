void main()
{
  object oMod = GetModule();
  int iVariable = GetLocalInt(oMod, "ESMLLORONA");
  if(iVariable == 1) return;

  object oCiudadano1 = GetNearestObjectByTag("Ciudadana_emel_cg_2");
  object oCiudadano2 = GetNearestObjectByTag("Ciudadana_emel_cg_1");
  object oCiudadano3 = GetNearestObjectByTag("Ciudadano_cg_esmel_1");
  object oCiudadano4 = GetNearestObjectByTag("Ciudadana_emel_cg_3");
  object oMujer = GetNearestObjectByTag("Mujeralterada_esmel_cg");

  // Todos miran a la mujer desesperada
  AssignCommand(oCiudadano1, SetFacingPoint(GetPosition(oMujer)));
  AssignCommand(oCiudadano2, SetFacingPoint(GetPosition(oMujer)));
  AssignCommand(oCiudadano3, SetFacingPoint(GetPosition(oMujer)));
  AssignCommand(oCiudadano4, SetFacingPoint(GetPosition(oMujer)));

  // Empiezan la charla y las animaciones
  DelayCommand(1.0, AssignCommand(oCiudadano1, SpeakString("Tranquila, todo ira bien *la mira apenada*")));
  DelayCommand(1.0, AssignCommand(oCiudadano1, ActionPlayAnimation(ANIMATION_LOOPING_TALK_FORCEFUL, 0.0, 30.0)));
  DelayCommand(2.5, AssignCommand(oCiudadano2, SpeakString("¡No te apenes, todo se arreglará!")));
  DelayCommand(2.5, AssignCommand(oCiudadano2, ActionPlayAnimation(ANIMATION_LOOPING_TALK_PLEADING, 0.0, 30.0)));
  DelayCommand(3.0, AssignCommand(oCiudadano4, SpeakString("¡Este marido tuyo no quiso escuchar a nadie!")));
  DelayCommand(3.0, AssignCommand(oCiudadano4, ActionPlayAnimation(ANIMATION_LOOPING_TALK_PLEADING, 0.0, 30.0)));
  DelayCommand(4.0, AssignCommand(oCiudadano3, SpeakString("¡Le dije que no fuera, que era peligroso!")));
  DelayCommand(4.0, AssignCommand(oCiudadano3, ActionPlayAnimation(ANIMATION_LOOPING_TALK_FORCEFUL, 0.0, 30.0)));
  DelayCommand(4.5, AssignCommand(oMujer, SpeakString("*Muy alterada* ¡Mi marido! ¡Quiero que vuelva! *Llora*")));
  DelayCommand(4.5, AssignCommand(oMujer, ActionPlayAnimation(ANIMATION_LOOPING_TALK_PLEADING, 0.0, 30.0)));

  // Variables
  SetLocalInt(oMod, "ESMLLORONA", 1);
  DelayCommand(30.0, DeleteLocalInt(oMod, "ESMLLORONA"));
}
