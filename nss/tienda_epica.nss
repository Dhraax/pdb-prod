#include "mti_libreria"
void main()
{
  object oStore = GetNearestObjectByTag("WP_esmel_t_epico");
  object oPC = GetPCSpeaker();
  effect eRizo = EffectVisualEffect(VFX_FNF_PWSTUN);
  effect eTstop = EffectVisualEffect(VFX_FNF_TIME_STOP);

  AssignCommand(oPC, TakeGoldFromCreature(100000, oPC, TRUE));
  SetXP(oPC, GetXP(oPC) - 10000);
  GuardarIntPersistente(oPC, "TIENDA_EPICA", 1);
  ApplyEffectToObject(DURATION_TYPE_INSTANT, eTstop, oPC);
  ApplyEffectToObject(DURATION_TYPE_INSTANT, eRizo, oPC);

  if(GetObjectType(oStore) == OBJECT_TYPE_STORE) OpenStore(oStore, oPC);
  else ActionSpeakStringByStrRef(53090, TALKVOLUME_TALK);
}
