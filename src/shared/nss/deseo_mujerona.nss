#include "mti_libreria"
void main()
{
  object oPC = GetPCSpeaker();

  // Ifriti ya usado
  SetLocalInt(OBJECT_SELF, "IFRITIUSADO", 1);

  // Solo se pide un deseo una vez
  int iDeseoMujerona = ObtenerIntPersistente(oPC, "DESEO_MUJERONA");
  if(iDeseoMujerona == 1)
  {
      AssignCommand(OBJECT_SELF, SpeakString("¡Pero si ya te he concedido este deseo alguna vez, inepto!"));
      DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION), GetLocation(OBJECT_SELF)));
      DestroyObject(OBJECT_SELF, 2.2);
      return;
  }

  AssignCommand(OBJECT_SELF, SpeakString("¿Una mujer a tu servicio quieres decir verdad? ¡Conozco a una que no podrás ni rechazar!"));

  GuardarIntPersistente(oPC, "DESEO_MUJERONA", 1);

  ActionCastFakeSpellAtObject(SPELL_CREATE_GREATER_UNDEAD, oPC, PROJECTILE_PATH_TYPE_DEFAULT);
  DelayCommand(2.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_PWSTUN), oPC));

  effect eTerremoto = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);
  object oMujer = CreateObject(OBJECT_TYPE_CREATURE,"qekierha",GetLocation(oPC),TRUE);
  DelayCommand(2.0, AssignCommand(oMujer, ActionSpeakString("Pichurríííín... Ya estoy aquí, bomboncitooo. Soy toda tuuyaa...")));
  DelayCommand(2.1, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTerremoto, oMujer, 2.0));
  AddHenchman(oPC,oMujer);

  DelayCommand(4.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION), GetLocation(OBJECT_SELF)));
  DestroyObject(OBJECT_SELF, 4.2);
}
