#include "mti_libreria"
void main()
{
  object oPC = GetPCSpeaker();

  // Ifriti ya usado
  SetLocalInt(OBJECT_SELF, "IFRITIUSADO", 1);

  // Solo se pide un deseo una vez
  int iDeseoHombreton = ObtenerIntPersistente(oPC, "DESEO_HOMBRETON");
  if(iDeseoHombreton == 1)
  {
      AssignCommand(OBJECT_SELF, SpeakString("¡Pero si ya te he concedido este deseo alguna vez, inepto!"));
      DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION), GetLocation(OBJECT_SELF)));
      DestroyObject(OBJECT_SELF, 2.2);
      return;
  }

  AssignCommand(OBJECT_SELF, SpeakString("¿Un hombre dispuesto a todo? ¡Lo tendrás! ¡faltaría más!"));

  GuardarIntPersistente(oPC, "DESEO_HOMBRETON", 1);

  ActionCastFakeSpellAtObject(SPELL_CREATE_GREATER_UNDEAD, oPC, PROJECTILE_PATH_TYPE_DEFAULT);
  DelayCommand(2.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_PWSTUN), oPC));

  effect eTerremoto = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);
  object oHombre = CreateObject(OBJECT_TYPE_CREATURE,"kheqierah",GetLocation(oPC),TRUE);
  DelayCommand(2.0, AssignCommand(oHombre, ActionSpeakString("'Uno de los placeres de la vida es hacer lo que la gente dice que no podemos' *snif* ¡Se me saltan las lágrimas cuando me pongo romántico! *snif*")));
  DelayCommand(2.1, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTerremoto, oHombre, 2.0));
  AddHenchman(oPC,oHombre);

  DelayCommand(4.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION), GetLocation(OBJECT_SELF)));
  DestroyObject(OBJECT_SELF, 4.2);
}
