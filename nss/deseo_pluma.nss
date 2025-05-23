#include "mti_libreria"

// VACIAR INVENTARIO DEL JUGADOR (excepto objetos de trama y no soltables)
void VaciarInventario(object oPC)
{
  //Eliminamos los objetos equipados XD
  int i;
  for(i=0;i<=13;i++)
  {
      if(GetIsObjectValid(GetItemInSlot(i, oPC))) DestroyObject(GetItemInSlot(i, oPC));
  }

  //Eliminamos su inventario
  object oItem = GetFirstItemInInventory(oPC);
  while(GetIsObjectValid(oItem))
  {
      // Destroy it if not undroppable
      if(!GetPlotFlag(oItem) &&
         !GetItemCursedFlag(oItem))
      {
          DestroyObject(oItem);
      }
      oItem = GetNextItemInInventory(oPC);
  }
}

void main()
{
  object oPC = GetPCSpeaker();

  // Ifriti ya usado
  SetLocalInt(OBJECT_SELF, "IFRITIUSADO", 1);

  // Solo se pide un deseo una vez
  int iDeseoPluma = ObtenerIntPersistente(oPC, "DESEO_PLUMA");
  if(iDeseoPluma == 1)
  {
      AssignCommand(OBJECT_SELF, SpeakString("¡Pero si ya te he concedido este deseo alguna vez, inepto!"));
      DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION), GetLocation(OBJECT_SELF)));
      DestroyObject(OBJECT_SELF, 2.2);
      return;
  }

  AssignCommand(OBJECT_SELF, SpeakString("Una pluma realmente pesa poco, luego... ¡concedido! ¡no faltaba más!"));

  GuardarIntPersistente(oPC, "DESEO_PLUMA", 1);

  ActionCastFakeSpellAtObject(SPELL_CREATE_GREATER_UNDEAD, oPC, PROJECTILE_PATH_TYPE_DEFAULT);
  DelayCommand(2.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_PWSTUN), oPC));

  VaciarInventario(oPC);

  DelayCommand(4.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION), GetLocation(OBJECT_SELF)));
  DestroyObject(OBJECT_SELF, 4.2);
}
