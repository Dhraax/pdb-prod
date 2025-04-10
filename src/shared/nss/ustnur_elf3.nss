#include "nw_i0_2q4luskan"

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
object oWPdrana = GetNearestObjectByTag("WP_nurdrana");
object oWPpnjmuerte = GetNearestObjectByTag("WP_nurpnjmuerte");

location loc = GetLocation(oWPsalida);

SetLocalInt(OBJECT_SELF,"sacrificio",1);

CreateObject(OBJECT_TYPE_CREATURE,"nur_elf",loc,FALSE,"sacrificio");

object oSacri = GetNearestObjectByTag("sacrificio");

DelayCommand(1.0,AssignCommand(oSacri,ActionForceMoveToObject(oWPmuerte,FALSE)));

int i1 = d4(1);

if(i1 == 1)
{
DelayCommand(10.0,AssignCommand(oSacri,SpeakString("*Lloriquea")));
}
else if(i1 == 2)
{
DelayCommand(10.0,AssignCommand(oSacri,SpeakString("¿Qué es esto?")));
}
else if(i1 == 2)
{
DelayCommand(10.0,AssignCommand(oSacri,SpeakString("No os guardaré rencor. Espero que algún día seais conscientes de esto.")));
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
DelayCommand(17.0,AssignCommand(GetNearestObjectByTag("nur_espectador1"),SpeakString("¡Bravo!")));
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
DelayCommand(17.0,AssignCommand(GetNearestObjectByTag("nur_espectador1"),SpeakString("¡Viva, Traidor!")));
}

int i3 = d4(1);

if(i3 == 1)
{
DelayCommand(12.0,AssignCommand(GetNearestObjectByTag("nur_espectador2"),SpeakString("¡El traidor te dará tu merecido, asqueroso darthiir!")));
}
else if(i3 == 2)
{
DelayCommand(12.0,AssignCommand(GetNearestObjectByTag("nur_espectador2"),SpeakString("¡Vas a morir!")));
}
else if(i3 == 2)
{
DelayCommand(12.0,AssignCommand(GetNearestObjectByTag("nur_espectador2"),SpeakString("¡Reza a tus falsos dioses!")));
}
else
{
DelayCommand(12.0,AssignCommand(GetNearestObjectByTag("nur_espectador2"),SpeakString("¡Llora! ¡No te servirá de nada!")));
}
GiveXPToCreature(GetPCSpeaker(),100);
DelayCommand(180.0,DeleteLocalInt(OBJECT_SELF,"sacrificio"));
}
