void main()
{
  object oPC = GetPCSpeaker();
  int iOroPC = GetGold(oPC);

  // COMPROBACION ORO
  if(iOroPC < 300)
  {
      AssignCommand(OBJECT_SELF, SpeakString("¡No tienes suficiente oro!"));
      return;
  }
  else TakeGoldFromCreature(300, oPC, TRUE);

object oWPsalida = GetNearestObjectByTag("WP_nursacri1");
object oWPmuerte = GetNearestObjectByTag("WP_nursacri2");
object oAspas = GetNearestObjectByTag("nurcuchillalloth");

location loc = GetLocation(oWPsalida);

SetLocalInt(OBJECT_SELF,"sacrificio",1);

CreateObject(OBJECT_TYPE_CREATURE,"nur_traid",loc,FALSE,"sacrificio");

object oSacri = GetNearestObjectByTag("sacrificio");

DelayCommand(1.0,AssignCommand(oSacri,ActionForceMoveToObject(oWPmuerte,FALSE)));

int i1 = d4(1);

if(i1 == 1)
{
DelayCommand(6.0,AssignCommand(oSacri,SpeakString("¡Os lo ruego! ¡Liberadme!")));
}
else if(i1 == 2)
{
DelayCommand(6.0,AssignCommand(oSacri,SpeakString("¡Yo no he hecho nada!")));
}
else if(i1 == 2)
{
DelayCommand(6.0,AssignCommand(oSacri,SpeakString("¡Que Eilistrae os maldiga!")));
}
else
{
DelayCommand(6.0,AssignCommand(oSacri,SpeakString("*Llora*")));
}
DelayCommand(10.0,AssignCommand(oAspas,ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE,1.0,5.0)));

effect ePLAS = EffectVisualEffect(VFX_COM_CHUNK_RED_LARGE);

DelayCommand(11.4,ApplyEffectToObject(DURATION_TYPE_INSTANT,ePLAS,oSacri));

DelayCommand(11.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDeath(),oSacri));

//Poner probabilidad

int i2 = d4(1);

if(i2 == 1)
{
DelayCommand(13.0,AssignCommand(GetNearestObjectByTag("nur_espectador1"),SpeakString("¡¡¡Chilla, sucia alimaña!!!")));
}
else if(i2 == 2)
{
DelayCommand(13.0,AssignCommand(GetNearestObjectByTag("nur_espectador1"),SpeakString("¡Que empiece a sangrar!")));
}
else if(i2 == 3)
{
DelayCommand(13.0,AssignCommand(GetNearestObjectByTag("nur_espectador1"),SpeakString("¡Muerteeeee!")));
}
else
{
DelayCommand(13.0,AssignCommand(GetNearestObjectByTag("nur_espectador1"),SpeakString("¡¡Jajajajajaj!!")));
}

int i3 = d4(1);

if(i3 == 1)
{
DelayCommand(9.0,AssignCommand(GetNearestObjectByTag("nur_espectador2"),SpeakString("¡Suplica clemencia!")));
}
else if(i3 == 2)
{
DelayCommand(9.0,AssignCommand(GetNearestObjectByTag("nur_espectador2"),SpeakString("¡Esto si que es diversión!")));
}
else if(i3 == 2)
{
DelayCommand(9.0,AssignCommand(GetNearestObjectByTag("nur_espectador2"),SpeakString("¡Muere, sucio traidor!")));
}
else
{
DelayCommand(9.0,AssignCommand(GetNearestObjectByTag("nur_espectador2"),SpeakString("¡Vas a morir! Jajajajaj")));
}

DelayCommand(18.0,AssignCommand(oAspas,ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE,1.0)));

GiveXPToCreature(GetPCSpeaker(),80);
DelayCommand(180.0,DeleteLocalInt(OBJECT_SELF,"sacrificio"));
}
