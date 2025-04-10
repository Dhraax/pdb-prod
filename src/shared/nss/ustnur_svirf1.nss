void main()
{
  object oPC = GetPCSpeaker();
  int iOroPC = GetGold(oPC);

  // COMPROBACION ORO
  if(iOroPC < 50)
  {
      AssignCommand(OBJECT_SELF, SpeakString("¡No tienes suficiente oro!"));
      return;
  }
  else TakeGoldFromCreature(50, oPC, TRUE);

  object oWPsalida = GetNearestObjectByTag("WP_nursacri1");
  object oWPmuerte = GetNearestObjectByTag("WP_nursacri2");
  object oAspas = GetNearestObjectByTag("nurcuchillalloth");
  location loc = GetLocation(oWPsalida);
  object oSacri = CreateObject(OBJECT_TYPE_CREATURE,"nur_svirf",loc,FALSE,"sacrificio");

  // VARIABLES
  SetLocalInt(OBJECT_SELF,"sacrificio",1);
  DelayCommand(180.0,DeleteLocalInt(OBJECT_SELF,"sacrificio"));

  // ANIMACIONES
  GiveXPToCreature(oPC, 10);
  DelayCommand(1.0,AssignCommand(oSacri,ActionForceMoveToObject(oWPmuerte,FALSE)));
  DelayCommand(10.0,AssignCommand(oAspas,ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE,1.0,5.0)));
  DelayCommand(11.4,ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_COM_CHUNK_RED_LARGE),oSacri));
  DelayCommand(11.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDeath(),oSacri));
  DelayCommand(18.0,AssignCommand(oAspas,ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE,1.0)));

  // TEXTOS
  object oEspectador1 = GetNearestObjectByTag("nur_espectador1");
  object oEspectador2 = GetNearestObjectByTag("nur_espectador2");

  switch(d4())
  {
      case 1: DelayCommand(6.0,AssignCommand(oSacri,SpeakString("*El pequeño gnomo está tan asustado que no dice nada"))); break;
      case 2: DelayCommand(6.0,AssignCommand(oSacri,SpeakString("*A este svirfnebli le han cortado la lengua y mira con pena la sala"))); break;
      case 3: DelayCommand(6.0,AssignCommand(oSacri,SpeakString("*El pequeo gnomo maldice en una lengua para ti desconocida*"))); break;
      case 4: DelayCommand(6.0,AssignCommand(oSacri,SpeakString("*La criatura te mira sombría y avanza..."))); break;
  }

  switch(d4())
  {
      case 1: DelayCommand(13.0,AssignCommand(oEspectador1, SpeakString("¡¡¡Queremos sangre!!!"))); break;
      case 2: DelayCommand(13.0,AssignCommand(oEspectador1, SpeakString("¡Que empiece a sangrar!"))); break;
      case 3: DelayCommand(13.0,AssignCommand(oEspectador1, SpeakString("¡Muerte al yingil!"))); break;
      case 4: DelayCommand(13.0,AssignCommand(oEspectador1, SpeakString("¡¡Jajajajajaj!!"))); break;
  }

  switch(d4())
  {
      case 1: DelayCommand(9.0,AssignCommand(oEspectador2, SpeakString("¡Suplica clemencia!"))); break;
      case 2: DelayCommand(9.0,AssignCommand(oEspectador2, SpeakString("¡Esto si que es diversión!"))); break;
      case 3: DelayCommand(9.0,AssignCommand(oEspectador2, SpeakString("¡Veamos de qué color es la sangre yingil!"))); break;
      case 4: DelayCommand(9.0,AssignCommand(oEspectador2, SpeakString("¡Vas a morir! Muahahaaha"))); break;
  }
}
