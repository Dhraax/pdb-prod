#include "mti_libreria"
void CreateItemOnObjectVoid(string sItemTemplate, object oTarget=OBJECT_SELF, int nStackSize=1)
{
     CreateItemOnObject(sItemTemplate, oTarget, nStackSize);
}

void main()
{
  object oPC = GetPCSpeaker();

  // Ifriti ya usado
  SetLocalInt(OBJECT_SELF, "IFRITIUSADO", 1);

  // Solo se pide un deseo una vez
  int iDeseoTiempo = ObtenerIntPersistente(oPC, "DESEO_TIEMPO");
  if(iDeseoTiempo == 1)
  {
      AssignCommand(OBJECT_SELF, SpeakString("¡Pero si ya te he concedido este deseo alguna vez, inepto!"));
      DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION), GetLocation(OBJECT_SELF)));
      DestroyObject(OBJECT_SELF, 2.2);
      return;
  }

  AssignCommand(OBJECT_SELF, SpeakString("¿Controlar el tiempo? ¡Eso tiene fácil solución! ¡Con este mecanismo mil y unas situaciones congelarás!"));

  GuardarIntPersistente(oPC, "DESEO_TIEMPO", 1);

  ActionCastFakeSpellAtObject(SPELL_CREATE_GREATER_UNDEAD, oPC, PROJECTILE_PATH_TYPE_DEFAULT);
  DelayCommand(2.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_PWSTUN), oPC));

  DelayCommand(2.6, CreateItemOnObjectVoid("habilidadtiempo", oPC));

  DelayCommand(4.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION), GetLocation(OBJECT_SELF)));
  DestroyObject(OBJECT_SELF, 4.2);
}
