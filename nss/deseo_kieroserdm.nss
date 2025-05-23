#include "mti_libreria"
void DecirFraseAleatoria(object oPNJ)
{
int iProbabilidad = d20(2);
string sTexto;

if(iProbabilidad == 2) sTexto = "Saludos.";
else if(iProbabilidad == 3) sTexto = "Necesito que me destraben.";
else if(iProbabilidad == 4) sTexto = "¡¿Algún DM?!";
else if(iProbabilidad == 5) sTexto = "¿Holaaa?";
else if(iProbabilidad == 6) sTexto = "¡Dame xp que he roleado!";
else if(iProbabilidad == 7) sTexto = "¿Está Monti por ahí?";
else if(iProbabilidad == 8) sTexto = "¿Qué DM lleva mi quest?";
else if(iProbabilidad == 9) sTexto = "Necesito que te metas en este pnj para rolear una cosa de vital importancia.";
else if(iProbabilidad == 10) sTexto = "No me funcionan los foros";
else if(iProbabilidad == 11) sTexto = "¿Por qué tengo pieles de mi subraza en el inventario?";
else if(iProbabilidad == 12) sTexto = "¿Dónde se gana xp?";
else if(iProbabilidad == 13) sTexto = "Si lanzo un conjuro de lamento de la banshee metaurdímbrico y anómalamente potenciado porque mi pj no tiene dedo meñique en el brazo derecho, ¿cuáles crees que serán las consecuencias?";
else if(iProbabilidad == 14) sTexto = "¡No me has dado xp por rolear!";
else if(iProbabilidad == 15) sTexto = "¡¡Protesto!!";
else if(iProbabilidad == 16) sTexto = "Vosotros estais aquí para ayudarnos, es vuestra obligación.";
else if(iProbabilidad == 17) sTexto = "Resucítame que me han matado por ir al baño.";
else if(iProbabilidad == 18) sTexto = "¡Joder! Hay mucho laaaaaaaag.";
else if(iProbabilidad == 19) sTexto = "No estaría mal que reiniciarais.";
else if(iProbabilidad == 20) sTexto = "No me banees por favor, he intentado pasarme objetos entre pjs...";
else if(iProbabilidad == 21) sTexto = "Estoy aburrido, cuentame algo.";
else if(iProbabilidad == 22) sTexto = "¿Qué tal? ¡Que te cuentas!";
else if(iProbabilidad == 23) sTexto = "Métete dentro del pnj niña que quiero rolear que la insulto y que la tiro del pelo.";
else if(iProbabilidad == 24) sTexto = "Sé que hay dms, os he visto al entrar.";
else if(iProbabilidad == 25) sTexto = "¡¡Llevo dos semanas con el bloqueo de nivel 15!!";
else if(iProbabilidad == 26) sTexto = "¿Alguien puede ayudarme? Me he quedado atrapado en la pared.";
else if(iProbabilidad == 27) sTexto = "Por favoooooooor, necesito subir de nivel, ¡¡desbloqueadme yaaa!!";
else if(iProbabilidad == 28) sTexto = "He posteado ya la historia en el foro, desbloqueadme ya.";
else if(iProbabilidad == 29) sTexto = "No me llega la clave del registro del foro, ¿qué hago?";
else if(iProbabilidad == 30) sTexto = "¿Está Lust por ahí?";
else if(iProbabilidad == 31) sTexto = "Más hospitales, menos immigrantes, ¡no a la constitucional!";
else if(iProbabilidad == 32) sTexto = "¿Puedo hacerme un druida-monje y rolear que es un drow sacado de Menzoberranzan que va de vacaciones a Athkatla?";
else if(iProbabilidad == 33) sTexto = "¿¿Oyee??";
else if(iProbabilidad == 34) sTexto = "¿Puedo ponerme dos lvl de paladín para ganar las inmunidades y luego hacerme danzarín?";
else if(iProbabilidad == 35) sTexto = "¡¡No me van los hechizos!!";
else if(iProbabilidad == 36) sTexto = "Me han matado por el lag, exijo una satisfacción.";
else if(iProbabilidad == 37) sTexto = "¿Que hasé?";
else if(iProbabilidad == 38) sTexto = "¡Pará!";
else if(iProbabilidad == 39) sTexto = "¡¡Pero hacedme caso que sé que estáis ahí!!";
else sTexto = "Necesito ayuda dm para un tema de roleo.";

AssignCommand(oPNJ, ActionSpeakString(sTexto));
}

