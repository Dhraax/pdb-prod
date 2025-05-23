#include "mti_libreria"
void main()
{
  object oPC = GetPCSpeaker();

  // Ifriti ya usado
  SetLocalInt(OBJECT_SELF, "IFRITIUSADO", 1);

  // Solo se pide un deseo una vez
  int iDeseoDiversion = ObtenerIntPersistente(oPC, "DESEO_DIVERSION");
  if(iDeseoDiversion == 1)
  {
      AssignCommand(OBJECT_SELF, SpeakString("¡Pero si ya te he concedido este deseo alguna vez, inepto!"));
      DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION), GetLocation(OBJECT_SELF)));
      DestroyObject(OBJECT_SELF, 2.2);
      return;
  }

  AssignCommand(OBJECT_SELF, SpeakString("¿Dicertirte deseas? Rara es tu petición... ¡así que prepárate para la diversión!"));

  GuardarIntPersistente(oPC, "DESEO_DIVERSION", 1);

  ActionCastFakeSpellAtObject(SPELL_CREATE_GREATER_UNDEAD, oPC, PROJECTILE_PATH_TYPE_DEFAULT);
  DelayCommand(2.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_PWSTUN), oPC));

  SetCutsceneMode(oPC,TRUE);
  AssignCommand(oPC,ActionSpeakString("*Tu cuerpo comienza a agitarse presa de la diversión*"));
  DelayCommand(1.0,AssignCommand(oPC,PlayAnimation(ANIMATION_LOOPING_SPASM,1.5,30.0)));
  DelayCommand(30.0,AssignCommand(oPC,ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY1,1.5,2.0)));
  DelayCommand(32.0,AssignCommand(oPC,ActionSpeakString("¡Jajajajajaja!")));
  DelayCommand(33.0,AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING,1.5,13.0)));
  DelayCommand(47.0,AssignCommand(oPC,PlayAnimation(ANIMATION_LOOPING_SPASM,1.5,10.0)));
  DelayCommand(50.0,AssignCommand(oPC,ActionSpeakString("¡Jajajajaja! ¡¡Qué risa!!")));
  DelayCommand(52.0,AssignCommand(oPC,ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY2,1.5,2.0)));
  DelayCommand(54.0,AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING,1.5,16.0)));
  DelayCommand(71.0,AssignCommand(oPC,ActionSpeakString("*Te empieza a doler todo el cuerpo insoportablemente*")));
  DelayCommand(72.0,AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT,1.5,13.0)));
  DelayCommand(84.0, SetCutsceneMode(oPC, FALSE));

  DelayCommand(82.0, AssignCommand(OBJECT_SELF, SpeakString("¡Diversión a raudales! ¡Diversión a raudales! ¡Adios!")));
  DelayCommand(84.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION), GetLocation(OBJECT_SELF)));
  DestroyObject(OBJECT_SELF, 84.2);
}
