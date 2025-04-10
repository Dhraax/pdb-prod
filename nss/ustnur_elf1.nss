void main()
{
  object oPC = GetPCSpeaker();
  int iOroPC = GetGold(oPC);

  // COMPROBACION ORO
  if(iOroPC < 400)
  {
      AssignCommand(OBJECT_SELF, SpeakString("¡No tienes suficiente oro!"));
      return;
  }
  else TakeGoldFromCreature(400, oPC, TRUE);

object oWPsalida = GetNearestObjectByTag("WP_nursacri1");
object oWPmuerte = GetNearestObjectByTag("WP_nursacri2");
object oAspas = GetNearestObjectByTag("nurcuchillalloth");

location loc = GetLocation(oWPsalida);

SetLocalInt(OBJECT_SELF,"sacrificio",1);

CreateObject(OBJECT_TYPE_CREATURE,"nur_elf",loc,FALSE,"sacrificio");

object oSacri = GetNearestObjectByTag("sacrificio");

DelayCommand(1.0,AssignCommand(oSacri,ActionForceMoveToObject(oWPmuerte,FALSE)));

int i1 = d4(1);

if(i1 == 1)
{
DelayCommand(6.0,AssignCommand(oSacri,SpeakString("Ojalá sufráis con vuestra maldita diosa.")));
}
else if(i1 == 2)
{
DelayCommand(6.0,AssignCommand(oSacri,SpeakString("¡Malditos drow! *escupe* ¿Qué vais a hacer conmigo?")));
}
else if(i1 == 2)
{
DelayCommand(6.0,AssignCommand(oSacri,SpeakString("¡Malditos! ¡Dejadme salir!")));
}
else
{
DelayCommand(6.0,AssignCommand(oSacri,SpeakString("¡Maldita sea vuestra raza y vuestra Reina Araña!")));
}
DelayCommand(10.0,AssignCommand(oAspas,ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE,1.0,5.0)));

effect ePLAS = EffectVisualEffect(VFX_COM_CHUNK_RED_LARGE);

DelayCommand(11.4,ApplyEffectToObject(DURATION_TYPE_INSTANT,ePLAS,oSacri));

DelayCommand(11.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDeath(),oSacri));

//Poner probabilidad

int i2 = d4(1);

if(i2 == 1)
{
DelayCommand(13.0,AssignCommand(GetNearestObjectByTag("nur_espectador1"),SpeakString("¡¡¡Grita!!!")));
}
else if(i2 == 2)
{
DelayCommand(13.0,AssignCommand(GetNearestObjectByTag("nur_espectador1"),SpeakString("¡Que empiece a sangrar!")));
}
else if(i2 == 3)
{
DelayCommand(13.0,AssignCommand(GetNearestObjectByTag("nur_espectador1"),SpeakString("¡Muerte a los enemigos darthiir!")));
}
else
{
DelayCommand(13.0,AssignCommand(GetNearestObjectByTag("nur_espectador1"),SpeakString("¡¡Jajajajajaj!!")));
}

int i3 = d4(1);

if(i3 == 1)
{
DelayCommand(9.0,AssignCommand(GetNearestObjectByTag("nur_espectador2"),SpeakString("¡Suplica clemencia, asqueroso darthiir!")));
}
else if(i3 == 2)
{
DelayCommand(9.0,AssignCommand(GetNearestObjectByTag("nur_espectador2"),SpeakString("¡Gloria a Lloth!")));
}
else if(i3 == 2)
{
DelayCommand(9.0,AssignCommand(GetNearestObjectByTag("nur_espectador2"),SpeakString("¡Veamos qué tiene dentro el darthiir!")));
}
else
{
DelayCommand(9.0,AssignCommand(GetNearestObjectByTag("nur_espectador2"),SpeakString("¡Vamos a verte las tripas! Jajajajaj")));
}

DelayCommand(18.0,AssignCommand(oAspas,ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE,1.0)));

GiveXPToCreature(GetPCSpeaker(),100);
DelayCommand(180.0,DeleteLocalInt(OBJECT_SELF,"sacrificio"));
}
