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
  int iDeseoEntenderMujeres = ObtenerIntPersistente(oPC, "DESEO_ENTENDERMUJERES");
  if(iDeseoEntenderMujeres == 1)
  {
      AssignCommand(OBJECT_SELF, SpeakString("¡Pero si ya te he concedido este deseo alguna vez, inepto!"));
      DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION), GetLocation(OBJECT_SELF)));
      DestroyObject(OBJECT_SELF, 2.2);
      return;
  }

  AssignCommand(OBJECT_SELF, SpeakString("Comprender a las mujeres no es sencillo, ¡aprender de esto deberás!"));

  GuardarIntPersistente(oPC, "DESEO_ENTENDERMUJERES", 1);

  ActionCastFakeSpellAtObject(SPELL_CREATE_GREATER_UNDEAD, oPC, PROJECTILE_PATH_TYPE_DEFAULT);
  DelayCommand(2.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_PWSTUN), oPC));

  DelayCommand(2.6, CreateItemOnObjectVoid("manualparaentend", oPC));

  DelayCommand(4.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION), GetLocation(OBJECT_SELF)));
  DestroyObject(OBJECT_SELF, 4.2);
}
