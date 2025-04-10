#include "nw_i0_2q4luskan"

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
object oWPdrana = GetNearestObjectByTag("WP_nurdrana");
object oWPpnjmuerte = GetNearestObjectByTag("WP_nurpnjmuerte");

location loc = GetLocation(oWPsalida);

SetLocalInt(OBJECT_SELF,"sacrificio",1);

CreateObject(OBJECT_TYPE_CREATURE,"nur_svirf",loc,FALSE,"sacrificio");

object oSacri = GetNearestObjectByTag("sacrificio");

DelayCommand(1.0,AssignCommand(oSacri,ActionForceMoveToObject(oWPmuerte,FALSE)));

int i1 = d4(1);

if(i1 == 1)
{
DelayCommand(10.0,AssignCommand(oSacri,SpeakString("*La criatura se estremece al oir el clamor de los espectadores*")));
}
else if(i1 == 2)
{
DelayCommand(10.0,AssignCommand(oSacri,SpeakString("*El svirfnebli no dice nada. Parece que acepta su destino después de tantas torturas*")));
}
else if(i1 == 2)
{
DelayCommand(10.0,AssignCommand(oSacri,SpeakString("¡Aaaaaaaaarg!")));
}
else
{
DelayCommand(10.0,AssignCommand(oSacri,SpeakString("*Intenta chillar, pero está totalmente cubierto de tela de araña.*")));
}

DelayCommand(14.0,CreateObjectVoid(OBJECT_TYPE_CREATURE,"nurtraidor",GetLocation(oWPdrana),TRUE));

DelayCommand(10.0,ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectVisualEffect(VFX_DUR_WEB),oSacri));

DelayCommand(15.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDeath(),oSacri));
DelayCommand(15.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_POISON_L),oSacri));


DelayCommand(17.0,AssignCommand(GetNearestObjectByTag("nurtraidor"),ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY1)));

DelayCommand(23.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDisappearAppear(GetLocation(oWPpnjmuerte)),GetNearestObjectByTag("nurtraidor")));

DelayCommand(29.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDeath(),GetNearestObjectByTag("nurtraidor")));


int i2 = d4(1);

if(i2 == 1)
{
DelayCommand(17.0,AssignCommand(GetNearestObjectByTag("nur_espectador1"),SpeakString("¡Muahahahaha!")));
}
else if(i2 == 2)
{
DelayCommand(17.0,AssignCommand(GetNearestObjectByTag("nur_espectador1"),SpeakString("¡Jajajajaj!")));
}
else if(i2 == 3)
{
DelayCommand(17.0,AssignCommand(GetNearestObjectByTag("nur_espectador1"),SpeakString("¡Que lo mate lentamente!")));
}
else
{
DelayCommand(17.0,AssignCommand(GetNearestObjectByTag("nur_espectador1"),SpeakString("¡Que rezume tu veneno, Traidor!")));
}

int i3 = d4(1);

if(i3 == 1)
{
DelayCommand(12.0,AssignCommand(GetNearestObjectByTag("nur_espectador2"),SpeakString("¡El traidor te dará tu merecido, asqueroso yingil!")));
}
else if(i3 == 2)
{
DelayCommand(12.0,AssignCommand(GetNearestObjectByTag("nur_espectador2"),SpeakString("¡Que traigan otra cosa! ¡Los svirfnebli apenas chillan!")));
}
else if(i3 == 2)
{
DelayCommand(12.0,AssignCommand(GetNearestObjectByTag("nur_espectador2"),SpeakString("¡Reza a tus falsos dioses, besarocas!")));
}
else
{
DelayCommand(12.0,AssignCommand(GetNearestObjectByTag("nur_espectador2"),SpeakString("¡Vaya birria de sacrificio!")));
}
GiveXPToCreature(GetPCSpeaker(),10);
DelayCommand(180.0,DeleteLocalInt(OBJECT_SELF,"sacrificio"));
}