void main()
{
  object oPC = GetPCSpeaker();
  location lLugar = GetLocation(oPC);

  // Ifriti ya usado
  SetLocalInt(OBJECT_SELF, "IFRITIUSADO", 1);

  // Solo se pide un deseo una vez
  int iDeseoSerDM = ObtenerIntPersistente(oPC, "DESEO_SERDM");
  if(iDeseoSerDM == 1)
  {
      AssignCommand(OBJECT_SELF, SpeakString("¡Pero si ya te he concedido este deseo alguna vez, inepto!"));
      DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION), GetLocation(OBJECT_SELF)));
      DestroyObject(OBJECT_SELF, 2.2);
      return;
  }

  GuardarIntPersistente(oPC, "DESEO_SERDM", 1);

  SetCutsceneMode(oPC, TRUE);
  DelayCommand(118.0, SetCutsceneMode(oPC, FALSE));

  ActionCastFakeSpellAtObject(SPELL_CREATE_GREATER_UNDEAD, oPC, PROJECTILE_PATH_TYPE_DEFAULT);
  DelayCommand(2.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_PWSTUN), oPC));

  AssignCommand(OBJECT_SELF, SpeakString("¿Quieres ser DM? Pues DM serás..."));
  DelayCommand(6.1, AssignCommand(OBJECT_SELF, SpeakString("*risita*")));
  DelayCommand(6.1, AssignCommand(OBJECT_SELF, PlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING, 2.0, 103.0)));

  DelayCommand(110.0, ActionCastFakeSpellAtObject(SPELL_CREATE_GREATER_UNDEAD, oPC, PROJECTILE_PATH_TYPE_DEFAULT));
  DelayCommand(112.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_PWSTUN), oPC));

  DelayCommand(114.0, AssignCommand(OBJECT_SELF, SpeakString("¿Realmente te gustaría ser DM? *risita*")));
  DelayCommand(114.0, AssignCommand(OBJECT_SELF, PlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING, 2.0, 10.0)));

  DelayCommand(118.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION), GetLocation(OBJECT_SELF)));
  DestroyObject(OBJECT_SELF, 118.2);

  object oCriatura1 = CreateObject(OBJECT_TYPE_CREATURE, "deseo_jugador1", lLugar);
  object oCriatura2 = CreateObject(OBJECT_TYPE_CREATURE, "deseo_jugador2", lLugar);
  object oCriatura3 = CreateObject(OBJECT_TYPE_CREATURE, "deseo_jugador3", lLugar);
  object oCriatura4 = CreateObject(OBJECT_TYPE_CREATURE, "deseo_jugador4", lLugar);
  object oCriatura5 = CreateObject(OBJECT_TYPE_CREATURE, "deseo_jugador5", lLugar);

  DestroyObject(oCriatura1, 112.5);
  DestroyObject(oCriatura2, 112.5);
  DestroyObject(oCriatura3, 112.5);
  DestroyObject(oCriatura4, 112.5);
  DestroyObject(oCriatura5, 112.5);

  DelayCommand(1.1, AssignCommand(oCriatura1, SetFacingPoint(GetPosition(oPC))));
  DelayCommand(1.1, AssignCommand(oCriatura2, SetFacingPoint(GetPosition(oPC))));
  DelayCommand(1.1, AssignCommand(oCriatura3, SetFacingPoint(GetPosition(oPC))));
  DelayCommand(1.1, AssignCommand(oCriatura4, SetFacingPoint(GetPosition(oPC))));
  DelayCommand(1.1, AssignCommand(oCriatura5, SetFacingPoint(GetPosition(oPC))));

  DelayCommand(5.5, DecirFraseAleatoria(oCriatura1));
  DelayCommand(7.5, DecirFraseAleatoria(oCriatura2));
  DelayCommand(8.0, DecirFraseAleatoria(oCriatura1));
  DelayCommand(9.5, DecirFraseAleatoria(oCriatura3));
  DelayCommand(10.0, DecirFraseAleatoria(oCriatura2));
  DelayCommand(12.5, DecirFraseAleatoria(oCriatura4));
  DelayCommand(14.5, DecirFraseAleatoria(oCriatura3));
  DelayCommand(16.0, DecirFraseAleatoria(oCriatura5));
  DelayCommand(18.5, DecirFraseAleatoria(oCriatura1));
  DelayCommand(20.0, DecirFraseAleatoria(oCriatura2));
  DelayCommand(22.5, DecirFraseAleatoria(oCriatura3));
  DelayCommand(24.5, DecirFraseAleatoria(oCriatura4));
  DelayCommand(26.0, DecirFraseAleatoria(oCriatura5));
  DelayCommand(28.5, DecirFraseAleatoria(oCriatura3));
  DelayCommand(30.0, DecirFraseAleatoria(oCriatura2));
  DelayCommand(32.5, DecirFraseAleatoria(oCriatura1));
  DelayCommand(34.5, DecirFraseAleatoria(oCriatura5));
  DelayCommand(36.0, DecirFraseAleatoria(oCriatura4));
  DelayCommand(38.5, DecirFraseAleatoria(oCriatura3));
  DelayCommand(40.0, DecirFraseAleatoria(oCriatura1));
  DelayCommand(42.5, DecirFraseAleatoria(oCriatura5));
  DelayCommand(44.5, DecirFraseAleatoria(oCriatura2));
  DelayCommand(48.0, DecirFraseAleatoria(oCriatura1));
  DelayCommand(50.5, DecirFraseAleatoria(oCriatura5));
  DelayCommand(52.0, DecirFraseAleatoria(oCriatura4));
  DelayCommand(54.0, DecirFraseAleatoria(oCriatura2));
  DelayCommand(56.0, DecirFraseAleatoria(oCriatura1));
  DelayCommand(58.5, DecirFraseAleatoria(oCriatura5));
  DelayCommand(60.5, DecirFraseAleatoria(oCriatura2));
  DelayCommand(62.0, DecirFraseAleatoria(oCriatura1));
  DelayCommand(64.5, DecirFraseAleatoria(oCriatura5));
  DelayCommand(68.0, DecirFraseAleatoria(oCriatura2));
  DelayCommand(70.0, DecirFraseAleatoria(oCriatura4));
  DelayCommand(72.0, DecirFraseAleatoria(oCriatura1));
  DelayCommand(74.5, DecirFraseAleatoria(oCriatura5));
  DelayCommand(76.5, DecirFraseAleatoria(oCriatura2));
  DelayCommand(78.0, DecirFraseAleatoria(oCriatura1));
  DelayCommand(80.5, DecirFraseAleatoria(oCriatura5));
  DelayCommand(82.0, DecirFraseAleatoria(oCriatura3));
  DelayCommand(84.0, DecirFraseAleatoria(oCriatura4));
  DelayCommand(86.0, DecirFraseAleatoria(oCriatura1));
  DelayCommand(88.5, DecirFraseAleatoria(oCriatura5));
  DelayCommand(90.5, DecirFraseAleatoria(oCriatura2));
  DelayCommand(92.0, DecirFraseAleatoria(oCriatura1));
  DelayCommand(94.5, DecirFraseAleatoria(oCriatura5));
  DelayCommand(96.0, DecirFraseAleatoria(oCriatura3));
  DelayCommand(98.0, DecirFraseAleatoria(oCriatura4));
  DelayCommand(100.0, DecirFraseAleatoria(oCriatura1));
  DelayCommand(101.5, DecirFraseAleatoria(oCriatura5));
  DelayCommand(102.5, DecirFraseAleatoria(oCriatura2));
  DelayCommand(103.0, DecirFraseAleatoria(oCriatura1));
  DelayCommand(104.5, DecirFraseAleatoria(oCriatura5));
  DelayCommand(105.0, DecirFraseAleatoria(oCriatura4));
  DelayCommand(106.0, DecirFraseAleatoria(oCriatura3));
}
